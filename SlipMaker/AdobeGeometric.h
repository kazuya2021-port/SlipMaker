//
//  AdobeGeometric.h
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/14.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdobeGeometric : NSObject
{
    double x1;
    double y1;
    double x2;
    double y2;
}
@property (nonatomic, assign)double x1;
@property (nonatomic, assign)double x2;
@property (nonatomic, assign)double y1;
@property (nonatomic, assign)double y2;
+(AdobeGeometric*)geometric;
@end
