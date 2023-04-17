//
//  NFCISO7816Tag.swift
//  NFCDemo
//
//  Created by Laowang on 2023/4/17.
//

import CoreNFC
import CryptoSwift


@available(iOS 13.0, *)
extension NFCISO7816Tag {
    
    @discardableResult
    func sendCommand(_ command: String) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            // 通过 CryptoSwift 库提供的 API，将十六进制表示命令字符串转换成字节
            let apdu = NFCISO7816APDU(data: Data(hex: command))!
            // 将同步调用形式转换成异步调用形式
            sendCommand(apdu: apdu) { responseData, _, _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: responseData)
                }
            }
        }
    }
}
