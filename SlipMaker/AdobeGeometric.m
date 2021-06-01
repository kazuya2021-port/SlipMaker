//
//  AdobeGeometric.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/14.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "AdobeGeometric.h"

@implementation AdobeGeometric
@synthesize x1,x2,y1,y2;

+(AdobeGeometric*)geometric
{
    AdobeGeometric* ret = [[AdobeGeometric alloc] init];
    ret.x1 = 0;
    ret.x2 = 0;
    ret.y1 = 0;
    ret.y2 = 0;
    return ret;
}
@end
