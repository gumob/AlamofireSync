//
//  AlamofireSyncTests.swift
//  AlamofireSyncTests
//
//  Created by kojirof on 2020/07/09.
//  Copyright © 2020 kojirof. All rights reserved.
//

import XCTest
import Alamofire
@testable import AlamofireSync

class AlamofireSyncTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /** DataRequest */
    func testDataRequestImage() throws {
        let response = AF.request("https://httpbin.org/image/jpeg")
                .response()
        dump(response)
        XCTAssertNotNil(response.value!)
        XCTAssertNil(response.error)
        #if os(iOS) || os(tvOS)
        let image = UIImage(data: response.data!)
        XCTAssertNotNil(image)
        #elseif os(OSX)
        let image = NSImage(data: response.data!)
        XCTAssertNotNil(image)
        #endif
    }

    func testDataRequestData() throws {
        let response = AF.request("https://httpbin.org/image/png")
                .responseData()
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
        #if os(iOS) || os(tvOS)
        let image = UIImage(data: response.data!)
        XCTAssertNotNil(image)
        #elseif os(OSX)
        let image = NSImage(data: response.data!)
        XCTAssertNotNil(image)
        #endif
    }

    func testDataRequestGetJSON() throws {
        let response = AF.request("https://httpbin.org/json")
                .responseJSON()
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
    }

    func testDataRequestPostJSON() throws {
        let response = AF.request("https://httpbin.org/post",
                        method: .post,
                        parameters: ["foo": "bar"],
                        encoding: JSONEncoding.default)
                .responseJSON(options: .allowFragments)
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
    }

    func testDataRequestString() throws {
        let response = AF.request("https://httpbin.org/robots.txt")
                .responseString(encoding: .utf8)
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
    }

    /** DownloadRequest */
    func testDownloadRequestNormal() throws {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("testDownloadRequestNormal.txt")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let response = AF.download("https://httpbin.org/stream/100", method: .get, to: destination)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }.response()
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
    }

    func testDownloadRequestData() throws {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("testDownloadRequestData.jpg")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let response = AF.download("https://httpbin.org/image/jpeg", method: .get, to: destination)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }.responseData()
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
        #if os(iOS) || os(tvOS)
        let image = UIImage(data: response.value!)
        XCTAssertNotNil(image)
        #elseif os(OSX)
        let image = NSImage(data: response.value!)
        XCTAssertNotNil(image)
        #endif
    }

    func testDownloadRequestJSON() throws {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("testDownloadRequestJSON.json")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let response = AF.download("https://httpbin.org/json", method: .get, to: destination)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }.responseJSON()
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
    }

    func testDownloadRequestString() throws {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("testDownloadRequestString.txt")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let response = AF.download("https://httpbin.org/robots.txt", to: destination)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }.responseString(encoding: .utf8)
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
    }

    func testDownloadRequestQueue() throws {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("testDownloadRequestQueue.txt")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let response = AF.download("https://httpbin.org/stream/100", method: .get, to: destination)
                .downloadProgress(queue: DispatchQueue.global(qos: .default)) { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                    DispatchQueue.main.async {
                        // code at here will be delayed before the synchronous finished.
                    }
                }.responseString()
        dump(response)
        XCTAssertNotNil(response)
        XCTAssertNil(response.error)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
