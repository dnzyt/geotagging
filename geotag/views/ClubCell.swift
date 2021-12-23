//
//  ClubCell.swift
//  geotag
//
//  Created by Ningze Dai on 10/2/21.
//

import UIKit

class ClubCell: UITableViewCell {
    
    var club: ClubInfo? {
        didSet {
            ckLbl.text = club!.clubKey
            addressContentbl.text = club!.address
            clubNameContentsLbl.text = club!.clubName
            if club!.hasBeenVisited {
                visitedIndicator.image = UIImage(systemName: "checkmark.seal.fill")
                visitedIndicator.tintColor = .systemBlue
            } else {
                visitedIndicator.image = UIImage(systemName: "square.3.stack.3d.top.filled")
                visitedIndicator.tintColor = .systemGray
            }
            if club!.geoUpdated {
                mapPin.tintColor = .systemBlue
            } else {
                mapPin.tintColor = .systemGray
            }
        }
    }
    
    let topStackView: UIStackView = {
        let t = UIStackView()
        t.axis = .horizontal
        t.distribution = .fillEqually
        t.backgroundColor = .clear
        t.translatesAutoresizingMaskIntoConstraints = false
        
        return t
    }()
    
    let ckImg: UIImageView = {
        let c = UIImageView(image: UIImage(systemName: "key"))
        c.translatesAutoresizingMaskIntoConstraints = false
        c.tintColor = .lightGray
        c.contentMode = .scaleAspectFit
        
        return c
    }()
    
    let clubKeyLbl: UILabel = {

        let l = UILabel()
        l.text = "Club Key:"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let ckLbl: UILabel = {
        let l = UILabel()
        l.text = "112346"
        l.textAlignment = .left
        l.textColor = .hbGreen
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.backgroundColor = .clear
        
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let ckStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.backgroundColor = .clear
        s.spacing = 5
        s.translatesAutoresizingMaskIntoConstraints = false

        
        return s
    }()
    
    let ckHorizontalStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.backgroundColor = .clear
        s.spacing = 5
        s.translatesAutoresizingMaskIntoConstraints = false

        
        return s
    }()
    
    let addressImg: UIImageView = {
        let c = UIImageView(image: UIImage(systemName: "house"))
        c.translatesAutoresizingMaskIntoConstraints = false
        c.tintColor = .lightGray
        c.contentMode = .scaleAspectFit
        
        return c
    }()
    
    let addressLbl: UILabel = {

        let l = UILabel()
        l.text = "Address:"
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let addressContentbl: UILabel = {
        let l = UILabel()
        l.text = "3200 Temple School Rd, Winston-Salem, NC 27107"
        l.numberOfLines = 0
        l.textAlignment = .left
        l.textColor = .hbGreen
        l.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        l.backgroundColor = .clear
        
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let addressStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.backgroundColor = .clear
        s.spacing = 5
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    let clubNameLbl: UILabel = {

        let l = UILabel()
        l.text = "Club Name:"
        l.textAlignment = .right
        l.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let clubNameContentsLbl: UILabel = {
        let l = UILabel()
        l.text = "Happy Nutrition Shakes"
        l.textAlignment = .right
        l.textColor = .hbGreen
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.backgroundColor = .clear
        
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    let clubNameStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.backgroundColor = .clear
        s.spacing = 5
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    let visitedIndicator: UIImageView = {
        let mp = UIImageView()
        mp.image = UIImage(systemName: "checkmark.seal.fill")
        mp.tintColor = .systemBlue
        mp.translatesAutoresizingMaskIntoConstraints = false
        
        return mp
    }()
    
    let mapPin: UIImageView = {
        let mp = UIImageView()
        mp.image = UIImage(systemName: "mappin.and.ellipse")
        mp.tintColor = .systemGray
        mp.translatesAutoresizingMaskIntoConstraints = false
        
        return mp
    }()
    
    
    
    let container: UIView = {
        let c = UIView()
        c.backgroundColor = .white
        c.translatesAutoresizingMaskIntoConstraints = false

        
        return c
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupContents()
    }
    
    fileprivate func setupContents() {
        ckStackView.addArrangedSubview(clubKeyLbl)
        ckStackView.addArrangedSubview(ckLbl)
        
        addressStackView.addArrangedSubview(addressLbl)
        addressStackView.addArrangedSubview(addressContentbl)
        container.addSubview(addressStackView)

        clubNameStackView.addArrangedSubview(clubNameLbl)
        clubNameStackView.addArrangedSubview(clubNameContentsLbl)
        
        
        topStackView.addArrangedSubview(ckStackView)
        topStackView.addArrangedSubview(clubNameStackView)
        container.addSubview(topStackView)

        container.addSubview(ckImg)
        container.addSubview(addressImg)
        container.addSubview(visitedIndicator)
        container.addSubview(mapPin)
        
        contentView.addSubview(container)
        contentView.backgroundColor = .clear
        
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            container.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            container.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            topStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            topStackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 40),
            topStackView.bottomAnchor.constraint(equalTo: addressStackView.topAnchor, constant: -15),
            topStackView.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10),
            ckImg.widthAnchor.constraint(equalToConstant: 25),
            ckImg.heightAnchor.constraint(equalToConstant: 25),
            ckImg.centerYAnchor.constraint(equalTo: topStackView.centerYAnchor),
            ckImg.rightAnchor.constraint(equalTo: topStackView.leftAnchor, constant: -5),
            addressStackView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 40),
            addressStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            addressStackView.widthAnchor.constraint(equalToConstant: 200),
            addressImg.widthAnchor.constraint(equalToConstant: 25),
            addressImg.heightAnchor.constraint(equalToConstant: 25),
            addressImg.centerYAnchor.constraint(equalTo: addressStackView.centerYAnchor),
            addressImg.rightAnchor.constraint(equalTo: addressStackView.leftAnchor, constant: -5),
            visitedIndicator.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -10),
            visitedIndicator.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            mapPin.rightAnchor.constraint(equalTo: visitedIndicator.leftAnchor, constant: -10),
            mapPin.centerYAnchor.constraint(equalTo: visitedIndicator.centerYAnchor, constant: 0)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.layer.cornerRadius = 5
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 5, height: 5)
        container.layer.shadowRadius = 5
        let containerBounds = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height - 20)
        container.layer.shadowPath = UIBezierPath(rect: containerBounds).cgPath
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
