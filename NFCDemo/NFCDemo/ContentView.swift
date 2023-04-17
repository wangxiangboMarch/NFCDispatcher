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
            do {
                // 检测 NFCISO7816Tag
                let tag = try await session.begin()
                // 这个是 APDU 指令。
                // 其中 00 B0 为 CLA 和 INS 段，表示读取数据；
                // 95 0A 为 P1 和 P2 段，
                // 12 为 LC 段，表示返回数据的长度
                // 具体的命令是通过制卡厂商获取，出于数据安全，我只在文档中描述了获取卡信息的命令
                // 发送命令 00B0950A12 并截取前 10 个字节转换为 20 位卡号
                let cardNo = try await tag.sendCommand("00B0950A12")[0..<10].toHexString()
                self.cardNo = cardNo
                // 关闭读取会话
                session.invalidate(with: "读取成功")
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
