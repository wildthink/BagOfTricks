//
//  SpeechRecordingControl.swift
//  SpeechRecognition
//
//  Created by Stephen Anthony on 24/11/2016.
//  Copyright © 2016 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The control used to allow the user to begin and end speech recording sessions.
@IBDesignable
open class SpeechRecordingControl: UIControl {
    static let preferredDiameter: CGFloat = 60
    static let expandedDiameter: CGFloat = 80
    
    private let microphoneCircleView = CircleView(colour: .blue, diameter: SpeechRecordingControl.preferredDiameter, image: UIImage(named: "Microphone", in: Bundle(for: SpeechRecordingControl.self), compatibleWith: nil)!.withRenderingMode(.alwaysTemplate))
    private var microphoneCircleViewCentreYConstraint: NSLayoutConstraint?
    private let greyCircleView = CircleView(colour: UIColor(white: 0.9, alpha: 1.0), diameter: SpeechRecordingControl.preferredDiameter)
    
    private var isRecording = false {
        didSet {
            microphoneCircleView.diameter = isRecording ? SpeechRecordingControl.expandedDiameter : SpeechRecordingControl.preferredDiameter
//            microphoneCircleViewCentreYConstraint?.constant = isRecording ? -100 : 0
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override open func didMoveToSuperview() {
        microphoneCircleView.colour = tintColor
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isRecording(true, animated: true)
        sendActions(for: .touchDown)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let controlEvent: UIControlEvents = bounds.contains(touch.location(in: self)) ? .touchUpInside : .touchUpOutside
        isRecording(false, animated: true)
        sendActions(for: controlEvent)
    }
    
    private func commonSetup() {
        // Configure our size.
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: SpeechRecordingControl.preferredDiameter),
                heightAnchor.constraint(equalToConstant: SpeechRecordingControl.preferredDiameter)
                ])
        } else {
            // Fallback on earlier versions
        }
        
        greyCircleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(greyCircleView)
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                greyCircleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                greyCircleView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
        } else {
            // Fallback on earlier versions
        }
        
        microphoneCircleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(microphoneCircleView)
        if #available(iOS 9.0, *) {
            microphoneCircleViewCentreYConstraint = microphoneCircleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                microphoneCircleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                microphoneCircleViewCentreYConstraint!
                ])
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func isRecording(_ isRecording: Bool, animated: Bool) {
        self.isRecording = isRecording
        microphoneCircleView.isImageAnimating = isRecording
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: isRecording ? 0.8 : 1.0, initialSpringVelocity: isRecording ? 20 : 0, options: .curveLinear, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

/// The view subclass used to draw circles.
fileprivate class CircleView: UIView {
    private var widthConstraint: NSLayoutConstraint!
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.tintColor = .white
        return imageView
    }()
    
    init(colour: UIColor, diameter: CGFloat, image: UIImage? = nil) {
        super.init(frame: CGRect.zero)
        self.colour = colour
        self.diameter = diameter
        if #available(iOS 9.0, *) {
            widthConstraint = widthAnchor.constraint(equalToConstant: diameter)
        } else {
            // Fallback on earlier versions
        }
        isOpaque = false
        isUserInteractionEnabled = false
        imageView.image = image
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    /// The diameter of the receiver.
    var diameter: CGFloat = 0 {
        didSet {
            widthConstraint.constant = diameter
        }
    }
    
    /// The colour of the receiver.
    var colour = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// Controls whether the image view animates to highlight its contents or not.
    var isImageAnimating = false {
        didSet {
            guard isImageAnimating else {
                imageView.layer.removeAllAnimations()
                return
            }
            let transformAnimation = CABasicAnimation(keyPath: "transform.scale")
            transformAnimation.duration = 0.5
            transformAnimation.fromValue = 1.0
            transformAnimation.toValue = 1.2
            transformAnimation.repeatCount = .infinity
            transformAnimation.autoreverses = true
            transformAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.duration = transformAnimation.duration
            opacityAnimation.fromValue = 0.7
            opacityAnimation.toValue = 1.0
            opacityAnimation.repeatCount = transformAnimation.repeatCount
            opacityAnimation.autoreverses = transformAnimation.autoreverses
            opacityAnimation.timingFunction = transformAnimation.timingFunction
            imageView.layer.add(transformAnimation, forKey: nil)
            imageView.layer.add(opacityAnimation, forKey: nil)
        }
    }
    
    fileprivate override func draw(_ rect: CGRect) {
        super.draw(rect)
        colour.set()
        UIBezierPath(ovalIn: rect).fill()
    }
    
    fileprivate override func updateConstraints() {
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                widthConstraint,
                heightAnchor.constraint(equalTo: widthAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        } else {
            // Fallback on earlier versions
        }
        super.updateConstraints()
    }
}
