//
//  KeychainManager.swift
//  Olimp
//
//  Created by Artem Balashov on 12/10/2018.
//  Copyright © 2018 Egor Sakhabaev. All rights reserved.
//

import Foundation
import Security

class Keychain: NSObject {
    
    static public func setPasscode(identifier: String, passcode: String?) {
        var passString = ""
        if let passcode = passcode {
            passString = passcode
        }
        let dataFromString: NSData = passString.data(using: String.Encoding.utf8)! as NSData;
        let keychainQuery = NSDictionary(
            objects: [kSecClassGenericPasswordValue, identifier, dataFromString],
            forKeys: [kSecClassValue, kSecAttrServiceValue, kSecValueDataValue]);
        SecItemDelete(keychainQuery as CFDictionary);
        let status : OSStatus = SecItemAdd(keychainQuery as CFDictionary, nil);
        print (status)
    }
    
    static public func getPasscode(identifier: String) -> String? {
        let keychainQuery = NSDictionary(
            objects: [kSecClassGenericPasswordValue, identifier, kCFBooleanTrue, kSecMatchLimitOneValue],
            forKeys: [kSecClassValue, kSecAttrServiceValue, kSecReturnDataValue, kSecMatchLimitValue]);
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var passcode: NSString!;
        if (status == errSecSuccess) {
            let retrievedData: NSData? = dataTypeRef as? NSData
            if let result = NSString(data: retrievedData! as Data, encoding: String.Encoding.utf8.rawValue) {
                passcode = result as NSString
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
            return nil
        }
        if passcode == "" {
            return nil
        }
        return passcode as String
    }
    
    static public func clearAll(){
        _ = KeychainStoredData.allCases.map { Keychain.setPasscode(identifier: $0.rawValue, passcode: "") }
    }
    
}

enum KeychainStoredData: String, CaseIterable {
    case deviceUDID
}

let kSecAttrAccessGroupValue = NSString(format: kSecAttrAccessGroup)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword);
let kSecClassValue = NSString(format: kSecClass);
let kSecAttrServiceValue = NSString(format: kSecAttrService);
let kSecValueDataValue = NSString(format: kSecValueData);
let kSecMatchLimitValue = NSString(format: kSecMatchLimit);
let kSecReturnDataValue = NSString(format: kSecReturnData);
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne);
let kSecAttrAccountValue = NSString(format: kSecAttrAccount);
