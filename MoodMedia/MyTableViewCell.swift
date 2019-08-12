//
//  MyTableViewCell.swift
//  MoodMedia
//
//  Created by DerekYang on 2019/8/1.
//  Copyright © 2019 DKY. All rights reserved.
//

import UIKit



class MyTableViewCell: UITableViewCell {
	
	var uid = ""
	
	lazy var nameLabel: UILabel = {()-> UILabel in
		
		let lbl = UILabel()
		lbl.numberOfLines = 0
		
		return lbl
	}()
	
	lazy var detailLabel: UILabel = {()-> UILabel in
		
		let lbl = UILabel()
		lbl.numberOfLines = 0
		
		return lbl
	}()
	
	lazy var imgView: UIImageView = {()-> UIImageView in
		
		let imgv = UIImageView()
		
		return imgv
	}()
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
		
		let marginGuide = contentView.layoutMarginsGuide
		
		contentView.addSubview(imgView)
		imgView.translatesAutoresizingMaskIntoConstraints = false
		imgView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
		imgView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		imgView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		imgView.widthAnchor.constraint(equalToConstant: 80).isActive = true
		imgView.heightAnchor.constraint(equalToConstant: 80).isActive = true
		
        // configure titleLabel
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        nameLabel.numberOfLines = 0
		
        contentView.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		detailLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
	}
}
