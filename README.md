![Version](https://img.shields.io/badge/pod-1.0.2-blue.svg)  ![Build Pass](https://img.shields.io/continuousphp/git-hub/doctrine/dbal/master.svg)  ![Swift 4.2](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)  ![License](https://img.shields.io/cocoapods/l/Presentr.svg?style=flat)



## About

Package the Socket.io library to the abstraction layer, here are some awesome features

- Split namespace and emit data to each classes
- Easy to make stub data for test
- Plugin for states




## What's New

#### 1.0.2
- Add change configure mechanism 

#### 1.0.1

- Several bug fix 

#### 1.0.0
- First release




## Supported Swift Versions
- Swift 4+



## Installation

### [Cocoapods](http://cocoapods.org)

```ruby
use_frameworks!

pod 'Soma'
```

### Manually
1. Download and drop ```/Classes``` folder in your project.
2. You're done!



## Getting started

### Create Provider

It is **socket connecter and controller** 

Provider is like:

```swift
let provider = SomaProvider<SocketType>(serverURL: URL(string: "http://test.domain.com") ?? URL(fileURLWithPath: ""), plugins: [SomaLoggerPlugin(verbose: true)])
```



### Create event object

It's object is use for receive the event

```swift
class SocketEvent: SomaEventType {
    var name = "update"

    func didReceiveEvent(message: SomaMessage) {
        print("[DEBUG] Receive message \(try! message.mapJson())")
    }
}
```



### Create Emit Data

Create the **emit information** if you need

``` swift
class SocketEmitInfo: SomaEmitType {
    var key = "join"

    var value: SomaEmitData {
        return ["Emit information"]
    }
}
```



### Create Target Object

It is **namespace** object with event and, create object and use provider to connect to the socket

The object as simple as this:

```swift
enum SocketType: SomaTargetType {
    case message(SomaEmitType, SomaEventType)
    case stateUpdate(SomaEventType)
    case infoUpdate([SomaEventType])

    var namespace: String {
        switch self {
        case .message:
            return "/message"
        case .stateUpdate:
            return "/stateUpdate"
        case .infoUpdate:
            return "/infoUpdate"
        }
    }

    var timeoutInterval: TimeInterval {
        return 5
    }

    var emitInfo: SomaEmitType? {
        switch self {
        case .message(let info, _):
            return info
        default:
            return nil
        }
    }

    var vaildateEvents: [SomaEventType]? {
        switch self {
        case .message(_, let event):
            return [event]
        case .stateUpdate(let event):
            return [event]
        case .infoUpdate(let events):
            return events
        }
    }
}

```



## Plugin

If there is extra action needed after connect, disconnect, will emit data, etc.

Plugin is useful for this situation!

By implement the plugin protocol and setup to provider, all the extra action will be operated after those situation

```swift
public protocol SomaPluginType {
    func didConnect(target: SomaTargetType)

    func didDisconnect(target: SomaTargetType)

    func willEmit(target: SomaTargetType, emit: SomaEmitType) -> SomaEmitType

    func didReceive(target: SomaTargetType, message: SomaMessage)

    func process(target: SomaTargetType, message: SomaMessage) -> SomaMessage

    func didTimeout(target: SomaTargetType)

    func didErrorOccur(target: SomaTargetType, errors: [Any])
}

```





## Requirements

* iOS 9.0+
* Xcode 8.0+
* Swift 4.0+



##  Author
Calvin Chang



## License
Presentr is released under the MIT license.
See LICENSE for details.