//
//  NewMailTableViewCell.h
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/13.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NewMailCellType) {
    NewMailCellTypeFrom = 0,
    NewMailCellTypeMainTo = 1,
    NewMailCellTypeTo = 2,
    NewMailCellTypeMainCc = 3,
    NewMailCellTypeCc = 4,
    NewMailCellTypeMainBcc = 5,
    NewMailCellTypeBcc = 6,
    NewMailCellTypeSubject = 7,
};

@class NewMailInfo;
@interface NewMailTableViewCell : UITableViewCell

@property(nonatomic, strong) NewMailInfo *mailInfo;

@property (copy, nonatomic) void(^addSubBlock)(NewMailCellType mailCellType);

@property (copy, nonatomic) void(^deleteCellBlock)(NSUInteger infoHash);

@end

@interface NewMailInfo : NSObject

-(instancetype)initWithName:(NSString *)name
                    content:(NSString *)content
            newMailCellType:(NewMailCellType)newMailCellType;

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, assign) NewMailCellType newMailCellType;

@end
