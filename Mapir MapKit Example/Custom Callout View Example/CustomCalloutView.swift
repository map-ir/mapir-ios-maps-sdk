//
//  CustomCalloutView.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 27/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import Foundation
import MapirMapKit

// 1: To create a custom callout view, You should create a subclass of UIView which
// conforms to MGLCalloutView protocol. To conform to MGLCalloutView, there are
// some properties that you should define in the class body.
class CustomCalloutView: UIView, MGLCalloutView {

    // 2: It contains the object that the callout view is used for.
    var representedObject: MGLAnnotation

    // 3: Allows the callout to remain open when the user moves the map.
    let dismissesAutomatically: Bool = false

    // 4: Determines that the view is anchored to the annotation itself or not.
    let isAnchoredToAnnotation: Bool = true

    // 5: You have to override center propery. Otherwise the callout view changes
    // position when the map moves. By default center of the view is bound to top
    // center point of the annotation view.
    override var center: CGPoint {
        set {
            // Move center of the view upward with amount equal to half of the height of the
            // view. This makes sure that bottom line of the view is bound to the top line of
            // annotation.
            var newCenter = newValue
            newCenter.y -= bounds.height / 2
            super.center = newCenter
        }
        get {
            return super.center
        }
    }

    // 6: It is necessary to define right and left accessory views, but since we don't need
    // them, we will assign an empty instace of UIView to them.
    var rightAccessoryView: UIView = UIView()
    var leftAccessoryView: UIView = UIView()

    // 7: We want our callout to be a UIButton.
    let button: UIButton

    // 8: It's also necessary to define a delegate property as it is needed in
    // MGLCalloutView protocol. It needs to be a weak var to avoid memory cycles.
    weak var delegate: MGLCalloutViewDelegate?

    // 9: Create a new initializer that accepts a MGLAnnotation object, which is the
    // one that the callout view will represent. So we assign it to representedObject
    // property.
    init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject

        button = UIButton(type: .system)

        super.init(frame: .zero)

        // 10: Customize the appearnce of the button and the view itself as needed.
        backgroundColor = .clear

        button.backgroundColor = .systemTeal
        button.tintColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.cornerRadius = 4.0

        addSubview(button)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 11: This method is also required to be defined. This is called when map view
    // wants to present a callout for the annotation. We will add this view to the
    // input view.
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {

        // 12: Inform the delegate that callout is going to appear.
        delegate?.calloutViewWillAppear?(self)

        // 13: Add self as subview of view.
        view.addSubview(self)

        // 14: Prepare the button by customizing and resizing.
        button.setTitle(representedObject.title ?? "", for: .normal)
        button.sizeToFit()

        // 15: If the callout view is allowed be highlighted, add a target to the button.
        // Otherwise, disable the user interaction for the button.
        if isCalloutTappable {

            // 16: Handle taps and send the event to delegate.
            button.addTarget(self, action: #selector(calloutTapped(_:)), for: .touchUpInside)
        } else {
            isUserInteractionEnabled = false
        }

        // 17: Prepare the view's frame.
        let frameWidth = button.bounds.width
        let frameHeight = button.bounds.height
        let frameOriginX = rect.origin.x + (rect.width / 2.0) - (frameWidth / 2.0)
        let frameOriginY = rect.origin.y - frameHeight

        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)

        // 18: Animate the appearance of the callout view if needed.
        if animated {
            alpha = 0
            UIView.animate(
                withDuration: 0.2,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.alpha = 1
                }, completion: { [weak self] (_) in
                    // 19: When the animation finishes and callout appears, send the event to the
                    // delegate.
                    guard let self = self else { return }
                    self.delegate?.calloutViewDidAppear?(self)
                }
            )
        } else {
            self.delegate?.calloutViewDidAppear?(self)
        }
    }

    // 20: Implement this function and handle the disappearance of the callout view.
    func dismissCallout(animated: Bool) {
        if superview != nil {
            if animated {
                UIView.animate(
                    withDuration: 0.2,
                    animations: { [weak self] in
                        self?.alpha = 0
                    },
                    completion: { [weak self] (_) in
                        self?.removeFromSuperview()
                    }
                )
            } else {
                removeFromSuperview()
            }
        }
    }

    // 21: If delegate implements `func calloutViewShouldHighlight(_:)` and return
    // value is true, it means that the callout view is tappable. Otherwise the callout
    // view is not tappable.
    var isCalloutTappable: Bool {
        return delegate?.calloutViewShouldHighlight?(self) ?? false

    }

    // 22: Handle taps on the callout by informing it's delegate.
    @objc func calloutTapped(_ sender: Any?) {
        if isCalloutTappable {
            delegate?.calloutViewTapped?(self)
        }
    }
}
