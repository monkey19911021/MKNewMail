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

-(void)setName:(NSString *)name {
    _name = name;
    nameTextField.text = _name;
}

-(void)setContent:(NSString *)content {
    _content = content;
    contentTextField.text = _content;
}

-(void)setNewMailCellType:(NewMailCellType)newMailCellType {
    _newMailCellType = newMailCellType;
    titleBtn.hidden = (_newMailCellType == NewMailCellTypeTo || _newMailCellType == NewMailCellTypeCc || _newMailCellType == NewMailCellTypeBcc);
    
    titleLayoutConstraint.constant = _newMailCellType == NewMailCellTypeSubject? 56: 90;
    
    nameLayoutConstraint.constant = _newMailCellType == NewMailCellTypeSubject? 0: 73;
    
    deleteLayoutConstraint.constant = _newMailCellType == NewMailCellTypeSubject? 0: 44;
    
    [titleBtn setImage: _newMailCellType == NewMailCellTypeSubject || _newMailCellType == NewMailCellTypeFrom? nil: [UIImage imageNamed:@"add"] forState: UIControlStateNormal];
    
    contentTextField.placeholder = _newMailCellType == NewMailCellTypeSubject? @"主题": @"邮箱地址";
    
    NSString *title = @"";
    switch (_newMailCellType) {
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
        _addSubBlock(_newMailCellType);
    }
}

-(IBAction)deleteSub:(id)sender {
    if(_deleteCellBlock){
        _deleteCellBlock(_indexPath, _newMailCellType);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
