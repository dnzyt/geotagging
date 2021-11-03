//
//  OfflineManager.swift
//  geotag
//
//  Created by Ningze Dai on 10/19/21.
//

import UIKit


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
            do {
                let visitInfos = try context.fetch(visitInfoFetchRequest) as [VisitInfo]
                
                if visitInfos.isEmpty {
                    print("no content for offline uploading")
                    self.isProcessing = false
                    return
                }
                
                // offline uploading starts
                bgTask = UIApplication.shared.beginBackgroundTask(withName: "") {
                    print("running in background")
                    self.isProcessing = false
                    if bgTask != .invalid {
                        print("background uploading finished successfully")
                    } else {
                        print("background uploading finished failed")
                    }
                }
                
                let group = DispatchGroup()
                
                for visit in visitInfos {
                    group.enter()
                    self.uploadOffline(visit: visit) {
                        group.leave()
                    }
                }
                
                
                group.notify(queue: .main) {
                    self.isProcessing = false
                    // dispatch notification
                    UIApplication.shared.endBackgroundTask(bgTask)
                }
                
            } catch {
                print("fetch offline visits failed")
                self.isProcessing = false
                UIApplication.shared.endBackgroundTask(bgTask)

            }
            
        }
        
    }
    
    func uploadOffline(visit: VisitInfo, completion: @escaping () -> ()) {
        var dict = [String: String]()
        dict["ClubKey"] = "966038"
        dict["DistributorId"] = ""
        
        guard let url = URL(string: Constatns.url + Constatns.getClubs) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("offlien data: \(String(describing: data))")
            completion()
        }
    }
    
}
