//
//  MenuCell.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class MenuCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(systemName: "house")
        i.tintColor = .white
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    let mainLbl: UILabel = {
        let l = UILabel()
        l.text = "Business Methods"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.font = UIFont(name: "ChalkboardSE-Regular", size: 14)
        
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(iconImageView)
        contentView.addSubview(mainLbl)


        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainLbl.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            mainLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        if state.isSelected {
            contentView.backgroundColor = .hbGreen
            mainLbl.textColor = .white
            iconImageView.tintColor = .white
            
        } else {
            contentView.backgroundColor = .white
            mainLbl.textColor = .hbGreen
            iconImageView.tintColor = .hbGreen
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
