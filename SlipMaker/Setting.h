//
//  Setting.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject
{
    __weak NSTextField *UpperX1;
    __weak NSTextField *UpperY1;
    __weak NSTextField *UpperX2;
    __weak NSTextField *UpperY2;
    __weak NSTextField *LowerX1;
    __weak NSTextField *LowerY1;
    __weak NSTextField *LowerX2;
    __weak NSTextField *LowerY2;
    __weak NSTextField *AuthUpperX;
    __weak NSTextField *AuthUpperY;
    __weak NSTextField *AuthLowerX;
    __weak NSTextField *AuthLowerY;
    
    __weak NSTextField *titleQ;
    __weak NSTextField *subQ;
    __weak NSTextField *authorQ;
    
    __weak NSTextField *multiTitle;
    __weak NSTextField *multiSubTitle;
    __weak NSTextField *multiAuthor;
    
    __weak NSTextField *tumeTitleUp;
    __weak NSTextField *tumeTitleDown;
    __weak NSTextField *tumeAuthor;
    
    __weak NSTextField *lendiff;
    
    __weak NSTextField *savePath;
    
    __weak NSTextField *henbai;
    
    __weak  NSButton* samePath;
    IBOutlet  NSButton* opPath;
}

@property (nonatomic, weak)IBOutlet NSTextField*   UpperX1;
@property (nonatomic, weak)IBOutlet NSTextField*   UpperY1;
@property (nonatomic, weak)IBOutlet NSTextField*   LowerX1;
@property (nonatomic, weak)IBOutlet NSTextField*   LowerY1;
@property (nonatomic, weak)IBOutlet NSTextField*   UpperX2;
@property (nonatomic, weak)IBOutlet NSTextField*   UpperY2;
@property (nonatomic, weak)IBOutlet NSTextField*   LowerX2;
@property (nonatomic, weak)IBOutlet NSTextField*   LowerY2;
@property (nonatomic, weak)IBOutlet NSTextField*   AuthUpperX;
@property (nonatomic, weak)IBOutlet NSTextField*   AuthUpperY;
@property (nonatomic, weak)IBOutlet NSTextField*   AuthLowerX;
@property (nonatomic, weak)IBOutlet NSTextField*   AuthLowerY;
@property (nonatomic, weak)IBOutlet NSTextField*   titleQ;
@property (nonatomic, weak)IBOutlet NSTextField*   subQ;
@property (nonatomic, weak)IBOutlet NSTextField*   authorQ;
@property (nonatomic, weak)IBOutlet NSTextField*   multiTitle;
@property (nonatomic, weak)IBOutlet NSTextField*   multiSubTitle;
@property (nonatomic, weak)IBOutlet NSTextField*   multiAuthor;
@property (nonatomic, weak)IBOutlet NSTextField*   tumeTitleUp;
@property (nonatomic, weak)IBOutlet NSTextField*   tumeTitleDown;
@property (nonatomic, weak)IBOutlet NSTextField*   tumeAuthor;
@property (nonatomic, weak)IBOutlet NSTextField*   lendiff;
@property (nonatomic, weak)IBOutlet NSTextField*   henbai;
@property (nonatomic, weak)IBOutlet NSTextField*   savePath;
@property (nonatomic, weak)IBOutlet NSButton*      samePath;


-(IBAction)append:(id)sender;
-(IBAction)openPath:(id)sender;
-(IBAction)checkPath:(id)sender;
@end
