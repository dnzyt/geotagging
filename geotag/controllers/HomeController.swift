//
//  HomeController.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit
import MapKit
import Reachability


class HomeController: UIViewController {
    
    
    
    let clubCellId = "clubCellId"
    
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
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
        
        return mv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        clubTable.register(ClubCell.self, forCellReuseIdentifier: clubCellId)
        clubTable.dataSource = self
        clubTable.delegate = self
        
        
        setupNavitationBar()
        setupViews()
        

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
        }

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
        let vc = ClubSearchController { clubKey in
            print("club fetched \(clubKey)")
        }
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width:340, height:180)
        
        vc.popoverPresentationController?.barButtonItem = sender
        self.present(vc, animated: true)
    }
    
    @objc func clearClubs() {
        print("clear clubs")
    }
    


}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.clubCellId, for: indexPath) as! ClubCell
        if (indexPath.row % 2 == 0) {
            cell.mapPin.tintColor = .lightGray
        }
        return cell
    }
}

extension HomeController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        let qc = VisitPrepareController()

        let nav = UINavigationController(rootViewController: qc)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true, completion: nil)

    }
    
}
