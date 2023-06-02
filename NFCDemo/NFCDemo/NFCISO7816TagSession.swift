//
//  NFCISO7816TagSession.swift
//  NFCDemo
//
//  Created by Laowang on 2023/4/17.
//

import Foundation
import CoreNFC
import WLYUIKitBase

/// 封装 NFCTagReaderSession

@available(iOS 13.0, *)
class NFCISO7816TagSession: NSObject, NFCTagReaderSessionDelegate {
    
    private var session: NFCTagReaderSession? = nil
    private var sessionContinuation: CheckedContinuation<NFCISO7816Tag, Error>? = nil
    
    func begin() async throws -> NFCISO7816Tag {
        // 实例化用于检测 NFCISO7816Tag 的会话
        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "请将社保卡靠近手机背面上方的 NFC 感应区域"
        session?.begin()
        return try await withCheckedThrowingContinuation { continuation in
            self.sessionContinuation = continuation
        }
    }
    
    func invalidate(with message: String) {
        // 关闭读取会话，以防止重用
        session?.alertMessage = message
        session?.invalidate()
    }
    
    static func getDAtya(ats: String) {
        let timestam = Date.nowString(dateFormat: "yyyyMMddHHmmss")
        
        let url = "https://zhx1.16bus.net/api/appClient/noAuth/nfcRecharge/v1/readCard"
        let apdusResult: [String: String] = [:]
        let param1 = [
            "apdusResult": apdusResult,
            "ats":ats,
            "customer_code":nil,
            "dataType":nil,
            "operator_no":nil,
            "params": ["isCheckBLK":"00","ocxTime":"\(timestam)"],
            "process":"request",
            "result":apdusResult,
            "result_code":"",
            "result_msg":"",
            "seq_no":"",
            "sign":"",
            "sign_type":"md5",
            "tenantCode": nil,
            "terminal_no":nil,
            "timestamp":"\(timestam)",
            "trans_data":["standard":"JTB"],
            "version":nil
        ] as [String : Any?]
        
        
        var  jsonData = NSData()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: param1, options: []) as NSData
        } catch {
            print(error.localizedDescription)
        }
        let session =  URLSession.shared
        
        var request = URLRequest(url: URL(string: url)!)
        // 设置Content-Length，非必须
        request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
        // 设置 Content-Type 为 json 类型
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // POST    请求将 数据 放置到 请求体中
        request.httpBody = jsonData as Data
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request) { data, resp, error in
            let str = String(data: data!, encoding: .utf8)
            print(str)
        }
        task.resume()
    }
    
    // MARK: - NFCTagReaderSessionDelegate
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {}
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        // 检测到 NFCISO7816Tag
        if let tag = tags.first, case .iso7816(let iso7816Tag) = tag {
            session.alertMessage = "正在读取信息，请勿移动社保卡"
            // 连接到 NFCISO7816Tag 并将同步调用形式转换成异步调用形式
//            session.connect(to: tag) { error in
//                if let error {
//                    self.sessionContinuation?.resume(throwing: error)
//                } else {
//                    self.sessionContinuation?.resume(returning: iso7816Tag)
//                }
//            }
            let ats: String = iso7816Tag.historicalBytes?.toHexString() ?? ""
            print("数据： ......开始")
            print(iso7816Tag.historicalBytes?.toHexString())
            print("数据： .......结束")
//                self.getDAtya(ats: ats)
            
        }
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // 读取过程中发生错误
        self.session = nil
        sessionContinuation?.resume(throwing: error)
    }
    
//    + (NFCSupportsStatus)isSupportsNFCReading {
//        if (@available(iOS 11.0,*)) {
//            if (NFCNDEFReaderSession.readingAvailable == YES) {
//                return NFCSupportStatusYes;
//            }
//            else{
//                NSLog(@"%@",@"该机型不支持NFC功能!");
//                return NFCSupportStatusDeviceNo;
//            }
//        }
//        else {
//            NSLog(@"%@",@"当前系统不支持NFC功能!");
//            return NFCSupportStatusnSystemNo;
//        }
//    }
//
//    + (NFCSupportsStatus)isSupportsNFCWrite{
//        if (@available(iOS 13.0,*)) {
//            if (NFCNDEFReaderSession.readingAvailable == YES) {
//                return NFCSupportStatusYes;
//            }
//            else{
//                NSLog(@"%@",@"该机型不支持NFC功能!");
//                return NFCSupportStatusDeviceNo;
//            }
//        }
//        else {
//            NSLog(@"%@",@"当前系统不支持NFC功能!");
//            return NFCSupportStatusnSystemNo;
//        }
//    }
    
//    - (void)startScan {
//
//        //最低硬件支持iphone7或7plus，系统最低支持为iOS11；
//        if ([WLNFCTagManager isSupportsNFCReading] == NFCSupportStatusYes) {
//            if (NFCNDEFReaderSession.readingAvailable){
//                self.session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:nil invalidateAfterFirstRead:NO];
//                [self.session setAlertMessage:@"开始读卡啦"];
//                [self.session beginSession];
//            }
//        }
//        else
//        {
//          NSLog(@"不支持")
//        }
//    }
}
