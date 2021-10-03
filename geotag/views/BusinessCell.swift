//
//  BusinessCell.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    private let containerView: UIStackView = {
        let c = UIStackView()
        c.axis = .vertical
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = .lightGray
        c.alignment = .leading
        
        return c
    }()
    
    let questionLbl: UILabel = {
        let ql = UILabel()
        ql.numberOfLines = 0
        ql.font = UIFont.systemFont(ofSize: 20)
        ql.translatesAutoresizingMaskIntoConstraints = false
        ql.backgroundColor = .orange

        return ql
    }()
    
    let ansLbl: UILabel = {
        let al = UILabel()
        al.numberOfLines = 0
        al.font = UIFont.systemFont(ofSize: 16)
        al.translatesAutoresizingMaskIntoConstraints = false
        al.backgroundColor = .green
        
        return al
    }()
    
    let commentLbl: UILabel = {
        let cl = UILabel()
        cl.numberOfLines = 0
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.backgroundColor = .yellow
        
        return cl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContent()
    }
    

    
    fileprivate func setupContent() {
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(questionLbl)
        containerView.addArrangedSubview(ansLbl)
        containerView.addArrangedSubview(commentLbl)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
