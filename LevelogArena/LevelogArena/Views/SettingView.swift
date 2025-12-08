//
//  SettingView.swift
//  LevelogArena
//

import SwiftUI

struct SettingView: View {

    var body: some View {

        NavigationView {

            List { // ⬅︎ リストでリンクアイテムを管理

                NavigationLink(destination: Text("🍊").font(.system(size: 200))) {

                    Text("オレンジ")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                } // オレンジ

                NavigationLink(destination: Text("🍎").font(.system(size: 200))) {

                    Text("リンゴ")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                } // リンゴ

            } // List ここまで

        } // NavigationView ここまで
    } // body
} // View
