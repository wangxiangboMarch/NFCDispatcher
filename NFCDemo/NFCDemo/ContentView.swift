//
//  ContentView.swift
//  NFCDemo
//
//  Created by Laowang on 2023/4/17.
//

import SwiftUI

struct ContentView: View {
    @State private var cardNo = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("卡号：\(cardNo)")
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
        Task {
            let session = NFCISO7816TagSession()
            let cardNo = await NFCCommandManager.readCarInfo(session: session)
            self.cardNo = cardNo
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
