//
//  LoadData.swift
//  DailyYamazaki
//
//  Created by 重盛晴二 on 2021/02/18.
//

import Foundation
import FirebaseFirestore

protocol GetTopDataProtocol {
    func topImageUrlGetData(dataArray:[String])
}
protocol GetHomeDataProtocol {
    func homeGetData(urlDataArray:[String],textDataArray:[String])
}

class LoadData {
    
    let db = Firestore.firestore()
    
    var topImageUrlArray = [String]()
    var getTopDataProtocol:GetTopDataProtocol?
//        ホームの上のimageUrl取得
    func loadTopImage() {
        
        db.collection("home").document("top").collection("topImage").addSnapshotListener { (snap, err) in
            
            self.topImageUrlArray = []
            
            if let err = err {
                print("topImageError: ",err)
                return
            }
            
            if let snapDoc = snap?.documents {
               
                for doc in snapDoc {
                    let data = doc.data()
                    
                    if let imageStr = data["image"] as? String {
                        
                        self.topImageUrlArray.append(imageStr)
                        
                    }
                }
            }
            self.getTopDataProtocol?.topImageUrlGetData(dataArray: self.topImageUrlArray)
        }
    }
    
//    ホームの縦スクロールのimageUrl,textを取得
    var homeImageUrlArray = [String]()
    var homeTextArray = [String]()
    var getHomeDataProtocol:GetHomeDataProtocol?
    
    func loadHomeImage() {
        
        db.collection("home").document("body").collection("bodyImage").addSnapshotListener { (snap, err) in
            
            self.homeImageUrlArray = []
            self.homeTextArray = []
            
            if let err = err {
                print("homeImageError: ",err)
                return
            }
            
            if let snapDoc = snap?.documents {
                
                for doc in snapDoc {
                    let data = doc.data()
                    
                    if let imageStr = data["image"] as? String,let text = data["text"] as? String {
                        
                        self.homeImageUrlArray.append(imageStr)
                        self.homeTextArray.append(text)
                        
                    }
                }
            }
            self.getHomeDataProtocol?.homeGetData(urlDataArray: self.homeImageUrlArray, textDataArray: self.homeTextArray)
        }

    }
}
