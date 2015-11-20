//
//  ZPNewsCell.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/11.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit

class ZPNewsCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var bodyLabel:UILabel!
    var authorLabel:UILabel!
    var timeLabel:UILabel!
    var commentCountLabel:UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubviews()
        self.setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews()
    {
        self.titleLabel = UILabel()
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.titleLabel.font = UIFont.boldSystemFontOfSize(15)
        self.contentView.addSubview(self.titleLabel)
        
        self.bodyLabel = UILabel()
        self.bodyLabel.numberOfLines = 0
        self.bodyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.bodyLabel.font = UIFont.boldSystemFontOfSize(13)
        self.bodyLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.bodyLabel)
        
        self.authorLabel = UILabel()
        self.authorLabel.font = UIFont.boldSystemFontOfSize(12)
        self.authorLabel.textColor = UIColor.nameColor()
        self.contentView.addSubview(self.authorLabel)
        
        self.timeLabel = UILabel()
        self.timeLabel.font = UIFont.boldSystemFontOfSize(12)
        self.timeLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.timeLabel)
        
        self.commentCountLabel = UILabel()
        self.commentCountLabel.font = UIFont.boldSystemFontOfSize(12)
        self.commentCountLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(self.commentCountLabel)
        
        
    }
    
    func setLayout()
    {
        for v in self.contentView.subviews
        {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        let viewsDict = ["titleLabel":titleLabel, "bodyLabel":bodyLabel,"authorLabel":authorLabel,"timeLabel":timeLabel,"commentCountLabel":commentCountLabel]
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[titleLabel]-5-[bodyLabel]", options: [NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: nil, views: viewsDict))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-8-[titleLabel]-8-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: viewsDict))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[bodyLabel]-5-[authorLabel]-8-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: viewsDict))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[authorLabel]-10-[timeLabel]-10-[commentCountLabel]", options: [NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: nil, views: viewsDict))
        

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
