//
//  ContentView.swift
//  NFCDemo
//
//  Created by Laowang on 2023/4/17.
//

import SwiftUI

struct ContentView: View {
    @State private var cardNo = ""
    
    let data = ViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("读取到的内容：\(cardNo)")
                .font(.system(size: 17))
            Button(action: read) {
                Text("读取")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
    
    private func read() {

        let commod = "00A404000E325041592E5359532E4444463031"
        // 发送命令 00B0950A12 并截取前 10 个字节转换为 20 位卡号
        
        //  这个是 APDU 指令。
        //  其中 00 B0 为 CLA 和 INS 段，表示读取数据；
        // 95 0A 为 P1 和 P2 段，
        // 12 为 LC 段，表示返回数据的长度
        // 具体的命令是通过制卡厂商获取，出于数据安全，我只在文档中描述了获取卡信息的命令
        // 发送命令 00B0950A12 并截取前 10 个字节转换为 20 位卡号
        
        let commod2 = "00B0950A12"
        let session = NFCISO7816TagSession()
        
        Task {
            await data.readCardInfo()
//            do {
//                let tag = try await session.begin()
//
//                self.cardNo = try await tag.sendCommand(commod2)[0..<10].hexadecimal()
//
//            }catch {
//                self.cardNo = "错错了"
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


///**
//     * 获取卡类型
//     * @return [String] 卡类型 “LOCAL","JTB"
//     */
//    private fun getCardType() :String{
//        try {
//            val byte: ByteArray? = requestCommand(hexStringToBytes("00A4040008A000000632010105")!!)//读卡
//            val callData = bytesToHexString(byte)!!
//            LogUtil.d(TAG, "cardType: " + bytesToHexString(byte)!!)
//            if(isEnd9000(callData)){
//                return "JTB"
//            }else {
//                return "LOCAL"
//            }
//        } catch (e: Exception) {
//            mNfcReadyListener?.nfcReadyError(e.message!!)
//            return ""
//        }
//    }



/**
     * 判断最后四位是否为9000
     *
     * @return
     */
//    private fun isEnd9000(str: String): Boolean {
//        if (TextUtils.isEmpty(str) || str.length < 4) return false
//        val newstr = str.substring(str.length - 4)
//        return newstr.equals("9000")
//    }
