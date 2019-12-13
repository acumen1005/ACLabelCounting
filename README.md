# ACLabelCounting

[中文版](./readME_CN.md)

Adds animated counting to UILabel for swift

![](ACLabelCounting.gif)

## Installation

To integrate ACLabelCounting into your Xcode project using CocoaPods, specify it in your Podfile:

```swift

pod 'ACLabelCounting'
```

## Usage

You can initialize an ACLabelCounting, and call mehtod `count` , then you get an animated counting label

Linear animation of counts from 0 to 100, data type is integer

```swift
label.count(to: 100)
```

Count animation from 10 to 100. Duration is 5 seconds. Animation type is fade-in effect. Data type is Double.

```swift
label.count(from: 10,
            to: 100,
            duration: 5,
            animationType: .EaseIn,
            dataType: .Double)
```

Counting animation from 0 to 100, duration is 5 seconds, animation type is fade-out effect, data type is Int type. String formatting adds a `%` to the end of the string.

```swift
label.count(from: 0,
            to: 100,
            duration: 5,
            animationType: .EaseOut,
            dataType: .Int) { txt in
                return "\(txt) %"
        }
```

Count animation from 0 to 100. Duration is 5 seconds. Animation type is fade-in effect. Data type is Int. String formatting is to add `/ 100` to the string face, and its color is bright gray.

```swift
label.count(from: 0,
                    to: 100,
                    duration: 5,
                    animationType: .EaseIn,
                    dataType: .Int) { text -> NSAttributedString in
                        let appandString = " / 100"
                        let string = "\(text)\(appandString)"
                        let range = (string as NSString).range(of: appandString)

                        let attributedString = NSMutableAttributedString(string: string)
                        attributedString.addAttribute(NSForegroundColorAttributeName,
                                                      value: UIColor.lightGray,
                                                      range: range)
                        return attributedString;
        }
```

That's all. If you want to add more powerful features, please post an issue for me.

## Source Analytics

the enum of datatype

```swift
enum ACLabelCountingDataType {
    case Int
    case Double
}
```

the types of counting animation : no effect (same as linear), linear, fade-in, fade-out, fade-in. 

```swift
enum ACLabelCountingAnimationType {
    case None
    case Liner
    case EaseIn
    case EaseOut
    case EaseInOut
}
```

Their corresponding functions:

```swift
extension ACLabelCounting {
    func liner(progress: Double, totle: Double) -> Double {
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
```

ACLabelCountting has 5 operations：

- start()
- pause()
- restore()
- stop()
- reset()

The key is to use the `CADisplayLink` timer to execute the `updateNumber` task at a rate of 35 times per second and add it to the Runloop in .commonModes mode.

```swift
private func fireDisplayLink() {
        lastUpdate = Date.timeIntervalSinceReferenceDate
        displayLink = CADisplayLink(target: self, selector: #selector(updateNumber))
        displayLink.preferredFramesPerSecond = LabelCountingConst.countRate
        displayLink.add(to: RunLoop.main, forMode: .commonModes)
    }
```

It has two simple custom closures: `formatTextClosure` and `attributedTextClosure`. You can implement string processing yourself. It will all appear on your screen.

```swift
private var formatTextClosure: ((String) -> String) = { text -> String in return text }

private var attributedTextClosure: ((String) -> NSAttributedString)?
```

## Thanks

https://github.com/dataxpress/UICountingLabel  
it is a repo for swift. Thanks ~
