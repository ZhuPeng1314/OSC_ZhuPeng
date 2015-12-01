//
//  EmojiStringUtils.h
//  OSC_ZhuPeng
//
//  Created by 鹏 朱 on 15/11/23.
//  Copyright © 2015年 鹏 朱. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface EmojiStringUtils : NSObject

+ (NSDictionary *)emojiDict;
+ (NSAttributedString *)emojiStringFromAttrString:(NSAttributedString*)attrString;
+ (NSAttributedString *)attributedStringFromHTML:(NSString *)html;

@end
