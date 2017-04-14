//
//  ViewController.m
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/13.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import "ViewController.h"
#import "NewMailTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController
{
    __weak IBOutlet UITableView *newMailtableView;
    
    NSMutableArray<NewMailInfo *> *headInfoArray;
    
    void(^addSubBlock)(NewMailCellType mailCellType);
    void(^deleteCellBlock)(NSUInteger infoHash);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    headInfoArray = @[[[NewMailInfo alloc] initWithName: @"n0" content: @"n0@xxx.com" newMailCellType: NewMailCellTypeFrom],
                      [[NewMailInfo alloc] initWithName: @"n1" content: @"n1@xxx.com" newMailCellType: NewMailCellTypeMainTo],
                      [[NewMailInfo alloc] initWithName: @"n2" content: @"n2@xxx.com" newMailCellType: NewMailCellTypeTo],
                      [[NewMailInfo alloc] initWithName: @"n3" content: @"n3@xxx.com" newMailCellType: NewMailCellTypeMainCc],
                      [[NewMailInfo alloc] initWithName: @"n4" content: @"n4@xxx.com" newMailCellType: NewMailCellTypeCc],
                      [[NewMailInfo alloc] initWithName: @"n5" content: @"n5@xxx.com" newMailCellType: NewMailCellTypeMainBcc],
                      [[NewMailInfo alloc] initWithName: @"n6" content: @"n6@xxx.com" newMailCellType: NewMailCellTypeBcc],
                      [[NewMailInfo alloc] initWithName: @"" content: @"主题" newMailCellType: NewMailCellTypeSubject]].mutableCopy;
  
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
    
    [newMailtableView registerNib:[UINib nibWithNibName: @"NewMailTableViewCell" bundle: nil] forCellReuseIdentifier:@"newMailCell"];
}

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
