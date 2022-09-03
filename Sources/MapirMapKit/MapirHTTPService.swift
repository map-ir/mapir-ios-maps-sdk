import Foundation
import MapboxMaps

public final class MapirHTTPService: NSObject {
    private var session: URLSession = .shared

    private var downloadTaskCallbacks: [Int: DownloadStatusCallback] = [:]

    public static func register() {
        HttpServiceFactory.setUserDefinedForCustom(MapirHTTPService())
    }
}

extension MapirHTTPService: HttpServiceInterface {
    private var methodMap: [HttpMethod: String] {
        [
            .get: "GET",
            .head: "HEAD",
            .post: "POST"
        ]
    }

    public func request(for request: HttpRequest, callback: @escaping HttpResponseCallback) -> UInt64 {
        let url = URL(string: request.url)!
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod          = methodMap[request.method]!
        urlRequest.httpBody            = request.body
        urlRequest.allHTTPHeaderFields = request.headers

        if url.isHostedByMapir() {
            urlRequest.addMapirSpecificHeaders()
        }

        let task = session.dataTask(with: urlRequest) { data, response, error in
            let result: Result<HttpResponseData, HttpRequestError>

            if let error = error {
                let requestError = HttpRequestError(type: .otherError, message: error.localizedDescription)
                result = .failure(requestError)
            } else if let response = response as? HTTPURLResponse, let data = data {

                var headers: [String: String] = [:]
                for (key, value) in response.allHeaderFields {
                    guard let key = key as? String,
                          let value = value as? String else {
                        continue
                    }

                    headers[key.lowercased()] = value
                }

                if url.isHostedByMapir() {
                    if response.statusCode == 403 {
                        MapirAccountManager.shared.receivedUnauthorizedStatusCode()
                    }
                }

                let responseData = HttpResponseData(headers: headers, code: Int64(response.statusCode), data: data)
                result = .success(responseData)
            } else {
                let requestError = HttpRequestError(type: .otherError, message: "Invalid response")
                result = .failure(requestError)
            }

            let response = HttpResponse(request: request, result: result)
            callback(response)
        }

        task.resume()

        return UInt64(task.taskIdentifier)
    }


    public func download(for options: DownloadOptions, callback: @escaping DownloadStatusCallback) -> UInt64 {
        let request = options.request
        let url = URL(string: request.url)!
        var urlRequest = URLRequest(url: url)

        let methodMap: [HttpMethod: String] = [
            .get: "GET",
            .head: "HEAD",
            .post: "POST"
        ]

        urlRequest.httpMethod          = methodMap[request.method]!
        urlRequest.httpBody            = request.body
        urlRequest.allHTTPHeaderFields = request.headers

        if url.isHostedByMapir() {
            urlRequest.addMapirSpecificHeaders()
        }

        let task: URLSessionDownloadTask
        if options.isResume, let url = URL(string: options.localPath), let data = try? Data(contentsOf: url) {
            task = session.downloadTask(withResumeData: data) { [weak self] location, response, error in
                guard let self = self else { return }
                let result = self.handleDownloadResponse(url: url, options: options, location: location, response: response, error: error)
                callback(result)
            }
        } else {
            task = session.downloadTask(with: urlRequest) { [weak self] location, response, error in
                guard let self = self else { return }
                let result = self.handleDownloadResponse(url: url, options: options, location: location, response: response, error: error)
                self.downloadTaskCallbacks.removeValue(forKey: task.taskIdentifier)
                callback(result)
            }
        }

        task.resume()
        downloadTaskCallbacks[task.taskIdentifier] = callback

        return UInt64(task.taskIdentifier)

    }

    private func handleDownloadResponse(url: URL, options: DownloadOptions, location: URL?, response: URLResponse?, error: Error?) -> DownloadStatus {
        let result: Result<HttpResponseData, HttpRequestError>
        let downloadState: DownloadState
        var downloadError: DownloadError?
        var receivedData: Data?


        if let error = error {
            let requestError = HttpRequestError(type: .otherError, message: error.localizedDescription)

            result = .failure(requestError)
            downloadState = .failed
            downloadError = DownloadError(code: .networkError, message: error.localizedDescription)
        } else if let response = response as? HTTPURLResponse, let location = location {
            var headers: [String: String] = [:]
            for (key, value) in response.allHeaderFields {
                guard let key = key as? String,
                      let value = value as? String else {
                    continue
                }

                headers[key.lowercased()] = value
            }

            if url.isHostedByMapir() {
                if response.statusCode == 403 {
                    MapirAccountManager.shared.receivedUnauthorizedStatusCode()
                }
            }

            do {
                let data = try Data(contentsOf: location)
                receivedData = data
                let responseData = HttpResponseData(headers: headers, code: Int64(response.statusCode), data: data)
                result = .success(responseData)
                downloadState = .finished
                downloadError = nil
            } catch {
                let requestError = HttpRequestError(type: .otherError, message: error.localizedDescription)
                result = .failure(requestError)
                downloadState = .failed
                downloadError = DownloadError(code: .fileSystemError, message: error.localizedDescription)
            }
        } else {
            let requestError = HttpRequestError(type: .otherError, message: "Invalid response")
            result = .failure(requestError)
            downloadState = .failed
            downloadError = DownloadError(code: .networkError, message: "Invalid response")
        }

        let response = DownloadStatus(
            downloadId: UInt64(1),
            state: downloadState,
            error: downloadError,
            totalBytes: UInt64(response?.expectedContentLength ?? 0),
            receivedBytes: UInt64(receivedData?.count ?? 0),
            transferredBytes: UInt64(receivedData?.count ?? 0),
            downloadOptions: options,
            httpResult: result
        )

        return response
    }

    public func cancelRequest(forId id: UInt64, callback: @escaping ResultCallback) {
        session.getAllTasks { tasks in
            if let task = tasks.first(where: { $0.taskIdentifier == UInt(id) }) {
                task.cancel()
                callback(true)
            } else {
                callback(false)
            }
        }
    }

    public func setInterceptorForInterceptor(_ interceptor: HttpServiceInterceptorInterface?) {}

    public func setMaxRequestsPerHostForMax(_ max: UInt8) {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = Int(max)
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    public func supportsKeepCompression() -> Bool {
        false
    }
}

extension MapirHTTPService: URLSessionDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

    }
}

extension MapirHTTPService: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let result = handleDownloadResponse(url: url, options: <#T##DownloadOptions#>, location: <#T##URL?#>, response: <#T##URLResponse?#>, error: <#T##Error?#>)
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let callback = downloadTaskCallbacks[downloadTask.taskIdentifier] else { return }
        let downloadStatus = DownloadStatus(
    }
}
