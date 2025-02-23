//
//  Initialization.swift
//  TPInAppReceipt
//
//  Created by Pavel Tikhonenko on 05/02/17.
//  Copyright © 2017-2021 Pavel Tikhonenko. All rights reserved.
//

import Foundation

/// An InAppReceipt extension helps to initialize the receipt
public extension InAppReceiptT
{
    /// Creates and returns the 'InAppReceipt' instance from data object
    ///
    /// - Returns: 'InAppReceipt' instance
    /// - throws: An error in the InAppReceipt domain, if `InAppReceipt` cannot be created.
    static func receipt(from data: Data) throws -> InAppReceiptT
    {
        return try InAppReceiptT(receiptData: data)
    }
    
    /// Creates and returns the 'InAppReceipt' instance using local receipt
    ///
    /// - Returns: 'InAppReceipt' instance
    /// - throws: An error in the InAppReceipt domain, if `InAppReceipt` cannot be created.
    static func localReceipt() throws -> InAppReceiptT
    {
        let data = try Bundle.main.appStoreReceiptData()
        return try InAppReceiptT.receipt(from: data)
    }
    
}

/// A Bundle extension helps to retrieve receipt data
public extension Bundle
{
    /// Retrieve local App Store Receip Data
    ///
    /// - Returns: 'Data' object that represents local receipt
    /// - throws: An error if receipt file not found or 'Data' can't be created
    func appStoreReceiptData() throws -> Data
    {
		guard let receiptUrl = appStoreReceiptURL,
			FileManager.default.fileExists(atPath: receiptUrl.path) else
		{
			throw IARError.initializationFailed(reason: .appStoreReceiptNotFound)
		}
		
		do {
			return try Data(contentsOf: receiptUrl)
		}catch{
			throw IARError.initializationFailed(reason: .appStoreReceiptNotFound)
		}
    }
    
    /// Retrieve local App Store Receip Data in base64 string
    ///
    /// - Returns: 'Data' object that represents local receipt
    /// - throws: An error if receipt file not found or 'Data' can't be created
    func appStoreReceiptBase64() throws -> String
    {
        return try appStoreReceiptData().base64EncodedString()
    }
    
    class func lookUp(forResource name: String, ofType ext: String?) -> String?
    {
		
		if let p = Bundle.module.path(forResource: name, ofType: ext)
		{
			return p
		}
		
        if let p = Bundle.main.path(forResource: name, ofType: ext)
        {
            return p
        }
        
        for f in Bundle.allFrameworks
        {
            if let identifier = f.bundleIdentifier, identifier.contains("TPInAppReceipt"),
                let p = f.path(forResource: name, ofType: ext)
            {
                return p
            }
        }
        
        return nil
    }
}

