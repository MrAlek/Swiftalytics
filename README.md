# Swiftalytics
[![Version](https://img.shields.io/cocoapods/v/Swiftalytics.svg?style=flat)](http://cocoadocs.org/docsets/Swiftalytics)
[![License](https://img.shields.io/cocoapods/l/Swiftalytics.svg?style=flat)](http://cocoadocs.org/docsets/Swiftalytics)
[![Platform](https://img.shields.io/cocoapods/p/Swiftalytics.svg?style=flat)](http://cocoadocs.org/docsets/Swiftalytics)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


`Swiftalytics` lets you use Aspect Oriented Programming to
declare all the analytics view tracking for your app on
neat one-liners in a single file!

* Supports both static and dynamic view tracking
  * Assign your own closures with correct type inference
* Flexible tracking (not forced to viewDidAppear)
* Works great with [ARAnalytics](https://github.com/orta/ARAnalytics)
* Built for Swift 2

```swift
func setupScreenTracking() {
    AuthorsViewController.self  >>   "Authors (start)"
    QuoteViewController.self    >> { "Quote: "+$0.author.name }
    NewQuoteViewController.self >>   .NavigationTitle
    RandomQuoteViewController.computedPageName<<
}

extension UIViewController {

    // Swizzle viewDidAppear and report to your favorite analytics service
    func swizzled_viewDidAppear(animated: Bool) {
        if let name = Swiftalytics.trackingNameForViewController(self) {
            ARAnalytics.pageView(name)
            println("Tracked view controller: "+name)
        }
    }
}
```

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**
>
> To use Swiftalytics with a project targeting iOS 7, you must include the `Swiftalytics.swift` source file directly in your project.

### CocoaPods

To integrate Swiftalytics into your Xcode project using [CocoaPods](https://github.com/cocoapods/cocoapods), specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'Swiftalytics', '~> 0.2'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Swiftalytics into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "MrAlek/Swiftalytics" >= 0.2
```

## Usage

### Declaring tracking names

Use the `setTrackingNameForViewController` function to declare a tracking name for a specific view controller type.
The method has several different type signatures for static and dynamic typing.

```swift
// Static
Swiftalytics.setTrackingNameForViewController(MasterViewController.self, name: "Start view")

// Dynamic with closure
Swiftalytics.setTrackingNameForViewController(DetailViewController.self) { "Detail: \($0.dataObject.name)" }

// Dynamic using navigation item title
Swiftalytics.setTrackingNameForViewController(SettingsViewController.self, trackingType:.NavigationTitle)

// Dynamic with function
Swiftalytics.setTrackingNameForViewController(OtherViewController.functionProducingAString)
```

### Retrieving tracking names

The `trackingNameForViewController` function is used to retrieve the name that has been declared earlier for a specific view controller.
When using dynamic tracking, the tracking name for that view controller is computed when calling this function.

### Reporting view tracking to analytics providers

```swift
extension UIViewController {
    func viewDidAppear(animated: Bool) {
        if let name = Swiftalytics.trackingNameForViewController(self) {
            // Report to your analytics service
            println("Tracked view controller: "+name)
        }
    }
}
```

By extending UIViewController, you can choose when in the view lifecycle to send analytics events to your provider's SDK or for internal logging.
[ARAnalytics](https://github.com/orta/ARAnalytics) is highly recommended to decouple your app from your chosen provider.

### Recommended setup with custom operators

The recommended approach to use Swiftalytics is with custom operators, in order to achieve a clean DSL.
Since operator overload polluting is a problem in Swift, no operators are declared in the framework.
Instead it is recommended to create a Swift file for view tracking with private scoped operators and declare all page names there.

```swift
postfix operator << { }
private postfix func <<<T: UIViewController>(trackClassFunction: (T -> () -> String)) {
    Swiftalytics.setTrackingNameForViewController(trackClassFunction)
}

private func >> <T: UIViewController>(left: T.Type, @autoclosure right: () -> String) {
    Swiftalytics.setTrackingNameForViewController(left, name: right)
}
private func >> <T: UIViewController>(left: T.Type, right: TrackingNameType) {
    Swiftalytics.setTrackingNameForViewController(left, trackingType: right)
}
private func >> <T: UIViewController>(left: T.Type, right: (T -> String)) {
    Swiftalytics.setTrackingNameForViewController(left, nameFunction: right)
}
```

See [ScreenTracking.swift](Example/ScreenTracking.swift) in the demo project for a proposed setup.


## Demo

The included example project shows a recommended view tracking setup with both static and dynamic tracking.

## License

Swiftalytics is available under the MIT license. See the LICENSE file for more info.
