//
//  ViewController.m
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/13.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import "ViewController.h"
#import "NewMailTableViewCell.h"
#import "SVProgressHUD.h"
#import "MKIMAPCtrl.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
{
    __weak IBOutlet UITableView *newMailtableView;
    
    NSMutableArray<NewMailInfo *> *headInfoArray;
    
    void(^addSubBlock)(NewMailCellType mailCellType);
    void(^deleteCellBlock)(NSUInteger infoHash);

    CGFloat originTableViewTopContraintValue;
    __weak IBOutlet NSLayoutConstraint *tableViewTopContraint;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    originTableViewTopContraintValue = tableViewTopContraint.constant;
    [SVProgressHUD setMinimumDismissTimeInterval: 0.3];
    
    [self configureContent];
    
    [self configureDataSource];
    [self configureBlock];
    
    [self.view bringSubviewToFront: newMailtableView.superview];
    [newMailtableView registerNib:[UINib nibWithNibName: @"NewMailTableViewCell" bundle: nil] forCellReuseIdentifier:@"newMailCell"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showContact: nil];
}

//设置数据源
-(void)configureDataSource {
    headInfoArray = @[[[NewMailInfo alloc] initWithName: @"DK_M0nk1y" content: @"liujh@donlinks.com" newMailCellType: NewMailCellTypeFrom],
                      [[NewMailInfo alloc] initWithName: @"M0nk1y" content: @"457870936@qq.com" newMailCellType: NewMailCellTypeMainTo],
                      [[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: NewMailCellTypeMainCc],
                      [[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: NewMailCellTypeMainBcc],
                      [[NewMailInfo alloc] initWithName: @"" content: @"凌云邮箱测试邮件（请无视）" newMailCellType: NewMailCellTypeSubject]].mutableCopy;

}

//设置邮件头表格的代码块
-(void)configureBlock {
    __weak NSMutableArray *weakHeadInfoArray = headInfoArray;
    __weak UITableView *weakNewMailtableView = newMailtableView;
    
    addSubBlock = ^(NewMailCellType mailCellType) {
        __strong NSMutableArray *strongHeadInfoArray = weakHeadInfoArray;
        __strong UITableView *strongNewMailtableView = weakNewMailtableView;
        NewMailInfo *newMailInfo = [[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: mailCellType+1];
        NSInteger index = 0;
        for(NewMailInfo *info in strongHeadInfoArray){
            if(info.newMailCellType == mailCellType){
                index = [strongHeadInfoArray indexOfObject: info] + 1;
                break;
            }
        }
        [strongHeadInfoArray insertObject: newMailInfo atIndex: index];
        [strongNewMailtableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: index inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
    };
    
    deleteCellBlock = ^(NSUInteger infoHash) {
        __strong NSMutableArray *strongHeadInfoArray = weakHeadInfoArray;
        __strong UITableView *strongNewMailtableView = weakNewMailtableView;
        
        NSInteger index = 0;
        for(NewMailInfo *info in strongHeadInfoArray){
            if(info.hash == infoHash){
                index = [strongHeadInfoArray indexOfObject: info];
                NewMailCellType type = info.newMailCellType;
                if(type == NewMailCellTypeMainTo || type == NewMailCellTypeMainCc || type == NewMailCellTypeMainBcc){
                    info.name = @"";
                    info.content = @"";
                    [strongNewMailtableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: index inSection: 0]] withRowAnimation: UITableViewRowAnimationNone];
                    return;
                }
                break;
            }
        }
        
        
        [strongHeadInfoArray removeObjectAtIndex: index];
        [strongNewMailtableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: index inSection: 0]] withRowAnimation: UITableViewRowAnimationLeft];
    };
}

//设置邮件内容
-(void)configureContent {
    self.alwaysShowToolbar = YES;
    self.receiveEditorDidChangeEvents = NO;
    
    self.shouldShowKeyboard = YES;
    self.enabledToolbarItems = @[ZSSRichTextEditorToolbarInsertImage,
                                 ZSSRichTextEditorToolbarInsertImageFromDevice,
                                 ZSSRichTextEditorToolbarInsertLink,
                                 ZSSRichTextEditorToolbarBold,
                                 ZSSRichTextEditorToolbarStrikeThrough,
                                 ZSSRichTextEditorToolbarUnderline,
                                 ZSSRichTextEditorToolbarParagraph,
                                 ZSSRichTextEditorToolbarH1,
                                 ZSSRichTextEditorToolbarH2,
                                 ZSSRichTextEditorToolbarH3,
                                 ZSSRichTextEditorToolbarTextColor,
                                 ZSSRichTextEditorToolbarBackgroundColor,
                                 ZSSRichTextEditorToolbarUnorderedList,
                                 ZSSRichTextEditorToolbarOrderedList,
                                 ZSSRichTextEditorToolbarHorizontalRule];
    
    NSString *html = @"<br><br>"
    "<p>来自凌云App</p>";
    [self setHTML:html];
}

//显示邮件头
- (IBAction)showContact:(id)sender {
    if(!sender){
        return;
    }
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        tableViewTopContraint.constant = tableViewTopContraint.constant == 0? originTableViewTopContraintValue: 0;
        [self.view layoutIfNeeded];
    } completion: nil];
}

//发送邮件
- (IBAction)sendMail:(id)sender {
    for(NewMailInfo *info in headInfoArray){
        if((info.newMailCellType == NewMailCellTypeFrom ||
           info.newMailCellType == NewMailCellTypeMainTo ||
           info.newMailCellType == NewMailCellTypeSubject) && info.content.length == 0){
            [SVProgressHUD showErrorWithStatus: @"邮件头信息不完整"];
            if(tableViewTopContraint.constant != 0){
                [self showContact: @""];
            }
            return;
        }
    }
    
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle: @"发送人邮箱密码" message: @"不能为空" preferredStyle: UIAlertControllerStyleAlert];
    [ctrl addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *pwd = ctrl.textFields[0].text;
        [SVProgressHUD showWithStatus: @"发送中"];
        [MKIMAPCtrl sendMailWithHeads: headInfoArray senderMailPassword: pwd mailBod: [self getHTML] completeBlock:^(NSError *error) {
            if(!error){
                [SVProgressHUD showSuccessWithStatus: @"发送成功"];
            }else{
                [SVProgressHUD showErrorWithStatus: @"发送失败"];
            }
        }];
    }]];
    [ctrl addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler: nil]];
    [ctrl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"邮箱密码";
        textField.secureTextEntry = YES;
    }];
    [self presentViewController: ctrl animated: YES completion: nil];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return headInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"newMailCell"];
    
    NewMailInfo *info = headInfoArray[indexPath.row];
    cell.mailInfo =info;
    cell.addSubBlock = addSubBlock;
    cell.deleteCellBlock = deleteCellBlock;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
