//
//  ACLabelCounting.swift
//  ACLabelCounting
//
//  Created by acumen on 17/2/16.
//  Copyright © 2017年 acumen. All rights reserved.
//

import UIKit

struct LabelCountingConst {
    static let countRate = 35
    static let defaultDuration = 2.0
}

enum ACLabelCountingAnimationType {
    case none
    case linear
    case easeIn
    case easeOut
    case easeInOut
}

enum ACLabelCountingDataType {
    case int
    case double
}

class ACLabelCounting: UILabel {
    
    private var progress: Double = 0
    private var dataType: ACLabelCountingDataType = .int
    private var animationType: ACLabelCountingAnimationType = .none
    private var duration: TimeInterval = LabelCountingConst.defaultDuration
    private var displayLink: CADisplayLink! = CADisplayLink()
    private var lastUpdate: TimeInterval = Date.timeIntervalSinceReferenceDate
    
    // number
    private var startValue: Double = 0
    private var endValue: Double = 0
    
    // closure
    private var formatTextClosure: ((String) -> String) = { text -> String in return text }
    private var attributedTextClosure: ((String) -> NSAttributedString)?
    
    @objc func updateNumber(value: TimeInterval) {
        let now = Date.timeIntervalSinceReferenceDate
        progress += Double(now - self.lastUpdate)
        self.lastUpdate = now
        
        let scale = renderScale(type: animationType)
        accumulation(text: (endValue - startValue) * scale + startValue)
    }
    
    private func accumulation(text: Double) {
        let txt = handleText(with: text, type: dataType)
        if let closure = attributedTextClosure {
            self.attributedText = closure(txt)
        } else {
            self.text = formatTextClosure(txt)
        }
        
        if progress >= duration {
            if let closure = attributedTextClosure {
                self.attributedText = closure(handleText(with: endValue, type: dataType))
            } else {
                self.text = formatTextClosure(handleText(with: endValue, type: dataType))
            }
            self.invalidateDisplayLink()
        }
    }
    
    private func invalidateDisplayLink() {
        guard displayLink != nil else {
            return
        }
        displayLink.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
        displayLink.invalidate()
        displayLink = nil
    }
    
    private func fireDisplayLink() {
        lastUpdate = Date.timeIntervalSinceReferenceDate
        displayLink = CADisplayLink(target: self, selector: #selector(updateNumber))
        if #available(iOS 10, *) {
            displayLink.preferredFramesPerSecond = LabelCountingConst.countRate
        } else {
            displayLink.frameInterval = LabelCountingConst.countRate / 35
        }
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    private func handleText(with: Double, type: ACLabelCountingDataType) -> String {
        switch type {
        case .int:
            return String(format: "%.0lf", with)
        case .double:
            return String(format: "%.2lf", with)
        }
    }
    
    private func renderScale(type: ACLabelCountingAnimationType) -> Double {
        switch type {
        case .none, .linear:
            return linear(progress: progress, totle: Double(duration))
        case .easeIn:
            return easeIn(progress: progress, totle: Double(duration))
        case .easeOut:
            return easeOut(progress: progress, totle: Double(duration))
        case .easeInOut:
            return easeInOut(progress: progress, totle: Double(duration))
        }
    }
    
    private func initText(value: Double) {
        accumulation(text: value)
    }
    
    /// publish method
    func pause() {
        invalidateDisplayLink()
    }
    
    func restore() {
        self.lastUpdate = Date.timeIntervalSinceReferenceDate
        fireDisplayLink()
    }
    
    func start() {
        fireDisplayLink()
    }
    
    func stop() {
        invalidateDisplayLink()
    }
    
    func reset() {
        invalidateDisplayLink()
        if let closure = attributedTextClosure {
            count(from: startValue,
                  to: endValue,
                  duration: duration,
                  animationType: animationType,
                  dataType: dataType,
                  attributedTextClosure: closure)
        } else {
            count(from: startValue,
                  to: endValue,
                  duration: duration,
                  animationType: animationType,
                  dataType: dataType,
                  formatTextClosure: formatTextClosure)
        }
    }
    
    func count(from fromValue: Double = 0.0,
               to toValue: Double,
               duration time: TimeInterval = LabelCountingConst.defaultDuration,
               animationType: ACLabelCountingAnimationType = .none,
               dataType: ACLabelCountingDataType = .int,
               formatTextClosure: @escaping (String) -> String = { text -> String in return text }) {
        
        assert((fromValue >= 0 && toValue >= 0), "the fromValue or toValue must be not negative!")
        
        progress = 0
        self.dataType = dataType
        self.formatTextClosure = formatTextClosure
        self.startValue = fromValue
        self.endValue = toValue
        self.animationType = animationType
        self.duration = time
        
        initText(value: startValue)
    }
    
    func count(from fromValue: Double = 0.0,
               to toValue: Double,
               duration time: TimeInterval = LabelCountingConst.defaultDuration,
               animationType: ACLabelCountingAnimationType = .none,
               dataType: ACLabelCountingDataType = .int,
               attributedTextClosure: @escaping (String) -> NSAttributedString) {
        
        self.attributedTextClosure = attributedTextClosure
        count(from: fromValue,
              to: toValue,
              duration: time,
              animationType: animationType,
              dataType: dataType)
    }
}

extension ACLabelCounting {
    func linear(progress: Double, totle: Double) -> Double {
        return progress / totle
    }
    
    func easeIn(progress: Double, totle: Double) -> Double {
        return pow(progress / totle, 3)
    }
    
    func easeOut(progress: Double, totle: Double) -> Double {
        let t = progress / totle
        return  1 - pow(1 - t, 3)
    }
    
    func easeInOut(progress: Double, totle: Double) -> Double {
        let t = progress / totle
        return t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
    }
}
