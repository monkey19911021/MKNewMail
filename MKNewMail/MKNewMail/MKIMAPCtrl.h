//
//  MKIMAPCtrl.h
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/17.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewMailInfo;
@interface MKIMAPCtrl : NSObject


/**
 发送邮件

 @param heads 邮件头
 @param password 发送人密码
 @param mailBody 邮件体
 @param completeBlock 处理块
 */
+(void)sendMailWithHeads:(NSArray<NewMailInfo *> *) heads
      senderMailPassword:(NSString *) password
                 mailBod:(NSString *)mailBody
           completeBlock:(void(^)(NSError *error)) completeBlock;

@end
