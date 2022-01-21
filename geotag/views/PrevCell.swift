//
//  PrevCell.swift
//  geotag
//
//  Created by Ningze Dai on 1/12/22.
//

import UIKit

class PrevCell: UITableViewCell {
    
    var answer: PrevAnswer? {
        didSet {
            questionLbl.text = answer?.labelValue
            ansLbl.text = answer?.selections?.appending("\n").appending(answer?.usersEntry ?? "")
            commentLbl.text = answer?.comments
        }
    }

    private let bgContainer: UIView = {
        let c = UIView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = .lightGray
        c.layer.cornerRadius = 6
        
        return c
    }()
    
    private let containerView: UIStackView = {
        let c = UIStackView()
        c.axis = .vertical
        c.translatesAutoresizingMaskIntoConstraints = false
        c.alignment = .leading
        c.spacing = 10
        c.backgroundColor = .clear
        
        return c
    }()
    
    let questionLbl: UILabel = {
        let ql = UILabel()
        ql.numberOfLines = 0
        ql.font = UIFont(name: "GillSans-SemiBoldItalic", size: 16)
        ql.translatesAutoresizingMaskIntoConstraints = false
        ql.textColor = .white
        

        return ql
    }()
    
    let seperator: UIView = {
        let s = UIView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .white
        return s
    }()
    
    let ansLbl: UILabel = {
        let al = UILabel()
        al.numberOfLines = 0
        al.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        al.translatesAutoresizingMaskIntoConstraints = false
        al.textColor = .white

        
        return al
    }()
    
    let commentLbl: UILabel = {
        let cl = UILabel()
        cl.numberOfLines = 0
        cl.textColor = .white
        cl.font = UIFont.systemFont(ofSize: 12)
        cl.translatesAutoresizingMaskIntoConstraints = false
        cl.textAlignment = .right
        
        return cl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupContent()
    }
    

    
    fileprivate func setupContent() {
        contentView.addSubview(bgContainer)
        
        bgContainer.addSubview(containerView)
        containerView.addArrangedSubview(questionLbl)
        containerView.addArrangedSubview(seperator)
        containerView.addArrangedSubview(ansLbl)
        bgContainer.addSubview(commentLbl)
        
        NSLayoutConstraint.activate([
            bgContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bgContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: bgContainer.topAnchor, constant: 10),
            containerView.leftAnchor.constraint(equalTo: bgContainer.leftAnchor, constant: 10),
            containerView.rightAnchor.constraint(equalTo: bgContainer.rightAnchor, constant: -10),
            seperator.heightAnchor.constraint(equalToConstant: 1),
            seperator.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            commentLbl.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            commentLbl.rightAnchor.constraint(equalTo: bgContainer.rightAnchor, constant: -10),
            commentLbl.bottomAnchor.constraint(equalTo: bgContainer.bottomAnchor, constant: -10),
            commentLbl.widthAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
