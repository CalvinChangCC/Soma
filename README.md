![Version](https://img.shields.io/badge/pod-2.0.0-blue.svg)  ![Build Pass](https://img.shields.io/continuousphp/git-hub/doctrine/dbal/master.svg)  ![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)  ![License](https://img.shields.io/cocoapods/l/Presentr.svg?style=flat)



## About

This library is use for change the color in run time, by the different style file, the system can change the color at runtime.




## What's New

#### 2.0.0
- Remove all the project dependency
- Change UIButton's IBInspectable property name 

#### 1.0.1

- Several bug fix 

#### 1.0.0
- First release




## Supported Swift Versions
- Swift 4



## Installation

### [Cocoapods](http://cocoapods.org)

```ruby
use_frameworks!

pod 'SAPThemeManager'
```

### Manually
1. Download and drop ```/Classes``` folder in your project.
2. You're done!



## Getting started

### Create a Style File

It is **important to create the style file use the following format** and store in json format

Your **Style File** can be as simple as this:

```json
{
    "ColorName1": "HexString",
    "ColorName2": "HexString",
    ...
}
```


### Setup in AppDelegate

Samply insert the code at **didFinishLaunchingWithOptions** method

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SAPThemeManager.initWith(theme: "StyleFileName")
        
        return true
    }
```

Instantiate the View Controller you want to present and use the customPresentViewController method along with your **Presentr** object to do the custom presentation.



## Change Color

### Label

```swift
label.backgroundColorKey = "ColorKey1"
```
#### 

### Button

```swift
button.setTitleColorKey("ColorKey2", for: .normal)
button.setTitleColorKey("ColorKey3", for: .highlighted)
```

And more...



## Requirements

* iOS 9.0+
* Xcode 8.0+
* Swift 4.0+



##  Author
Calvin Chang



## License
Presentr is released under the MIT license.
See LICENSE for details.