//
//  VisitPrepareController.swift
//  geotag
//
//  Created by Ningze Dai on 10/11/21.
//

import UIKit
import CoreLocation

class VisitPrepareController: UIViewController {
    
    let captureLocationBtn: UIButton = {
        let b = UIButton()
        b.setTitle("Capture current location", for: .normal)
        b.backgroundColor = UIColor(r: 61, g: 91, b: 151)
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

        
        captureLocationBtn.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        view.addSubview(captureLocationBtn)

        NSLayoutConstraint.activate([
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
            split.preferredPrimaryColumnWidth = 160
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
