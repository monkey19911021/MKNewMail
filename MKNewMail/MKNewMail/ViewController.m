//
//  ViewController.m
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/13.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import "ViewController.h"
#import "NewMailTableViewCell.h"
#import <mailcore2-ios/MailCore/MailCore.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
{
    __weak IBOutlet UITableView *newMailtableView;
    
    NSMutableArray<NewMailInfo *> *headInfoArray;
    
    void(^addSubBlock)(NewMailCellType mailCellType);
    void(^deleteCellBlock)(NSUInteger infoHash);

    __weak IBOutlet NSLayoutConstraint *tableViewTopContraint; //-667
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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

-(void)configureDataSource {
    headInfoArray = @[[[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: NewMailCellTypeFrom],
                      [[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: NewMailCellTypeMainTo],
                      [[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: NewMailCellTypeMainCc],
                      [[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: NewMailCellTypeMainBcc],
                      [[NewMailInfo alloc] initWithName: @"" content: @"" newMailCellType: NewMailCellTypeSubject]].mutableCopy;

}

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

- (IBAction)showContact:(id)sender {
    if(!sender){
        return;
    }
        
    [self.view layoutIfNeeded]; //改变量影响到的最终视图做layoutIfNeeded
    [UIView animateWithDuration:0.3 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
        tableViewTopContraint.constant = tableViewTopContraint.constant == 0? -667: 0;
        [self.view layoutIfNeeded]; //与上一句形成包围
    } completion: nil];
}

//发送邮件
- (IBAction)sendMail:(id)sender {
    for(NewMailInfo *info in headInfoArray){
        if(info.content.length > 0){
            NSLog(@"%@", info.content);
        }
    }
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
