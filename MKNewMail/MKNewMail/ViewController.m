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
    
    //延时处理
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(start, dispatch_get_main_queue(), ^{
        [self showContact: nil];
    });
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
    //Set Custom CSS
    NSString *customCSS = @"";
    [self setCSS:customCSS];
    
    self.alwaysShowToolbar = YES;
    self.receiveEditorDidChangeEvents = NO;
    
    // HTML Content to set in the editor
    NSString *html = @"<div class='test'></div><!-- This is an HTML comment -->"
    "<p>This is a test of the <strong>ZSSRichTextEditor</strong> by <a title=\"Zed Said\" href=\"http://www.zedsaid.com\">Zed Said Studio</a></p>";
    
    // Set the base URL if you would like to use relative links, such as to images.
    self.baseURL = [NSURL URLWithString:@"http://www.zedsaid.com"];
    self.shouldShowKeyboard = NO;
    // Set the HTML contents of the editor
    [self setPlaceholder:@"This is a placeholder that will show when there is no content(html)"];
    
    [self setHTML:html];
}

- (IBAction)showContact:(id)sender {
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


#pragma mark - ZSSRichTextEditor
- (void)showInsertURLAlternatePicker {
    
    [self dismissAlertView];
    
    
}


- (void)showInsertImageAlternatePicker {
    
    [self dismissAlertView];
    
    
}

- (void)editorDidChangeWithText:(NSString *)text andHTML:(NSString *)html {
    
    NSLog(@"Text Has Changed: %@", text);
    
    NSLog(@"HTML Has Changed: %@", html);
    
}

- (void)hashtagRecognizedWithWord:(NSString *)word {
    
    NSLog(@"Hashtag has been recognized: %@", word);
    
}

- (void)mentionRecognizedWithWord:(NSString *)word {
    
    NSLog(@"Mention has been recognized: %@", word);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
