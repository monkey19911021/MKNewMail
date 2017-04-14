//
//  NewMailTableViewCell.m
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/13.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import "NewMailTableViewCell.h"

@implementation NewMailTableViewCell
{
     __weak IBOutlet UIButton *titleBtn;
    __weak IBOutlet NSLayoutConstraint *titleLayoutConstraint;
    
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet NSLayoutConstraint *nameLayoutConstraint;
    __weak IBOutlet UITextField *contentTextField;
    __weak IBOutlet UIButton *deleteBtn;
    __weak IBOutlet NSLayoutConstraint *deleteLayoutConstraint;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setMailInfo:(NewMailInfo *)mailInfo {
    _mailInfo = mailInfo;
    nameTextField.text = mailInfo.name;
    contentTextField.text = mailInfo.content;
    titleBtn.hidden = (mailInfo.newMailCellType == NewMailCellTypeTo || mailInfo.newMailCellType == NewMailCellTypeCc || mailInfo.newMailCellType == NewMailCellTypeBcc);
    
    titleLayoutConstraint.constant = mailInfo.newMailCellType == NewMailCellTypeSubject? 56: 90;
    
    nameLayoutConstraint.constant = mailInfo.newMailCellType == NewMailCellTypeSubject? 0: 73;
    
    deleteLayoutConstraint.constant = mailInfo.newMailCellType == NewMailCellTypeSubject? 0: 44;
    
    [titleBtn setImage: mailInfo.newMailCellType == NewMailCellTypeSubject || mailInfo.newMailCellType == NewMailCellTypeFrom? nil: [UIImage imageNamed:@"add"] forState: UIControlStateNormal];
    
    contentTextField.placeholder = mailInfo.newMailCellType == NewMailCellTypeSubject? @"主题": @"邮箱地址";
    
    deleteBtn.hidden = mailInfo.newMailCellType == NewMailCellTypeFrom;
    
    NSString *title = @"";
    switch (mailInfo.newMailCellType) {
        case NewMailCellTypeFrom:
            title = @"发送人:";
            break;
        case NewMailCellTypeMainTo:
            title = @"收件人:";
            break;
        case NewMailCellTypeMainCc:
            title = @"抄送:";
            break;
        case NewMailCellTypeMainBcc:
            title = @"密送:";
            break;
        case NewMailCellTypeSubject:
            title = @"主题:";
            break;
            
        default:
            break;
    }
    [titleBtn setTitle: title forState: UIControlStateNormal];
}

-(IBAction)addSub:(id)sender {
    if(_addSubBlock){
        _addSubBlock(_mailInfo.newMailCellType);
    }
}

-(IBAction)deleteSub:(id)sender {
    nameTextField.text = @"";
    contentTextField.text = @"";
    
    if(_deleteCellBlock){
        _deleteCellBlock(_mailInfo.hash);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation NewMailInfo

-(instancetype)initWithName:(NSString *)name
                    content:(NSString *)content
            newMailCellType:(NewMailCellType)newMailCellType {
    if(self = [super init]){
        _name = name;
        _content = content;
        _newMailCellType = newMailCellType;
    }
    return self;
}

@end
