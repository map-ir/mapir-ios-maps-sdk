import Foundation
import UIKit

class AttributionView: UIView {
    private let label: UILabel = UILabel()
    private let blurView: UIVisualEffectView = UIVisualEffectView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupAppearance()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = (bounds.height - 4) / 2
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }

    private func addSubviews() {
        addSubview(blurView)
        addSubview(label)
    }

    private func setupAppearance() {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1)

        label.text = "© Map.ir © OpenSreetMap"
        label.font = UIFont.init(descriptor: fontDescriptor, size: fontDescriptor.pointSize)
        label.textColor = .black

        clipsToBounds = true

        if #available(iOS 13.0, *) {
            blurView.effect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        } else {
            blurView.effect = UIBlurEffect(style: .light)
        }
    }

    private func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
