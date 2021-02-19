//
//  LoadData.swift
//  DailyYamazaki
//
//  Created by 重盛晴二 on 2021/02/18.
//

import Foundation
import FirebaseFirestore

protocol GetDataProtocol {
    func topImageUrlGetData(dataArray:[String])
}

class HomeTopLoadImage {
    let db = Firestore.firestore()
    var topImageUrlArray = [String]()
    var getDataProtocol:GetDataProtocol?
    
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
            self.getDataProtocol?.topImageUrlGetData(dataArray: self.topImageUrlArray)
            
            
        }
    }
}
