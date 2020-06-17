import Foundation
import AsyncDisplayKit

public final class ContextControllerSourceNode: ASDisplayNode {
    private var contextGesture: ContextGesture?
    
    public var isGestureEnabled: Bool = true {
        didSet {
            self.contextGesture?.isEnabled = self.isGestureEnabled
        }
    }
    public var activated: ((ContextGesture, CGPoint) -> Void)?
    public var shouldBegin: ((CGPoint) -> Bool)?
    public var customActivationProgress: ((CGFloat, ContextGestureTransition) -> Void)?
    public var targetNodeForActivationProgress: ASDisplayNode?
    public var targetNodeForActivationProgressContentRect: CGRect?
    
    public func cancelGesture() {
        self.contextGesture?.cancel()
        self.contextGesture?.isEnabled = false
        self.contextGesture?.isEnabled = self.isGestureEnabled
    }
    
    override public func didLoad() {
        super.didLoad()
        
        let contextGesture = ContextGesture(target: self, action: nil)
        self.contextGesture = contextGesture
        self.view.addGestureRecognizer(contextGesture)
        
        contextGesture.shouldBegin = { [weak self] point in
            guard let strongSelf = self, !strongSelf.bounds.width.isZero else {
                return false
            }
            return strongSelf.shouldBegin?(point) ?? true
        }
        
        contextGesture.activationProgress = { [weak self] progress, update in
            guard let strongSelf = self, !strongSelf.bounds.width.isZero else {
                return
            }
            if let customActivationProgress = strongSelf.customActivationProgress {
                customActivationProgress(progress, update)
            } else {
                let targetNode: ASDisplayNode
                let targetContentRect: CGRect
                if let targetNodeForActivationProgress = strongSelf.targetNodeForActivationProgress {
                    targetNode = targetNodeForActivationProgress
                    if let targetNodeForActivationProgressContentRect = strongSelf.targetNodeForActivationProgressContentRect {
                        targetContentRect = targetNodeForActivationProgressContentRect
                    } else {
                        targetContentRect = CGRect(origin: CGPoint(), size: targetNode.bounds.size)
                    }
                } else {
                    targetNode = strongSelf
                    targetContentRect = CGRect(origin: CGPoint(), size: targetNode.bounds.size)
                }
                
                let scaleSide = targetContentRect.width
                let minScale: CGFloat = max(0.7, (scaleSide - 15.0) / scaleSide)
                let currentScale = 1.0 * (1.0 - progress) + minScale * progress
                
                let originalCenterOffsetX: CGFloat = targetNode.bounds.width / 2.0 - targetContentRect.midX
                let scaledCaneterOffsetX: CGFloat = originalCenterOffsetX * currentScale
                
                let originalCenterOffsetY: CGFloat = targetNode.bounds.height / 2.0 - targetContentRect.midY
                let scaledCaneterOffsetY: CGFloat = originalCenterOffsetY * currentScale
                
                let scaleMidX: CGFloat = scaledCaneterOffsetX - originalCenterOffsetX
                let scaleMidY: CGFloat = scaledCaneterOffsetY - originalCenterOffsetY
                
                switch update {
                case .update:
                    let sublayerTransform = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, currentScale, currentScale, 1.0), scaleMidX, scaleMidY, 0.0)
                    targetNode.layer.sublayerTransform = sublayerTransform
                case .begin:
                    let sublayerTransform = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, currentScale, currentScale, 1.0), scaleMidX, scaleMidY, 0.0)
                    targetNode.layer.sublayerTransform = sublayerTransform
                case .ended:
                    let sublayerTransform = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, currentScale, currentScale, 1.0), scaleMidX, scaleMidY, 0.0)
                    let previousTransform = targetNode.layer.sublayerTransform
                    targetNode.layer.sublayerTransform = sublayerTransform
                    
                    targetNode.layer.animate(from: NSValue(caTransform3D: previousTransform), to: NSValue(caTransform3D: sublayerTransform), keyPath: "sublayerTransform", timingFunction: CAMediaTimingFunctionName.easeOut.rawValue, duration: 0.2)
                }
            }
        }
        contextGesture.activated = { [weak self] gesture, location in
            if let activated = self?.activated {
                activated(gesture, location)
            } else {
                gesture.cancel()
            }
        }
        contextGesture.isEnabled = self.isGestureEnabled
    }
}
