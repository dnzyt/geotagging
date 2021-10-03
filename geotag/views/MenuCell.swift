//
//  MenuCell.swift
//  geotag
//
//  Created by Ningze Dai on 10/3/21.
//

import UIKit

class MenuCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let i = UIImageView(frame: CGRect(x: 15, y: 15, width: 90, height: 90))
        i.image = UIImage(systemName: "house")
        return i
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lightGray
        addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
