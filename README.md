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

```swift
func setupScreenTracking() {
    AuthorsViewController.self  >>   "Authors (start)"
    QuoteViewController.self    >> { "Quote: "+$0.author.name }
    NewQuoteViewController.self >>   .navigationTitle
    RandomQuoteViewController.computedPageName<<
}

extension UIViewController {

    // Swizzle viewDidAppear and report to your favorite analytics service
    func swizzled_viewDidAppear(animated: Bool) {
        if let name = Swiftalytics.trackingName(for: self) {
            ARAnalytics.pageView(name)
            println("Tracked view controller: "+name)
        }
    }
}
```

## Swift versions

* Swiftalytics 0.5 uses Swift 4.1
* Swiftalytics 0.4 uses Swift 3.0
* Swiftalytics 0.3 uses Swift 2.3
* Swiftalytics 0.2 uses Swift 2.2

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**
>
> To use Swiftalytics with a project targeting iOS 7, you must include the source files directly in your project.

### CocoaPods

To integrate Swiftalytics into your Xcode project using [CocoaPods](https://github.com/cocoapods/cocoapods), specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'Swiftalytics', '~> 0.4'
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
github "MrAlek/Swiftalytics" >= 0.4
```

## Usage

### Declaring tracking names

Use the `setTrackingName(for:)` function to declare a tracking name for a specific view controller type.
The method has several different type signatures for static and dynamic typing.

```swift
// Static
Swiftalytics.setTrackingName(for: MasterViewController.self, name: "Start view")

// Dynamic with closure
Swiftalytics.setTrackingNameForViewController(for: DetailViewController.self) { "Detail: \($0.dataObject.name)" }

// Dynamic using navigation item title
Swiftalytics.setTrackingNameForViewController(for: SettingsViewController.self, trackingType:.navigationTitle)

// Dynamic with function
Swiftalytics.setTrackingNameForViewController(for: OtherViewController.functionProducingAString)
```

### Retrieving tracking names

The `trackingName(for:)` function is used to retrieve the name that has been declared earlier for a specific view controller.
When using dynamic tracking, the tracking name for that view controller is computed when calling this function.

### Reporting view tracking to analytics providers

The recommended approach to report screen tracking when using Swiftalytics is to swizzle `viewDidAppear` on `UIViewController`. See the demo app for an example of how to do this.

[ARAnalytics](https://github.com/orta/ARAnalytics) is recommended for decoupling your app from your chosen provider.

### Recommended setup with custom operators

Using custom operators is highly recommended with Swiftanalytics, in order to achieve a clean DSL.

Since operator overload polluting is a problem in Swift, no operators are declared in the framework.
Instead it is recommended to create a Swift file for view tracking with private scoped operators and declare all page names there.

```swift
postfix operator <<
private postfix func <<<T: UIViewController>(trackClassFunction: @escaping ((T) -> () -> String)) {
    Swiftalytics.setTrackingName(for: trackClassFunction)
}

private func >> <T: UIViewController>(left: T.Type, right: @autoclosure () -> String) {
    Swiftalytics.setTrackingName(for: left, name: right)
}
private func >> <T: UIViewController>(left: T.Type, right: TrackingNameType) {
    Swiftalytics.setTrackingName(for: left, trackingType: right)
}
private func >> <T: UIViewController>(left: T.Type, right: @escaping ((T) -> String)) {
    Swiftalytics.setTrackingName(for: left, nameFunction: right)
}
```

See [ScreenTracking.swift](Example/ScreenTracking.swift) in the demo project for a proposed setup.


## Demo

The included example project shows a recommended view tracking setup with both static and dynamic tracking.

## License

Swiftalytics is available under the MIT license. See the LICENSE file for more info.
