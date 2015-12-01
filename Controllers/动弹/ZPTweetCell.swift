//
//  ZPTweetCell.swift
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/20.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

import UIKit
import GRMustache
import FontAwesome

class ZPTweetCell: UITableViewCell {
    
    var portrait:UIImageView = UIImageView()
    var authorLabel:UILabel = UILabel()
    var pubDateLabel:UILabel = UILabel()
    var commentCountLabel:UILabel = UILabel()
    var appClientLabel:UILabel = UILabel()
    var likeButton:UIButton! = UIButton()
    var likeListLabel:UILabel = UILabel()
    var contentTextView:UITextView = UITextView(frame: CGRectZero)
    var thumbnail:UIImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.themeColor()
        
        initSubViews()
        setLayout()
        
    }
    
    func initSubViews()
    {
        self.portrait.contentMode = UIViewContentMode.ScaleAspectFit
        self.portrait.userInteractionEnabled = true
        self.portrait.setCornerRadius(5.0)
        self.contentView.addSubview(portrait)
        
        authorLabel.initLabel(fontSize: 14, textColor: UIColor.nameColor()!, canInteraction: true, fatherView: contentView)
        
        pubDateLabel.initLabel(fontSize: 12, textColor: UIColor.grayColor(), canInteraction: false, fatherView: contentView)
        
        appClientLabel.initLabel(fontSize: 12, textColor: UIColor.grayColor(), canInteraction: false, fatherView: contentView)
        
        ZPTweetCell.initContentTextView(contentTextView)
        self.contentView.addSubview(contentTextView)
        
        likeButton.titleLabel?.font = UIFont(awesomeFontOfSize: 12)
        self.contentView.addSubview(likeButton)
        
        commentCountLabel.initLabel(fontSize: 12, textColor: UIColor.grayColor(), canInteraction: false, fatherView: contentView)
        
        thumbnail.contentMode = UIViewContentMode.ScaleAspectFill
        thumbnail.clipsToBounds = true
        thumbnail.userInteractionEnabled = true
        self.contentView.addSubview(thumbnail)
        
        likeListLabel.initLabel(fontSize: 12, textColor: UIColor.grayColor(), canInteraction: true, fatherView: contentView)
        likeListLabel.numberOfLines = 0
        likeListLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    static func initContentTextView(textView:UITextView)
    {
        textView.textContainer.lineBreakMode = NSLineBreakMode.ByWordWrapping
        textView.backgroundColor = UIColor.clearColor()
        textView.font = UIFont.boldSystemFontOfSize(15.0)
        textView.editable = false
        textView.scrollEnabled = false
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
        textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.nameColor()!,
            NSUnderlineStyleAttributeName:NSNumber(integer: NSUnderlineStyle.StyleNone.rawValue)]
        
    }
    
    func setLayout()
    {
        for view in contentView.subviews
        {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // portrait,authorLabel,pubDateLabel,commentCountLabel,appClientLabel,likeButton,likeListLabel,contentTextView,thumbnail
        let views = ["portrait":portrait,"authorLabel":authorLabel,"pubDateLabel":pubDateLabel,
            "commentCountLabel":commentCountLabel,"appClientLabel":appClientLabel,"likeButton":likeButton,
            "likeListLabel":likeListLabel,"contentTextView":contentTextView,"thumbnail":thumbnail]
        
        let optionZero = NSLayoutFormatOptions.init(rawValue: 0)
        contentView.addConstraintsWithVisualFormat("V:|-8-[portrait(36)]", options: optionZero, metrics: nil, views: views)
        contentView.addConstraintsWithVisualFormat("|-8-[portrait(36)]-8-[authorLabel]-8-|", options: optionZero, metrics: nil, views: views)
        contentView.addConstraintsWithVisualFormat("V:|-7-[authorLabel]-5-[contentTextView]-6-[thumbnail]-<=6-[likeListLabel]-6-[pubDateLabel]-5-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views)
        contentView.addConstraintsWithVisualFormat("[thumbnail]", options:optionZero, metrics: nil, views:views)
        contentView.addConstraintsWithVisualFormat("[pubDateLabel]-10-[appClientLabel]->=5-[likeButton(30)]-5-[commentCountLabel]-8-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        contentView.addConstraintsWithVisualFormat("[likeListLabel]-8-|", options: optionZero, metrics: nil, views: views)
        contentView.addConstraint(NSLayoutConstraint(item: authorLabel, attribute: NSLayoutAttribute.Right, relatedBy: .Equal, toItem: contentTextView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        //contentView.addConstraintsWithVisualFormat("V:[authorLabel]-5-[contentTextView]", options: NSLayoutFormatOptions.AlignAllRight, metrics: nil, views: views)
        
        
    }
    
    func setContentWithTweet(tweet:ZPOSCTweet)
    {
        //self.portrait.loadPortrait(tweet.portraitURL)
        self.authorLabel.text = tweet.author
        
        self.pubDateLabel.attributedText = tweet.attributedPubDate
        self.commentCountLabel.attributedText = tweet.attributedCommentCount
        self.appClientLabel.attributedText = tweet.getAttributedAppclient()
        
        if tweet.isLike == true
        {
            self.likeButton.setTitle(NSString.fontAwesomeIconStringForEnum(FAIcon.FAThumbsUp), forState: UIControlState.Normal)
            self.likeButton.setTitleColor(UIColor.nameColor(), forState: UIControlState.Normal)
        }else
        {
            self.likeButton.setTitle(NSString.fontAwesomeIconStringForEnum(FAIcon.FAThumbsOUp), forState: UIControlState.Normal)
            self.likeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
        
        // 添加语音图片
        if (tweet.attach as NSString).length > 0
        { //有语音
            let textAttach = NSTextAttachment()
            textAttach.image = UIImage(named: "audioTweet")
            let attachmentString = NSAttributedString(attachment: textAttach)
            let attributedTweetBody = NSMutableAttributedString(attributedString: attachmentString)
            attributedTweetBody.appendAttributedString(NSAttributedString(string: " "))
            attributedTweetBody.appendAttributedString(tweet.getAttributedBody())
            
            tweet.setAttributedBody(attributedTweetBody)
            self.contentTextView.attributedText = attributedTweetBody
            
        }else
        {
            self.contentTextView.attributedText = tweet.getAttributedBody()
        }
        
        //print(tweet.body)
        
        if tweet.likeList.count > 0
        {
            self.likeListLabel.attributedText = tweet.getlikersString()
            self.likeListLabel.hidden = false
        }else
        {
            self.likeListLabel.hidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    static func contentStringFromRawString(rawString:String!)->NSAttributedString
    {
        if rawString == nil || (rawString as NSString).length == 0
        {
            return NSAttributedString(string: "")
        }
        
        let attrString = EmojiStringUtils.attributedStringFromHTML(rawString)
        let mutableAttrString = EmojiStringUtils.emojiStringFromAttrString(attrString).mutableCopy() as! NSMutableAttributedString
        
        mutableAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14.0), range: NSMakeRange(0, mutableAttrString.length))
        
        // remove under line style
        mutableAttrString.removeUnderLineStyle()
        
        return mutableAttrString
        
    }
    
    
    func setSelectableItemWithTag(tag1:Int)
    {
        self.contentTextView.tag = tag1
        
        self.portrait.tag = tag1
        self.authorLabel.tag = tag1
        self.thumbnail.tag = tag1
        self.likeButton.tag = tag1
        self.likeListLabel.tag = tag1
    }
}












