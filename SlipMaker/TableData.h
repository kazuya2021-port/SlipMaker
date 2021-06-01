//
//  TableData.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/22.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableData : NSObject
{
    NSString* preSub;
    NSString* bookTitle;
    NSString* afterSub;
    NSString* author;
    NSString* addStatus;
    NSString* filePath;
}
@property (nonatomic,copy) NSString* preSub;
@property (nonatomic,copy) NSString* bookTitle;
@property (nonatomic,copy) NSString* afterSub;
@property (nonatomic,copy) NSString* author;
@property (nonatomic,copy) NSString* addStatus;
@property (nonatomic,copy) NSString* filePath;

+(TableData*)data;
-(TableData*)copy;
@end
