//
//  MKIMAPCtrl.m
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/17.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import "MKIMAPCtrl.h"
#import "NewMailTableViewCell.h"

@implementation MKIMAPCtrl

+(void)sendMailWithHeads:(NSArray<NewMailInfo *> *) heads
      senderMailPassword:(NSString *) password
                 mailBod:(NSString *)mailBody
           completeBlock:(void(^)(NSError *error)) completeBlock {
    
    NSString *fromName = @"";
    NSString *fromMail = @"";
    
    for(NewMailInfo *info in heads){
        if(info.newMailCellType == NewMailCellTypeFrom){
            fromName = info.name;
            fromMail = info.content;
        }
        
    }
    
    //先登录邮箱
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = @"smtp.exmail.qq.com";
    smtpSession.port = 465;
    smtpSession.username = fromMail;
    smtpSession.password = password;
    smtpSession.connectionType = MCOConnectionTypeTLS; //使用加密连接
    
    MCOSMTPOperation *smtpOperation = [smtpSession loginOperation];
    [smtpOperation start:^(NSError * error) {
        if (error == MCOErrorNone) {
            //登录成功
            //构建邮箱头
            NSMutableArray<MCOAddress *> *tos = @[].mutableCopy;
            NSMutableArray<MCOAddress *> *ccs = @[].mutableCopy;
            NSMutableArray<MCOAddress *> *bccs = @[].mutableCopy;
            NSString *subject = @"";
            for(NewMailInfo *info in heads){
                if((info.newMailCellType == NewMailCellTypeMainTo ||
                   info.newMailCellType == NewMailCellTypeTo) && info.content.length > 0){
                    [tos addObject: [MCOAddress addressWithDisplayName: info.name mailbox: info.content]];
                }
                
                if((info.newMailCellType == NewMailCellTypeMainCc ||
                   info.newMailCellType == NewMailCellTypeCc) && info.content.length > 0){
                    [ccs addObject: [MCOAddress addressWithDisplayName: info.name mailbox: info.content]];
                }
                
                if((info.newMailCellType == NewMailCellTypeMainBcc ||
                   info.newMailCellType == NewMailCellTypeBcc) && info.content.length > 0){
                    [bccs addObject: [MCOAddress addressWithDisplayName: info.name mailbox: info.content]];
                }
                
                if(info.newMailCellType == NewMailCellTypeSubject){
                    subject = info.content;
                }
            }
            
            MCOMessageBuilder *messageBuilder = [[MCOMessageBuilder alloc] init];
            messageBuilder.header.from = [MCOAddress addressWithDisplayName: fromName mailbox: fromMail];   // 发送人
            messageBuilder.header.to = tos;     // 收件人（多人
            messageBuilder.header.cc = ccs;     // 抄送（多人）
            messageBuilder.header.bcc = bccs;   // 密送（多人）
            messageBuilder.header.subject = subject;    // 邮件标题
            messageBuilder.htmlBody = mailBody;         // 邮件正文
            
            // 发送邮件
            NSData * rfc822Data =[messageBuilder data];
            MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData: rfc822Data];
            [sendOperation start: completeBlock];
            
        } else if(completeBlock){
            completeBlock(error);
        }
    }];
}

@end
