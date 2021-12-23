//
//  OfflineManager.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//

import UIKit
import SwiftyJSON


final class OfflineManager: NSObject {
    static let shared = OfflineManager()
    
    var isProcessing = false
    
    private override init() {
        
    }
    
    func startOfflineProcess() {
        if isProcessing {
            print("offline uploading is in process already.")
            return
        }
        isProcessing = true
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        var bgTask: UIBackgroundTaskIdentifier = .init(rawValue: 0)
        
        
        appDelegate.persistentContainer.performBackgroundTask { context in
            let visitInfoFetchRequest = VisitInfo.fetchRequest()
            let predicate1 = NSPredicate(format: "finished == %@", NSNumber(value: true))
            let predicate2 = NSPredicate(format: "submitted == %@", NSNumber(value: false))
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            visitInfoFetchRequest.predicate = predicate
            
            let offlineGeocodeRequest = OfflineGeocode.fetchRequest()
            let pred = NSPredicate(format: "isDone == %@", NSNumber(value: false))
            offlineGeocodeRequest.predicate = pred

            
            do {
                let visitInfos = try context.fetch(visitInfoFetchRequest) as [VisitInfo]
                let offlines = try context.fetch(offlineGeocodeRequest) as [OfflineGeocode]
                
                if visitInfos.isEmpty && offlines.isEmpty {
                    print("no content for offline uploading")
                    self.isProcessing = false
                    return
                }
                
                // offline uploading starts
                bgTask = UIApplication.shared.beginBackgroundTask(withName: "bgTask") {
                    print("running in background")
                    self.isProcessing = false
                    if bgTask != .invalid {
                        print("background uploading finished successfully")
                    } else {
                        print("background uploading finished failed")
                    }
                }
                
                let group = DispatchGroup()
                var cks = [String]()
                
                for visit in visitInfos {
                    cks.append(visit.clubKey!)
                    let current = visit
                    group.enter()
                    self.uploadOffline(visit: current) {
                        current.submitted = true
                        group.leave()
                    }
                }
                
                for offline in offlines {
                    let current = offline
                    group.enter()
                    self.uploadOffline(geocode: current) {
                        current.isDone = true
                        group.leave()
                    }
                }
                
                
                
                group.notify(queue: .main) {
                    self.isProcessing = false
                    context.perform {
                        do {
                            if context.hasChanges {
                                try context.save()
                            } else {
                                print("no changes from offline to submit")
                            }
                        } catch {
                            print("save offline changes failed.")
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(Constatns.offlineDoneNotification), object: nil, userInfo: ["CLUB_KEYS": cks])
                        }
                        UIApplication.shared.endBackgroundTask(bgTask)
                    }
                }
                
            } catch {
                print("fetch offline visits failed")
                self.isProcessing = false
                UIApplication.shared.endBackgroundTask(bgTask)

            }
            
        }
        
    }
    
    private func uploadOffline(visit: VisitInfo, completion: @escaping () -> ()) {
        upload(dict: prepareRequestBody(visit: visit), completion: completion)
    }
    
    private func uploadOffline(geocode: OfflineGeocode, completion: @escaping () -> ()) {
        if let clubKey = geocode.clubKey, let g = geocode.geocode {
            var dict = [String: String]()
            dict["ClubKey"] = clubKey
            dict["GeoCode"] = g
            upload(dict: dict, completion: completion)
        } else {
            completion()
        }
        
    }
    
    private func upload(dict: [String: Any], completion: @escaping () -> ()) {
        guard let url = URL(string: Constatns.url + Constatns.createVisit) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("offlien data: \(String(describing: data))")
            if error != nil {
                // show error message and then go back
                print("offline upload error: \(String(describing: error))")
                completion()
                return
            }
            if let data = data {
                guard let json = try? JSON(data: data) else {
                    print("parsing offlien response failed")
                    completion()
                    return
                }
                print("offline submit visit response json: \(json)")
                if let errorCode = json["ErrorCode"].string, errorCode == "0" {
                    print("offline visit number: \(json["VisitNumber"].stringValue)")
                } else {
                    print("offline submit visit error code is not 0")
                }
            }
            completion()
        }.resume()
    }
    
    private func prepareRequestBody(visit: VisitInfo) -> [String: Any] {
        var dict = [String: Any]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        dict["ClubKey"] = visit.clubKey!
        dict["VisitDate"] = dateFormatter.string(from:(visit.visitDate!))
        var ans = [Any]()
        visit.answers!.enumerateObjects { elem, idx, _ in
            let a = elem as! AnswerInfo
            var temp = [String: Any]()
            temp["QuestionType"] = a.questionType!
            temp["QuestionKey"] = a.questionKey!
            temp["Comment"] = a.comment ?? ""
            temp["CategoryId"] = a.categoryId!
            var tempAns = [String]()
            if a.questionType == "USER_ENTRY" {
                temp["OtherTextBox"] = a.textBox ?? "$122"
            }

            for idx in a.ans! {
                let ddi = a.items?.object(at: idx) as! DropDownItem
                tempAns.append(ddi.labelKey!)
            }
            temp["Answers"] = tempAns
            ans.append(temp)
        }
        dict["Questions"] = ans
        print("request body: \(dict)")
        
        return dict
    }
    
}
