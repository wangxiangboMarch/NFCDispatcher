//
//  NFCCommandManager.swift
//  NFCDemo
//
//  Created by Laowang on 2023/4/27.
//

import Foundation


class Apdu {
    var name: String = ""
    var type: String = ""
    var apdu: String = ""
}

class NFCCommandManager {
    
    
    static func readCarInfo(session: NFCISO7816TagSession) async -> String {
        let commond = "00A4040008A000000632010105"   //"00A4000002DF33"
        do {
            let tag = try await session.begin()
            let cardInfo = try await tag.sendCommand(commond).toHexString()
            
            print("开始")
            print(cardInfo)
            print("结束")
            return cardInfo
        }catch {
            print("出错了 .... ")
        }
        return ""
    }
    
    func checkApdu() -> String {
        return ""
    }
    
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
//    @Throws(Exception::class)
//    private fun checkApdu(apdu: Apdu, commandCallback: String) {
//        when (apdu.type) {
//            "checkAndReturn" -> {
//                if (isEnd9000(commandCallback)) {
//                    // 下一包 需要加入该 name : "去掉9000的前面字段"
//                    val startStr = commandCallback.substring(0, commandCallback.length - 4)
//                    apdusResult.put(apdu.name, startStr.toUpperCase())
//                } else {
//                    LogUtil.e(TAG, "checkApdu: checkAndReturn = " + false)
//                    throw  Exception("读写卡失败...")
//                }
//            }
//            "checkNoReturn" -> {
//                if (!isEnd9000(commandCallback)) {
//                    LogUtil.e(TAG, "checkApdu: checkNoReturn = " + false)
//                    throw  Exception("读写卡失败...")
//                }
//            }
//            "noCheckReturn" -> {
//                // 在下一包上送的apdusResult中增加键值对<name, 整条apdu返回结果>。
//                apdusResult.put(apdu.name, commandCallback.toUpperCase())
//            }
//            "noCheckNoReturn" -> {
//                //不检查指令返回，也不需要上送这条指令的执行结果。
//            }
//        }
//    }




//do {
//    // 检测 NFCISO7816Tag
//    let tag = try await session.begin()
//    // 这个是 APDU 指令。
//    // 其中 00 B0 为 CLA 和 INS 段，表示读取数据；
//    // 95 0A 为 P1 和 P2 段，
//    // 12 为 LC 段，表示返回数据的长度
//    // 具体的命令是通过制卡厂商获取，出于数据安全，我只在文档中描述了获取卡信息的命令
//    // 发送命令 00B0950A12 并截取前 10 个字节转换为 20 位卡号
//    let cardNo = try await tag.sendCommand("00B0950A12")[0..<10].toHexString()
//    self.cardNo = cardNo
//    // 关闭读取会话
//    session.invalidate(with: "读取成功")
//} catch {
//    print(error)
//}



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
//    @Throws(Exception::class)
//    private fun checkApdu(apdu: Apdu, commandCallback: String) {
//        when (apdu.type) {
//            "checkAndReturn" -> {
//                if (isEnd9000(commandCallback)) {
//                    // 下一包 需要加入该 name : "去掉9000的前面字段"
//                    val startStr = commandCallback.substring(0, commandCallback.length - 4)
//                    apdusResult.put(apdu.name, startStr.toUpperCase())
//                } else {
//                    LogUtil.e(TAG, "checkApdu: checkAndReturn = " + false)
//                    throw  Exception("读写卡失败...")
//                }
//            }
//            "checkNoReturn" -> {
//                if (!isEnd9000(commandCallback)) {
//                    LogUtil.e(TAG, "checkApdu: checkNoReturn = " + false)
//                    throw  Exception("读写卡失败...")
//                }
//            }
//            "noCheckReturn" -> {
//                // 在下一包上送的apdusResult中增加键值对<name, 整条apdu返回结果>。
//                apdusResult.put(apdu.name, commandCallback.toUpperCase())
//            }
//            "noCheckNoReturn" -> {
//                //不检查指令返回，也不需要上送这条指令的执行结果。
//            }
//        }
//    }


//6F508408A000000632010105A54450084D4F545F545F45508701029F0801029F120F4341524420494D41474520303030319F0C1E02403640FFFFFFFF020103104991585000011383202107262025093085009000
//6f508408a000000632010105a54450084d4f545f545f45508701029f0801029f120f4341524420494d41474520303030319f0c1e02403640ffffffff02010310499158500001138320210726202509308500
