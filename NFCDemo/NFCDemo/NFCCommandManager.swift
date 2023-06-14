//
//  NFCCommandManager.swift
//  NFCDemo
//
//  Created by Laowang on 2023/4/27.
//

import Foundation


struct Apdu: Codable {
    var name: String = ""
    var type: String = ""
    var apdu: String = ""
}

//class NFCCommandManager {
//
//    static func readCarInfo(session: NFCISO7816TagSession, commond: String) async -> String {
//        // let commond = "00A4040008A000000632010105"   //"00A4000002DF33"
//        do {
//            let tag = try await session.begin()
//            let cardInfo = try await tag.sendCommand(commond).toHexString()
//            print("开始")
//            print(cardInfo)
//            print("结束")
//            return cardInfo
//        }catch {
//            print("出错了 .... ")
//        }
//        return ""
//    }
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
