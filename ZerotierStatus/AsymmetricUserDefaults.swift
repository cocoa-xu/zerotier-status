//
//  AsymmetricUserDefaults.swift
//  copy-paste from Siddhant Kumar
//
//  Created by Cocoa on 28/06/23.
//

import Foundation
import CryptoKit

class AsymmetricUserDefaults {
    private let publicKeyTag = "ZerotierStatusPubkey"
    private let privateKeyTag = "ZerotierStatusPrivkey"
    
    private var publicKey: SecKey? {
        retrieveKey(tag: publicKeyTag)
    }
    
    private var privateKey: SecKey? {
        retrieveKey(tag: privateKeyTag)
    }
    
    private func generateKeyPair() throws {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 4096
        ]
        
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, nil) else {
            throw KeyGenerationError.failed
        }
        
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw KeyGenerationError.failed
        }
        
        saveKey(publicKey, tag: publicKeyTag)
        saveKey(privateKey, tag: privateKeyTag)
    }
    
    private func saveKey(_ key: SecKey, tag: String) {
        let query: [String: Any] = [
            kSecValueRef as String: key,
            kSecAttrApplicationTag as String: tag
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func retrieveKey(tag: String) -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecReturnRef as String: true
        ]
        
        var key: CFTypeRef?
        SecItemCopyMatching(query as CFDictionary, &key)
        
        return key as! SecKey?
    }
    
    private func encryptValue(_ value: Data) throws -> Data {
        guard let publicKey = publicKey else {
            throw EncryptionError.missingPublicKey
        }
        
        return SecKeyCreateEncryptedData(publicKey, .rsaEncryptionOAEPSHA512, value as CFData, nil)! as Data
    }
    
    private func decryptValue(_ encryptedData: Data) throws -> Data {
        guard let privateKey = privateKey else {
            throw EncryptionError.missingPrivateKey
        }
        
        return SecKeyCreateDecryptedData(privateKey, .rsaEncryptionOAEPSHA512, encryptedData as CFData, nil)! as Data
    }
    
    func setValue(_ value: String, forKey key: String) throws {
        if privateKey == nil || publicKey == nil {
            try generateKeyPair()
        }
        
        guard let data = value.data(using: .utf8) else {
            throw EncryptionError.invalidData
        }
        
        let encryptedData = try encryptValue(data)
        UserDefaults.standard.set(encryptedData, forKey: key)
    }
    
    func getValue(forKey key: String) throws -> String? {
        guard let encryptedData = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        let decryptedData = try decryptValue(encryptedData)
        return String(data: decryptedData, encoding: .utf8)
    }
    
    func deleteValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    enum KeyGenerationError: Error {
        case failed
    }
    
    enum EncryptionError: Error {
        case missingPublicKey
        case missingPrivateKey
        case invalidData
    }
}
