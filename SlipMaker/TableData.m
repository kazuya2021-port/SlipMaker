//
//  TableData.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/22.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "TableData.h"

@implementation TableData
@synthesize preSub,bookTitle,afterSub,author,addStatus,filePath;
+(TableData*)data
{
    TableData* d = [[TableData alloc] init];
    d.preSub = @"";
    d.bookTitle = @"";
    d.afterSub = @"";
    d.author = @"";
    d.addStatus = @"";
    d.filePath = @"";
    
    return d;
}

-(TableData*)copy
{
    TableData* newData=[TableData data];
    newData.preSub = self.preSub;
    newData.bookTitle = self.bookTitle;
    newData.afterSub = self.afterSub;
    newData.author = self.author;
    newData.addStatus = self.addStatus;
    newData.filePath = self.filePath;
    return newData;
}
@end
