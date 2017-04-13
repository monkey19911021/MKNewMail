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

@interface NewMailTableViewCell : UITableViewCell

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, assign) NewMailCellType newMailCellType;
@property(nonatomic, copy) NSIndexPath *indexPath;

@property (copy, nonatomic) void(^addSubBlock)(NewMailCellType mailCellType);

@property (copy, nonatomic) void(^deleteCellBlock)(NSIndexPath *indexPath, NewMailCellType mailCellType);

@end
