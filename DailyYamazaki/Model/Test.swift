//
//  Test.swift
//  DailyYamazaki
//
//  Created by 重盛晴二 on 2021/02/19.
//

import Foundation
import FirebaseFirestore


struct test {
    init() {
        
    }
//    共通で使う
    let db = Firestore.firestore()
//        topImageのデータを取得したい
    func testFirestore () {
        db.collection("home").document("top").collection("topImage").addSnapshotListener { (snap, err) in
//            エラーの確認をして処理を終了
        if let err = err {
            print(err.localizedDescription)
            return
        }
        print(snap.debugDescription)
        }
    }
}
