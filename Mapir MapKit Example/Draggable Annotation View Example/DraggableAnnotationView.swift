//
//  DraggableAnnotationView.swift
//  Mapir MapKit Example
//
//  Created by Alireza Asadi on 27/11/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

import UIKit
import MapirMapKit

class DraggableAnnotationView: MGLAnnotationView {

    // 1: Create a new initilizer that makes a draggable annotation view.
    init(reuseIdentifier: String?, size: CGSize) {
        super.init(reuseIdentifier: reuseIdentifier)

        // 2: isDraggable is a property of MGLAnnotationView and it indicated whether the
        // view isDraggable or not. It's false by default.
        isDraggable = true

        // 3: This property prevents the annotation from changing size when the map is tilted.
        scalesWithViewingDistance = false

        // 4: Set up the appearance of the view.
        frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        backgroundColor = .darkGray

        layer.cornerRadius = max(size.height, size.width) / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2
    }

    // 5: define these two initializers that are forced by the Swift.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 6: Using this method we can handle the dragging state of the annotation view.
    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)

        switch dragState {
        case .starting:
            startDragging()
            print("Dragging started -> ", terminator: "")
        case .dragging:
            print("+", terminator: "")
        case .ending, .canceling:
            endDragging()
            print(" | Dragging ended")
        case .none:
            break
        @unknown default:
            fatalError("Unknown drag state.")
        }
    }

    /// Updates the appearance of the view to be semi transparrent and a larger when it
    /// is being dragged.
    private func startDragging() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.layer.opacity = 0.8
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            }
        )

        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
        hapticFeedback.impactOccurred()
    }

    /// Sets the appearance of the view to the default when dragging ends.
    private func endDragging() {
        transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.layer.opacity = 1.0
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            }
        )

        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
        hapticFeedback.impactOccurred()
    }
}
