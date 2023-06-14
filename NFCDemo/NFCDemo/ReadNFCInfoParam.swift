//
//  ReadNFCInfoParam.swift
//  NFCDemo
//
//  Created by Laowang on 2023/6/12.
//

import Foundation
import WLYUIKitBase
import CoreNFC

struct ReadNFCInfoParam: Codable {
    let apdus: String
    /// apdu 指令执行结果集，根据前一包返回 apdu 指令得到对应值（需要加上上一包返回的 apdusResult）
    var apdusResult: [String: String]
    let process: String
    var result: Res
    let result_code: String
    let result_msg: String
    let seq_no: String
    let sign: String
    let sign_type: String
    let timestamp: String
    let trans_data: TransData
    let version: String
    /// 卡复位值
    let ats: String?
    
    struct Res: Codable {
        let annualCheckDate: String?
        let cardCSN: String?
        let cardCreatDate: String?
        let cardEndDate: String?
        let cardForegift: String?
        let cardMediaType: String?
        let cardNo: String?
        let cardRealBalance: String?
        let cardSoldDate: String?
        let cardStartDate: String?
        let cardStatus: String?
        let cardStatusDes: String?
        
        
        let cardType: String?
        let cardholderIdNo: String?
        let cardholderIdType: String?
        let cardholderName: String?
        let cardholderType: String?
        let creditMonthEx: String?
        
        let employeeType: String?
        let existPhotoArea: String?
        let issuer: String?
        let monthBegin: String?
        
        let monthEnd: String?
        let publishCode: String?
        let ypCardBalance: String?
        let ypCardBalanceEx: String?
        let ypCardIsUsed: String?
        let ypCardType: String?
        let ypEvenMonth1: String?
        let ypEvenMonth10: String?
        
        let ypEvenMonth11: String?
        let ypEvenMonth12: String?
        let ypEvenMonth2: String?
        let ypEvenMonth3: String?
        let ypEvenMonth4: String?
        let ypEvenMonth5: String?
        let ypEvenMonth6: String?
        let ypEvenMonth7: String?
        
        let ypEvenMonth8: String?
        let ypEvenMonth9: String?
        let ypEvenTotal: String?
        let ypEvenYear: String?
        let ypOddMonth1: String?
        let ypOddMonth10: String?
        let ypOddMonth11: String?
        let ypOddMonth12: String?
        
        let ypOddMonth2: String?
        let ypOddMonth3: String?
        let ypOddMonth4: String?
        let ypOddMonth5: String?
        let ypOddMonth6: String?
        let ypOddMonth7: String?
        let ypOddMonth8: String?
        let ypOddMonth9: String?
        
        let ypOddTotal: String?
        let ypOddYear: String?
        let ypPurseFlats: String?
    }
    
    struct TransData: Codable {
        let standard: String
        let tradeTime: String
        let physNo: String
        let cardUid: String
        let oper: String
    }
}


struct ResultModel: Codable {
    let code: String
    let message: String
    let data: ReadNFCInfoParam?
}

class ViewModel {
    
    let session = NFCISO7816TagSession()
    
    var res: ReadNFCInfoParam?
    
    var ats: String = ""
    
    var tag: NFCISO7816Tag?
    
    init() {
        
    }
    
    func readCardInfo() async -> String {
        
        do {
            let tag = try await session.begin()
            let ats: String = tag.historicalBytes?.hexadecimal() ?? ""
            self.ats = ats
            self.tag = tag
            getDAtya(apdusResult: [:], ats: ats)
            
        }catch {
            print("出错了 .... ")
        }
        return ""
    }
    
    /**
         * 检查指令
         *
         * @param apdu.type
         * 分为4种：
         * checkAndReturn：检查apdu指令返回最后4位是否为9000，如果等于9000则在下一包上送的apdusResult中增加键值对<name, 去掉9000的前面字段>，如果不等于则直接报错。
         * checkNoReturn：检查apdu指令返回最后4位是否为9000，如果等于9000则继续执行后面的步骤，如果不等于则直接报错。
         * noCheckReturn：不检查指令返回，在下一包上送的apdusResult中增加键值对<name, 整条apdu返回结果>。
         * noCheckNoReturn：不检查指令返回，也不需要上送这条指令的执行结果。
         * @param commandCallback 对应指令返回的结果
         */
    func checkApdu(aduStr: String) async {
        
        let adus = try! pumpkinDecoder(jsonstr: aduStr, modelType: [Apdu].self)
        
        if !adus.isEmpty {
            var res: [String: String] = [:]
            
            for item in adus {

                do {
                    let info = try await tag?.sendCommand(item.apdu).hexadecimal()
                    switch item.type {
                    case "checkAndReturn":
                        // 检测是否是9000 结尾
                        res[item.name] = info?.uppercased()
                    case "noCheckReturn":
                        let info = try await tag?.sendCommand(item.apdu).hexadecimal()
                        res[item.name] = info?.uppercased()
                    default:
                        print("fail ....")
                    }
                }catch {
                    print("fail !!!!")
                }
            }
            
            getDAtya(apdusResult: res, ats: ats)
        }else{
            print("结束了 ...")
        }
    }
    
    func getDAtya(apdusResult: [String: String], ats: String) {
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
            do {
                let result = try pumpkinDecoder(jsonstr: str, modelType: ResultModel.self)
                
                self.res = result.data
                Task {
                    await self.checkApdu(aduStr: result.data?.apdus ?? "")
                }
                
            }catch {
                
            }
            
        }
        task.resume()
    }
    
}

