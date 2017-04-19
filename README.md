## 1. 目标
制作一个邮箱发送邮件的功能，具有添加删除联系人、图文混排的富文本。主要材料有：

①. 第三方邮件SDK: _[MailCore2](https://github.com/MailCore/mailcore2)_，使用 CocoaPods 安装: `pod 'mailcore2-ios'`, 它是一个200M 大的 .a 文件，所以下载要好久。如果不想等也可以用工程依赖的方法导入，步骤如下：

```
1. 从 MailCore2 仓库中下载代码到本地。
2. 把build-mac/mailcore2.xcodeproj拖进工程
3. 添加项目依赖，Build Phases ——> Target Dependencies ——> 添加 static mailcore2 ios(mailcore2)
4. 项目添加静态库链接，Build Phases ——> Link Binary With Libraries ——> 添加 libMailCore-ios.a、CFNetwork.framework、Security.framework
5. 设置Flags，Build Setting ——> Other Linker Flags -> -lctemplate-ios -letpan-ios -lxml2 -lsasl2 -liconv -ltidy -lz -lc++ -lresolv -stdlib=libc++ -ObjC
```

②. 富文本工具：_[ZSSRichTextEditor](https://github.com/nnhubbard/ZSSRichTextEditor)_, 可以使用 CocoaPods 安装：`pod 'ZSSRichTextEditor'`

![图例](https://camo.githubusercontent.com/3f9c01eba9c69d030a69faaa1a2e01a733244627/687474703a2f2f636c2e6c792f696d6167652f3369343134303367323030422f64656d6f2e676966)


## 2. 使用 ZSSRichTextEditor 设置邮件编辑页面
视图控制器 viewController 继承 ZSSRichTextEditor： `@interface ViewController : ZSSRichTextEditor`

```objc
self.alwaysShowToolbar = YES; //是否一直显示工具栏
self.receiveEditorDidChangeEvents = NO; //是否接收编辑器事件，YES的话可以通过实现父类方法操作

self.shouldShowKeyboard = YES; //是否自动显示键盘
self.enabledToolbarItems = @[ZSSRichTextEditorToolbarInsertImage, //插入网络图片
                             ZSSRichTextEditorToolbarInsertImageFromDevice, //插入本地图片
                             ZSSRichTextEditorToolbarInsertLink, //插入连接
                             ZSSRichTextEditorToolbarBold, //字体加粗
                             ZSSRichTextEditorToolbarStrikeThrough, //删除线
                             ZSSRichTextEditorToolbarUnderline, //下划线
                             ZSSRichTextEditorToolbarParagraph, //自然段，默认的文字排版方式
                             ZSSRichTextEditorToolbarH1, //h1标题
                             ZSSRichTextEditorToolbarH2, //h2标题
                             ZSSRichTextEditorToolbarH3, //h3标题
                             ZSSRichTextEditorToolbarTextColor, //字体颜色
                             ZSSRichTextEditorToolbarBackgroundColor, //字体背景色
                             ZSSRichTextEditorToolbarUnorderedList, //排序不加序号
                             ZSSRichTextEditorToolbarOrderedList, //加序号
                             ZSSRichTextEditorToolbarHorizontalRule //分割线]; //工具栏加载的工具，默认加载所有工具

NSString *html = @"<br><br>"
"<p>来自凌云App</p>";
[self setHTML:html]; //设置内容
```
除了以上这些基本用法还有很多其他有用的方法提供使用。因为该工具使用本地化字符串，所以我们需要做一个本地化文本，新建一个 `Localizable.strings` 文件：

```
{
	"Image scale, 0.5 by default" = "\U7f29\U653e\U56fe\U7247\Uff0c\U9ed8\U8ba40.5";
	"Insert Image From Device" = "\U4ece\U76f8\U518c\U9009\U62e9\U56fe\U7247";
	"Pick New Image" = "\U9009\U62e9\U65b0\U56fe\U7247";
	"Pick Image" = "\U9009\U62e9\U56fe\U7247";
	Cancel = "\U53d6\U6d88";
	Title = "\U6807\U9898";
	"URL (required)" = "http://";
	"Insert Link" = "\U63d2\U5165\U8fde\U63a5";
	Update = "\U66f4\U65b0";
	Insert = "\U63d2\U5165";
	"BG Color" = "\U80cc\U666f\U8272"; 
	"Text Color" = "\U6587\U5b57\U989c\U8272";
	Alt = "\U66ff\U4ee3\U6587\U5b57";
	"Insert Image" = "\U63d2\U5165\U56fe\U7247\U5730\U5740";
}
```
![截图](http://mkapple.cn/images/mc2_sendmail/01.png)

## 3. 使用 IMAP 发送邮件

### 3.1 登录 IMAP
```objc
MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];  
smtpSession.hostname = @"smtp.exmail.qq.com";  //使用 QQ 的企业邮箱
smtpSession.port = 465;   //加密传输端口
smtpSession.username = @"hello@qq.com";  
smtpSession.password = @"passward";  
smtpSession.connectionType = MCOConnectionTypeTLS;  //加密传输
  
MCOSMTPOperation *smtpOperation = [smtpSession loginOperation];  
[smtpOperation start:^(NSError * error) {  
    if (error == nil) {  
        NSLog(@"login account successed");  
    } else {  
        NSLog(@"login account failure: %@", error);  
    }  
}];
```

### 3.2 构建邮件内容
```objc
MCOMessageBuilder *messageBuilder = [[MCOMessageBuilder alloc] init];  
messageBuilder.header.from = [MCOAddress addressWithDisplayName:@"张三" mailbox:@"111111@qq.com"];   // 发送人  
messageBuilder.header.to = @[[MCOAddress addressWithMailbox:@"222222@qq.com"]];       // 收件人（多人）  
messageBuilder.header.cc = @[[MCOAddress addressWithMailbox:@"@333333qq.com"]];      // 抄送（多人）  
messageBuilder.header.bcc = @[[MCOAddress addressWithMailbox:@"444444@qq.com"]];    // 密送（多人）  
messageBuilder.header.subject = @"测试邮件";    // 邮件标题  
messageBuilder.htmlBody = @"hello world";           // 邮件正文, 富文本可以导出 html 内容

/*  
 如果邮件是回复或者转发，原邮件中往往有附件以及正文中有其他图片资源， 
 如果有需要你可将原文原封不动的也带过去，这里发送的正文就可以如下配置  
 */  
NSString * bodyHtml = @"<p>我是原邮件正文</p>";  
NSString *body = @"我是邮件回复的内容";  
NSMutableString*fullBodyHtml = [NSMutableString stringWithFormat:@"%@<br/>-------------原始邮件-------------<br/>%@",[body stringByReplacingOccurrencesOfString:@"\n"withString:@"<br/>"],bodyHtml];  
[messageBuilder setHTMLBody:fullBodyHtml];  
  
// 添加正文里的附加资源  
NSArray *inattachments = msgPaser.htmlInlineAttachments;  
for (MCOAttachment *attachment in inattachments) {  
    [messageBuilder addRelatedAttachment:attachment];    //添加html正文里的附加资源（图片）  
}  
  
// 添加邮件附件  
for (MCOAttachment *attachment in attachments) {  
    [messageBuilder addAttachment:attachment];    //添加附件  
} 
```

### 3.3 发送邮件
```objc
NSData * rfc822Data =[messageBuilder data];  
MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];  
[sendOperation start:^(NSError *error) {  
    if (error == nil) {  
        NSLog(@"send message successed");  
    } else {  
        NSLog(@"send message failure: %@", error);  
    }  
}];
```
