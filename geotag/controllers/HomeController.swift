//
//  HomeController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit
import MapKit
import Reachability
import JGProgressHUD
import CoreLocation


class HomeController: UIViewController {
    
    
    let hud = JGProgressHUD()
    let geocoder = CLGeocoder()

    let clubCellId = "clubCellId"
    
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
    private var clubs: [ClubInfo] = []
    
    let containerView: UIView = {
        let c = UIView()
        c.translatesAutoresizingMaskIntoConstraints = false;
        c.backgroundColor = UIColor(r: 123, g: 193, b: 67)
        return c
    }()
    
    let clubTable: UITableView = {
        let table = UITableView()
        table.estimatedRowHeight = 300
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = UIColor.hbGreen
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.mapType = .standard
        mv.isZoomEnabled = true
        mv.isScrollEnabled = true
        mv.showsUserLocation = true
        
        return mv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        clubTable.register(ClubCell.self, forCellReuseIdentifier: clubCellId)
        clubTable.dataSource = self
        clubTable.delegate = self
        
        mapView.delegate = self
        let lc = CLLocationManager()
        lc.requestWhenInUseAuthorization()
        
        setupNavitationBar()
        setupViews()
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = ClubInfo.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest) as [ClubInfo]
            clubs.append(contentsOf: result)
        } catch {
            print("load clubs from local failed")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableAndMap), name: NSNotification.Name("REFRESH"), object: nil)

//        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
//            let reachability = try! Reachability()
//            print("connection: --- \(reachability.connection)")
//            if reachability.connection != .unavailable {
//                print("internet connection available")
//            } else {
//                print("internet connection not available")
//            }
//        }
        
    }
    
    @objc func refreshTableAndMap(notification: Notification) {
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
       
            let userInfo = notification.userInfo as! [String: [String]]
            let cks = userInfo["CLUB_KEYS"]!
            for ck in cks {
                for c in self.clubs {
                    if c.clubKey! == ck {
                        c.hasBeenVisited = true
                    }
                }
            }
            try? context.save()
            print("club updated from offline.")
            print("refresh notificaiton")
            clubTable.reloadData()
            refreshMap()
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let authenticated = UserDefaults.standard.bool(forKey: Defaults.authentication.rawValue)
        if !authenticated {
            let login = LoginController()
            login.modalPresentationStyle = .fullScreen
            present(login, animated: true)
            return
        }
        refreshMap()

    }
    
    fileprivate func setupNavitationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .hbGreen
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let tv = UILabel()
        tv.text = "Nutrition Club"
        tv.textColor = .white
        tv.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        
        navigationItem.titleView = tv
        
        let logoutBTN = UIBarButtonItem(image: UIImage(systemName: "power.circle.fill"), style: .plain, target: self, action: #selector(logoutAction))
        
        navigationItem.leftBarButtonItem = logoutBTN
        navigationItem.leftBarButtonItem?.tintColor = .hbPink
        
        let searchBtn = UIBarButtonItem(image: UIImage(systemName: "doc.text.magnifyingglass"), style: .plain, target: self, action: #selector(searchClubs))
        
        searchBtn.tintColor = .white
        let clearBtn = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(clearClubs))
        clearBtn.tintColor = UIColor(r: 247, g: 103, b: 72)
        navigationItem.rightBarButtonItems = [clearBtn, searchBtn]
        

    }
    
    private func refreshMap() {
        mapView.removeAnnotations(mapView.annotations)
        
        clubs.forEach { c in
            if let geocode = c.geocode {
                let comps = geocode.components(separatedBy: ",")
                guard let lat = Double(comps[0]), let long = Double(comps[1]) else { return }
                let coordinate = (lat: lat, long: long)
                
                let annotation = Artwork(title: c.clubKey, locationName: c.address, discipline: nil, coordinate: CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.long), club: c)
                mapView.addAnnotation(annotation)
                
            }
        }
        mapView.fitAll()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    fileprivate func setupViews() {
        containerView.addSubview(clubTable)
        containerView.addSubview(mapView)
        view.addSubview(containerView)

        
        compactConstraints.append(contentsOf: [
            clubTable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            clubTable.bottomAnchor.constraint(equalTo: mapView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mapView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5)
        ])
        
        sharedConstraints.append(contentsOf: [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            clubTable.topAnchor.constraint(equalTo: containerView.topAnchor),
            clubTable.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        regularConstraints.append(contentsOf: [
            clubTable.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            clubTable.trailingAnchor.constraint(equalTo: mapView.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            mapView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5)

        ])
        
        NSLayoutConstraint.activate(sharedConstraints)
   
        
    }
    
    fileprivate func layoutTrait(traitCollection: UITraitCollection) {

        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            if compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    @objc func logoutAction() {
        UserDefaults.standard.set(false, forKey: Defaults.authentication.rawValue)
        let login = LoginController()
        login.modalPresentationStyle = .fullScreen
        present(login, animated: true)
        
    }
    
    @objc func searchClubs(sender: UIBarButtonItem) {
        let vc = ClubSearchController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width:340, height:180)
        
        vc.popoverPresentationController?.barButtonItem = sender
        self.present(vc, animated: true)
    }
    
    @objc func clearClubs() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let alert = UIAlertController(title: "Delete Clubs", message: "Do you want to delete all clubs?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            for club in self!.clubs {
                context.delete(club)
            }
            self?.clubs.removeAll()
            self?.refreshMap()
            do {
                try context.save()
            } catch {
                print("error \(error)")
            }
            self?.clubTable.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    


}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clubs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.clubCellId, for: indexPath) as! ClubCell
        cell.club = clubs[indexPath.row]
        
        return cell
    }
    
    private func showPrepareController(club: ClubInfo) {
        let qc = VisitPrepareController()
        qc.club = club
        qc.delegate = self
        qc.isModalInPresentation = true

        let nav = UINavigationController(rootViewController: qc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true, completion: nil)
    }
}

extension HomeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPrepareController(club: clubs[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let cl = clubs[indexPath.row]
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Delet Club \(cl.clubKey!)", message: "Do you want to delete this club?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No", style: .cancel)
            let okAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                let club = self.clubs.remove(at: indexPath.row)
                context.delete(club)
                do {
                    try context.save()
                } catch {
                    print("delete club failed")
                    return
                }
                tableView.reloadData()
                self.refreshMap()
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            present(alert, animated: true)
            
        }
    }
    
}

extension HomeController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? Artwork else { return }
        showPrepareController(club: annotation.club!)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude {
            return nil
        }
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if mapView.annotations.count == 1 {
            let latDelta:CLLocationDegrees = 0.5
            let lonDelta:CLLocationDegrees = 0.5
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension HomeController: ClubSearchControllerDelegate {
    func clubsSearched(_ cbs: [ClubInfo], withResult res: Bool, and message: String?) {
        if res {
            clubs.append(contentsOf: cbs)
            geocodingInBatch(clubs: clubs)
            self.clubTable.reloadData()
            self.refreshMap()
            hud.dismiss(animated: true)
        } else {
            hud.textLabel.text = "Search Failed."
            hud.detailTextLabel.text = message
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.indicatorView?.tintColor = .red
            hud.dismiss(afterDelay: 2)
        }
    }
    
    private func geocodingInBatch(clubs: [ClubInfo]) {
        guard !clubs.isEmpty else {
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let club = clubs.first else { return }
        if club.geocode == nil {
            if let addr = club.address, let city = club.city, let province = club.province, let zip = club.zip, let countryCode = club.countryCode {
                let address = "\(addr), \(city), \(province), \(zip), \(countryCode)"
                geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
                    if let placemark = placemarks?.first, let lat = placemark.location?.coordinate.latitude, let long = placemark.location?.coordinate.longitude {
                        let geocode = "\(lat),\(long)"
                        print("geocode: \(geocode)")
                        club.geocode = geocode
                        try? context.save()
                        self?.clubTable.reloadData()
                        self?.refreshMap()
                    }
                    self?.geocodingInBatch(clubs: Array(clubs.dropFirst()))
                }
            }
        } else {
            geocodingInBatch(clubs: Array(clubs.dropFirst()))
        }
        
    }
    
    func searchStarted() {
        DispatchQueue.main.async {
            self.hud.textLabel.text = "Searching clubs"
            self.hud.detailTextLabel.text = ""
            self.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
            self.hud.show(in: self.view)
        }
    }
}
extension HomeController: VisitPrepareControllerDelegate {
    func geoTaggingFininshed(with geocode: String, club: ClubInfo, success: Bool) {
        if success {
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                club.geocode = geocode
                try? context.save()
                self.clubTable.reloadData()
                self.refreshMap()
            }
        }
    }
}
