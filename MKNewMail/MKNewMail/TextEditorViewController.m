//
//  TextEditorViewController.m
//  MKNewMail
//
//  Created by DONLINKS on 2017/4/14.
//  Copyright © 2017年 Donlinks. All rights reserved.
//

#import "TextEditorViewController.h"

@interface TextEditorViewController ()

@end

@implementation TextEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Standard";
    
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
