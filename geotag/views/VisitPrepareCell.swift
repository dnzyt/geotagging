//
//  VisitPrepareCell.swift
//  geotag
//
//  Created by Ningze Dai on 10/15/21.
//

import UIKit

class VisitPrepareCell: UITableViewCell {

    let descLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.backgroundColor = .clear
        l.textAlignment = .left
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 14)
        l.text = "Club sfsdfsdfsf\nsdfsdfsfsfsfK\nsfsfsdfsdfdey:"
        
        
        return l
    }()
    
    let contentLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        l.backgroundColor = .clear
        l.textAlignment = .right
        l.numberOfLines = 0
        l.font = UIFont(name: "GillSans-SemiBoldItalic", size: 14)
        l.text = "112346f"
        
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupContents()
    }
    
    private func setupContents() {
        contentView.addSubview(descLbl)
        contentView.addSubview(contentLbl)
        
        NSLayoutConstraint.activate([
            descLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            descLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            descLbl.widthAnchor.constraint(equalToConstant: 150),
            descLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            contentLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentLbl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            contentLbl.widthAnchor.constraint(equalToConstant: 300),
            contentLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
