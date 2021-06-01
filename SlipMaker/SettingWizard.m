//
//  SettingWizard.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "SettingWizard.h"

@implementation SettingWizard

-(IBAction)openWizard:(id)sender
{
    [tabview selectTabViewItemWithIdentifier:@"GetUpper1"];
    [win makeKeyAndOrderFront:self];
}
-(IBAction)getUpPosTop:(id)sender
{
    // [左,上,右,下]
    AdobeGeometric* argeo = [illustrator getPosition];
    if(argeo.x1 != 0 && argeo.y1 != 0 && argeo.x2 != 0)
    {
        [[set UpperX1] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.x1 + 14]]; // カテゴリ分ずらす
        [[set UpperY1] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.y1]];
        [[set UpperX2] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.x2 - 14]];
        [tabview selectTabViewItemWithIdentifier:@"GetUpper2"];
    }
    else
        [win close];
}
-(IBAction)getUpPosDown:(id)sender
{
    // [左,上,右,下]
    AdobeGeometric* argeo = [illustrator getPosition];
    if(argeo.y2 != 0)
    {
        [[set UpperY2] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.y2]];
        [tabview selectTabViewItemWithIdentifier:@"GetLower"];
    }
    else
        [win close];
}
-(IBAction)getLowPos:(id)sender
{
    // [左,上,右,下]
    AdobeGeometric* argeo = [illustrator getPosition];
    if(argeo.y1 != 0 && argeo.x2 != 0)
    {
        [[set LowerY1] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.y1]];
        [[set LowerX2] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.x2]];
        [tabview selectTabViewItemWithIdentifier:@"AuthUp"];
    }
    else
        [win close];
}
-(IBAction)getAuthUpPos:(id)sender
{
    // [左,上,右,下]
    AdobeGeometric* argeo = [illustrator getPosition];
    if(argeo.x1 != 0 && argeo.y1 != 0)
    {
        [[set AuthUpperX] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.x1]];
        [[set AuthUpperY] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.y1]];
        [tabview selectTabViewItemWithIdentifier:@"AuthDown"];
    }
    else
        [win close];
}
-(IBAction)getAuthLowPos:(id)sender
{
    // [左,上,右,下]
    AdobeGeometric* argeo = [illustrator getPosition];
    if(argeo.x2 != 0 && argeo.y2 != 0 && argeo.y1 != 0)
    {
        [[set LowerX1] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.x1 + 2]];
        [[set AuthLowerX] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.x2]];
        [[set AuthLowerY] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.y2]];
        [[set LowerY2] setStringValue:[NSString stringWithFormat:@"%.11lf",argeo.y1 - 2]];
    }
    [win close];
}
@end
