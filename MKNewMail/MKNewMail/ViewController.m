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
    
    NSMutableArray *headInfoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    headInfoArray = @[@{@"name": @"n0", @"content": @"n0@xxx.com", @"type": @(NewMailCellTypeFrom)},
                      @{@"name": @"n1", @"content": @"n1@xxx.com", @"type": @(NewMailCellTypeMainTo)},
                      @{@"name": @"n2", @"content": @"n2@xxx.com", @"type": @(NewMailCellTypeTo)},
                      @{@"name": @"n3", @"content": @"n3@xxx.com", @"type": @(NewMailCellTypeMainCc)},
                      @{@"name": @"n4", @"content": @"n4@xxx.com", @"type": @(NewMailCellTypeCc)},
                      @{@"name": @"n5", @"content": @"n5@xxx.com", @"type": @(NewMailCellTypeMainBcc)},
                      @{@"name": @"n6", @"content": @"n6@xxx.com", @"type": @(NewMailCellTypeBcc)},
                      @{@"name": @"", @"content": @"主题", @"type": @(NewMailCellTypeSubject)}].mutableCopy;
  
    
    [newMailtableView registerNib:[UINib nibWithNibName: @"NewMailTableViewCell" bundle: nil] forCellReuseIdentifier:@"newMailCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return headInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"newMailCell"];
    
    NSDictionary *dic = headInfoArray[indexPath.row];
    cell.newMailCellType = [dic[@"type"] integerValue];
    cell.name = dic[@"name"];
    cell.content = dic[@"content"];
    cell.indexPath = indexPath;
    cell.addSubBlock = ^(NewMailCellType mailCellType) {
        NSDictionary *dic = @{@"name": @"", @"content": @"", @"type": @(mailCellType+1)};
        NSInteger index = 0;
        for(NSDictionary *d in headInfoArray){
            if(mailCellType == NewMailCellTypeMainTo ||
               mailCellType == NewMailCellTypeMainCc ||
               mailCellType == NewMailCellTypeMainBcc){
                index = [headInfoArray indexOfObject: d] + 1;
                break;
            }
        }
        [headInfoArray insertObject: dic atIndex: index];
        [newMailtableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: index inSection: 0]] withRowAnimation: UITableViewRowAnimationFade];
    };
    
    cell.deleteCellBlock = ^(NSIndexPath *indexPath, NewMailCellType mailCellType) {
        
    };
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
