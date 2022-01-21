//
//  VisitPrepareController.swift
//  geotag
//
//  Created by Ningze Dai on 10/11/21.
//

import UIKit
import CoreLocation
import JGProgressHUD
import Reachability
import SwiftyJSON

protocol VisitPrepareControllerDelegate: AnyObject {
    func geoTaggingFininshed(with geocode: String, club: ClubInfo, success: Bool)
}

class VisitPrepareController: UIViewController {
    
    static let cellId = "visitPrepareCellId"
    
    let hud = JGProgressHUD()
    
    weak var delegate: VisitPrepareControllerDelegate?
    
    var club: ClubInfo?
    
    let table: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 80
        t.backgroundColor = .hbGreen
        t.layer.cornerRadius = 10
        
        
        return t

    }()
    
    let captureLocationBtn: UIButton = {
        
//        b.setTitle(, for: .normal)
//        b.setImage(UIImage(systemName: "house"), for: .normal)
//        b.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        var config = UIButton.Configuration.filled()
        config.title = "Capture current location"
        config.image = UIImage(systemName: "scope")
        config.baseBackgroundColor = UIColor(r: 61, g: 91, b: 151)
        config.imagePadding = 20
        config.buttonSize = .large
        let b = UIButton(configuration: config, primaryAction: nil)
        b.translatesAutoresizingMaskIntoConstraints = false

        
        return b
    }()
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        table.register(VisitPrepareCell.self, forCellReuseIdentifier: VisitPrepareController.cellId)
        table.dataSource = self
        table.delegate = self

        
        captureLocationBtn.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        view.addSubview(table)
        view.addSubview(captureLocationBtn)

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            table.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20),
            table.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            table.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            captureLocationBtn.widthAnchor.constraint(equalToConstant: 300),
            captureLocationBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureLocationBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        setupNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLocationManager()
    }
    
    private func setupNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .hbGreen
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let tv = UILabel()
        tv.text = "Club Information"
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        navigationItem.titleView = tv
        
        
        let cancelBTN = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left"), style: .plain, target: self, action: #selector(cancel))
        
        navigationItem.leftBarButtonItem = cancelBTN
        navigationItem.leftBarButtonItem?.tintColor = UIColor(r: 252, g: 108, b: 108)
        
        let startVisitBtn = UIBarButtonItem(image: UIImage(systemName: "rectangle.stack.badge.play"), style: .plain, target: self, action: #selector(startVisit))
        navigationItem.rightBarButtonItem = startVisitBtn

        navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func startVisit() {
        
        guard let visitInfo = prepareVisit() else { return }
        
        var businessAnswers = [AnswerInfo]()
        var trainingAnswers = [AnswerInfo]()
        var trackingAnswers = [AnswerInfo]()
        var feedbackAnswers = [AnswerInfo]()

        for ans in visitInfo.answers! {
            let a = ans as! AnswerInfo
            if a.categoryId == "1" {
                businessAnswers.append(a)
            } else if a.categoryId == "2" {
                trainingAnswers.append(a)
            } else if a.categoryId == "3" {
                trackingAnswers.append(a)
            } else if a.categoryId == "4" {
                feedbackAnswers.append(a)
            }
        }
        
        
        let split = HBSplitViewController(style: .doubleColumn)
        split.preferredDisplayMode = .oneBesideSecondary
        split.preferredSplitBehavior = .tile
        split.preferredPrimaryColumnWidth = 240
        split.displayModeButtonVisibility = .never
        
        split.visitInfo = visitInfo
        split.businessController.answers = businessAnswers
        split.trainingController.answers = trainingAnswers
        split.trackingController.answers = trackingAnswers
        split.feedbackController.answers = feedbackAnswers
        split.prevController.prevVisitInfo = club?.prevVisitInfo
        
        guard let window = self.view.window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = split
        }
    }
    
    
    private func prepareVisit() -> VisitInfo? {
        guard let clubKey = club?.clubKey else { return nil }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        let visitInfoFetchRequest = VisitInfo.fetchRequest()
        let predicate1 = NSPredicate(format: "clubKey == %@", clubKey)
        let predicate2 = NSPredicate(format: "finished == %@", NSNumber(value: false))
        let predicate3 = NSPredicate(format: "submitted == %@", NSNumber(value: false))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3])
        visitInfoFetchRequest.predicate = predicate
        let visitInfos = try? context.fetch(visitInfoFetchRequest)
        
        var visitInfo: VisitInfo
        if let vif = visitInfos?.first {
            visitInfo = vif
        } else {
            visitInfo = VisitInfo(context: context)
            visitInfo.clubKey = clubKey
            visitInfo.visitDate = Date()
            
            let fq = QuestionInfo.fetchRequest()
            let sortDesc = NSSortDescriptor(key: "orderIndex", ascending: true)
            fq.sortDescriptors = [sortDesc]
            if let res = try? context.fetch(fq) {
                for q in res {
                    let ans = AnswerInfo(context: context)
                    ans.ans = []
                    ans.categoryId = q.categoryId
                    ans.countryCode = q.countryCode
                    ans.questionKey = q.questionKey
                    ans.questionType = q.questionType
                    ans.label = q.label
                    ans.needComment = q.needComment
                    for item in q.items?.array as! [LabelInfo] {
                        let dropDownItem = DropDownItem(context: context)
                        dropDownItem.labelKey = item.labelKey
                        dropDownItem.labelValue = item.labelValue
                        ans.addToItems(dropDownItem)
                    }
                    ans.visitInfo = visitInfo
                }
            }
        }
        
        do {
            try context.save()
        } catch {
            print("prepare answers failed")
            return nil
        }
        
        return visitInfo
    }
    
    
    @objc func getLocation() {
        if updatingLocation {
            return
        }
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServiceDeniedAlert()
            return
        }
        
        let alert = UIAlertController(title: "Update geocode", message: "Are you sure to update the geocode of this club?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
            updatingLocation = true
            lastLocationError = nil
            locationManager.startUpdatingLocation()
            
            DispatchQueue.main.async {
                self.hud.textLabel.text = "Searching geocode..."
                self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
                self.hud.show(in: self.view.window!)
                self.hud.tapOutsideBlock = { [unowned self] hud in
                    locationManager.stopUpdatingLocation()
                    updatingLocation = false
                    lastLocationError = nil
                    hud.dismiss(animated: true)
                    print("cancel update location")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showLocationServiceDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showLocationErrorAlert() {
//        let alert = UIAlertController(title: "Location Services Error", message: "Location service is not available at this time, please try again later", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Geo Tagging Failed"
            self.hud.detailTextLabel.text = "Location service is not available at this time, please try again later"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.indicatorView?.tintColor = .red
            self.hud.dismiss(afterDelay: 2)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            updatingLocation = false
            lastLocationError = nil
            print("stop location manager")
        }
    }
    
    private func dismissJGPIndicator(mainText: String, success: Bool) {
        DispatchQueue.main.async {
            self.hud.textLabel.text = mainText
            self.hud.indicatorView = success ? JGProgressHUDSuccessIndicatorView() : JGProgressHUDErrorIndicatorView()
            self.hud.detailTextLabel.text = nil
            self.hud.dismiss(afterDelay: 3)
        }
    }
    
    func updateGeocode(_ geocode: String, for club: ClubInfo) {
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Updating geocode"
            self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
            self.hud.detailTextLabel.text = nil

            if !self.hud.isVisible {
                self.hud.show(in: self.view.window!, animated: true)
            }
        }
        
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            guard let url = URL(string: Constants.url + Constants.updateGeoTrack) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var dict = [String: String]()
            dict["ClubKey"] = club.clubKey!
            dict["GeoCode"] = geocode
            guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let _ = error {
                    self.dismissJGPIndicator(mainText: "Geocode updating failed", success: false)
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSON(data: data)
                        if let errorCode = json["ErrorCode"].string, errorCode == "0" {
                            self.dismissJGPIndicator(mainText: "Geocode Updated!", success: true)
                            self.delegate?.geoTaggingFininshed(with: geocode, club: club, success: true)
                        } else {
                            self.dismissJGPIndicator(mainText: "Geocode updating failed", success: false)
                        }
                        
                    } catch {
                        self.dismissJGPIndicator(mainText: "Geocode updating failed", success: false)
                    }
                } else {
                    self.dismissJGPIndicator(mainText: "Geocode updating failed", success: false)
                }
            }.resume()
        } else {
            print("internet connection not available")
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let offlineGeocode = OfflineGeocode(context: context)
                offlineGeocode.clubKey = club.clubKey
                offlineGeocode.geocode = geocode
                try? context.save()
            }
            self.dismissJGPIndicator(mainText: "Geocode cached Offline!", success: true)
        }
        
    }

}

extension VisitPrepareController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        print("current location \(newLocation)")
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("find the desired location \(newLocation)")
                stopLocationManager()

                
//                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//                let context = appDelegate.persistentContainer.viewContext
                
                let geocodeString = "\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)"
                if let geocode = club?.geocode {
                    let comps = geocode.components(separatedBy: ",")
                    if let lat = Double(comps[0]), let long = Double(comps[1]) {
                        let oldLocation = CLLocation(latitude: lat, longitude: long)
                        let distance = newLocation.distance(from: oldLocation)
                        if distance < 20 {
                            DispatchQueue.main.async {
                                self.hud.dismiss(animated: true)
                            }
                            let alert = UIAlertController(title: "Geo Tagging", message: "The distance is less than 20 meters, do you want to update the geocode?", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                            let okAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                                // call service to update geocode
                                self!.updateGeocode(geocodeString, for: self!.club!)
                            }

                            alert.addAction(cancelAction)
                            alert.addAction(okAction)
                            present(alert, animated: true, completion: nil)
                            
                        } else {
                            // directly call service to update geocode
                            updateGeocode(geocodeString, for: club!)
                        }
                    } else {
                        // no geocode on file
                        // directly call service to update geocode
                        updateGeocode(geocodeString, for: club!)

                    }
                    
                    
                } else {
                    // no geocode on file
                    // directly call service to update geocode
                    updateGeocode(geocodeString, for: club!)

                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error.localizedDescription)")
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        showLocationErrorAlert()
        stopLocationManager()
    }
}

extension VisitPrepareController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitPrepareController.cellId, for: indexPath) as! VisitPrepareCell
        
        var firstText: String?
        var secondText: String?
        switch indexPath.row {
        case 0:
            firstText = "Club Key:"
            secondText = club?.clubKey
        case 1:
            firstText = "Club Name:"
            secondText = club?.clubName
        case 2:
            firstText = "Address:"
            secondText = club?.address
        case 3:
            firstText = "City:"
            secondText = club?.city
        case 4:
            firstText = "Province:"
            secondText = club?.province
        case 5:
            firstText = "Zip:"
            secondText = club?.zip
        case 6:
            firstText = "Phone:"
            secondText = club?.phone
        case 7:
            firstText = "Club Type:"
            secondText = club?.clubType
        case 8:
            firstText = "Club Status:"
            secondText = club?.clubStatus
        case 9:
            firstText = "Open Date:"
            secondText = club?.openDate
        case 10:
            firstText = "Primary Ds Id:"
            secondText = club?.primaryDsId
        case 11:
            firstText = "Primary Ds Name:"
            secondText = club?.primaryDsName
        case 12:
            firstText = "Upline Name:"
            secondText = club?.uplineName

        default:
            break
        }
        cell.descLbl.text = firstText
        cell.contentLbl.text = secondText
        
        
        return cell
    }
    
    
}

extension VisitPrepareController: UITableViewDelegate {
    
}
