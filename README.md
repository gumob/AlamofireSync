[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/gumob/AlamofireSync)
[![Version](http://img.shields.io/cocoapods/v/AlamofireSync.svg)](http://cocoadocs.org/docsets/AlamofireSync)
[![Platform](http://img.shields.io/cocoapods/p/AlamofireSync.svg)](http://cocoadocs.org/docsets/AlamofireSync)
[![Build Status](https://travis-ci.com/gumob/AlamofireSync.svg?branch=master)](https://travis-ci.com/gumob/AlamofireSync)
[![codecov](https://codecov.io/gh/gumob/AlamofireSync/branch/master/graph/badge.svg)](https://codecov.io/gh/gumob/AlamofireSync)
![Language](https://img.shields.io/badge/Language-Swift%205.0-orange.svg)
![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)

# AlamofireSync
<code>AlamofireSync</code> is a Swift extension that allows synchronous requests for [Alamofire](https://github.com/Alamofire/Alamofire).<br/>

## Requirements

- iOS 10.0 or later
- macOS 10.12 or later
- tvOS 10.0 or later
- watchOS 3.0 or later
- Swift 5

## Installation

### Carthage

Add the following to your `Cartfile` and follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

```
github "gumob/AlamofireSync"
```

### CocoaPods

To integrate AlamofireSync into your project, add the following to your `Podfile`.

```ruby
pod 'AlamofireSync'
```

## Usage

Request an image:

```swift
let response = AF.request("https://httpbin.org/image/jpeg")
        .response()
if let data = response.data {
    let image = UIImage(data: data)
}
```

## Copyright

AlamofireSync is released under MIT license, which means you can modify it, redistribute it or use it however you like.
