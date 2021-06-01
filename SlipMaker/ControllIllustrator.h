//
//  ControllIllustrator.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdobeGeometric.h"

@interface ControllIllustrator : NSObject
{
    NSString* useApp;
    NSString* useProcess;
    AdobeGeometric* upTitle;
    AdobeGeometric* lowTitle;
    AdobeGeometric* authGeo;
}
-(void)initializeVariable:(NSMutableDictionary*)allPos;
-(void)waitReadFile;
-(void)runApplication;
-(BOOL)addAuthor:(NSString*)author;
-(BOOL)addTitle:(NSString*)title preSub:(NSString*)pre afterSub:(NSString*)aft;
-(AdobeGeometric*)getPosition;
-(BOOL)deleteTemplateStringUp;
-(BOOL)deleteTemplateStringDown;
-(BOOL)deleteTemplateStringAuthor;
-(void)saveCurrentFile:(NSString*)savePath;
-(void)minWindow;
@end
