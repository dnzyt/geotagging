//
//  VisitPrepareController.swift
//  geotag
//
//  Created by Ningze Dai on 10/11/21.
//

import UIKit
import CoreLocation

class VisitPrepareController: UIViewController {
    
    static let cellId = "visitPrepareCellId"
    
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
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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
        print("stop location manager")
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
        guard let window = self.view.window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            let split = HBSplitViewController(style: .doubleColumn)
            split.preferredDisplayMode = .oneBesideSecondary
            split.preferredSplitBehavior = .tile
            split.preferredPrimaryColumnWidth = 240
            split.displayModeButtonVisibility = .never
            window.rootViewController = split
        }
    }
    
    @objc func getLocation() {
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            showLocationServiceDeniedAlert()
            return
        }
        locationManager.startUpdatingLocation()
        updatingLocation = true
        lastLocationError = nil
    }
    
    private func showLocationServiceDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showLocationErrorAlert() {
        let alert = UIAlertController(title: "Location Services Error", message: "Location service is not available at this time, please try again later", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            updatingLocation = false
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
