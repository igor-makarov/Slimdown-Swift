Slimdown
---
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

<a href="https://opensource.org/licenses/MIT" rel="nofollow">
<img src="https://img.shields.io/github/license/mashape/apistatus.svg" alt="License"/>
</a>

<a href="https://travis-ci.org/igor-makarov/Slimdown" rel="nofollow">
<img src="https://travis-ci.org/igor-makarov/Slimdown.svg?branch=master" />
</a>

<a href="https://codecov.io/gh/igor-makarov/Slimdown">
  <img src="https://codecov.io/gh/igor-makarov/Slimdown/branch/master/graph/badge.svg" />
</a>

Slimdown parser, implemented in Swift


## Integration

#### CocoaPods (iOS 8+, OS X 10.9+)

You can use [CocoaPods](http://cocoapods.org/) to install `Slimdown` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'Slimdown', '~> 0.1.0'
end
```

#### Carthage (iOS 8+, OS X 10.9+)

You can use [Carthage](https://github.com/Carthage/Carthage) to install `Slimdown` by adding it to your `Cartfile`:

```
github "igor-makarov/Slimdown" ~> 4.0
```

If you use Carthage to build your dependencies, make sure you have added `Slimdown.framework` to the "Linked Frameworks and Libraries" section of your target, and have included them in your Carthage framework copying build phase.

#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `Slimdown` by adding the proper description to your `Package.swift` file:

```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/igor-makarov/Slimdown.git", from: "0.1.0"),
    ]
)
```
Then run `swift build` whenever you get prepared.

## Usage


## LICENCE
Copyright © 2019 Igor Makarov MIT license