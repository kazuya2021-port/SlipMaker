//
//  Setting.m
//  SlipMaker
//
//  Created by uchiyama_Macmini on 2018/09/05.
//  Copyright © 2018年 uchiyama_Macmini. All rights reserved.
//

#import "Setting.h"

@implementation Setting

@synthesize UpperX1,UpperY1,LowerX1,LowerY1,AuthUpperX,AuthUpperY,AuthLowerX,AuthLowerY,UpperX2,UpperY2,LowerX2,LowerY2;
@synthesize titleQ,subQ,authorQ,multiTitle,multiSubTitle,multiAuthor,tumeTitleUp,tumeTitleDown,tumeAuthor,lendiff;
@synthesize savePath,samePath,henbai;

- (void)awakeFromNib
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString* ux1 = [ud stringForKey:@"UPPERX1"];
    NSString* uy1 = [ud stringForKey:@"UPPERY1"];
    NSString* ux2 = [ud stringForKey:@"UPPERX2"];
    NSString* uy2 = [ud stringForKey:@"UPPERY2"];
    NSString* lx1 = [ud stringForKey:@"LOWERX1"];
    NSString* ly1 = [ud stringForKey:@"LOWERY1"];
    NSString* lx2 = [ud stringForKey:@"LOWERX2"];
    NSString* ly2 = [ud stringForKey:@"LOWERY2"];
    NSString* aux = [ud stringForKey:@"AUPPERX"];
    NSString* auy = [ud stringForKey:@"AUPPERY"];
    NSString* alx = [ud stringForKey:@"ALOWERX"];
    NSString* aly = [ud stringForKey:@"ALOWERY"];
    
    NSString* tq = [ud stringForKey:@"TITLEQ"];
    NSString* sq = [ud stringForKey:@"SUBQ"];
    NSString* aq = [ud stringForKey:@"AUTHQ"];
    NSString* mt = [ud stringForKey:@"MULTITITLE"];
    NSString* ms = [ud stringForKey:@"MULTISUB"];
    NSString* ma = [ud stringForKey:@"MULTIAUTH"];
    NSString* stu = [ud stringForKey:@"SPACETITLEU"];
    NSString* std = [ud stringForKey:@"SPACETITLED"];
    NSString* sau = [ud stringForKey:@"SPACEAUTH"];
    NSString* ld = [ud stringForKey:@"LENDIFF"];
    
    NSString* hb = [ud stringForKey:@"HENBAI"];
    
    NSString* saveP = [ud stringForKey:@"SAVEPATH"];
    
    NSString* sameP = [ud stringForKey:@"SAMEPATH"];
    if(sameP){
        if([sameP compare:@"true"]==NSOrderedSame){
            [savePath setEnabled:NO];
            [opPath setEnabled:NO];
            [samePath setState:NSOnState];
        }
        else{
            [savePath setEnabled:YES];
            [opPath setEnabled:YES];
            [samePath setState:NSOffState];
        }
    }
    else{
        [savePath setEnabled:YES];
        [opPath setEnabled:YES];
        [samePath setState:NSOffState];
    }
    if(hb){
        [henbai setStringValue:hb];
    }
    if(saveP){
        [savePath setStringValue:saveP];
    }
    if(tq){
        [titleQ setStringValue:tq];
    }
    if(sq){
        [subQ setStringValue:sq];
    }
    if(aq){
        [authorQ setStringValue:aq];
    }
    if(mt){
        [multiTitle setStringValue:mt];
    }
    if(ms){
        [multiSubTitle setStringValue:ms];
    }
    if(ma){
        [multiAuthor setStringValue:ma];
    }
    if(stu){
        [tumeTitleUp setStringValue:stu];
    }
    if(std){
        [tumeTitleDown setStringValue:std];
    }
    if(sau){
        [tumeAuthor setStringValue:sau];
    }
    if(ld){
        [lendiff setStringValue:ld];
    }
    if(ux1){
        [UpperX1 setStringValue:ux1];
    }
    if(uy1){
        [UpperY1 setStringValue:uy1];
    }
    if(ux2){
        [UpperX2 setStringValue:ux2];
    }
    if(uy2){
        [UpperY2 setStringValue:uy2];
    }
    if(lx1){
        [LowerX1 setStringValue:lx1];
    }
    if(ly1){
        [LowerY1 setStringValue:ly1];
    }
    if(lx2){
        [LowerX2 setStringValue:lx2];
    }
    if(ly2){
        [LowerY2 setStringValue:ly2];
    }
    if(aux){
        [AuthUpperX setStringValue:aux];
    }
    if(auy){
        [AuthUpperY setStringValue:auy];
    }
    if(alx){
        [AuthLowerX setStringValue:alx];
    }
    if(aly){
        [AuthLowerY setStringValue:aly];
    }
}

-(IBAction)checkPath:(id)sender
{
    NSButton* btn = (NSButton*)sender;
    if([btn state] == NSOnState){
        [savePath setEnabled:NO];
        [opPath setEnabled:NO];
    }
    else{
        [savePath setEnabled:YES];
        [opPath setEnabled:YES];
    }
}

-(IBAction)openPath:(id)sender
{
    NSString* saveP = [[Macros openFileDialog:@"message" title:@"title" multiple:NO selectFile:NO selectDir:YES] objectAtIndex:0];
    if([saveP compare:@""] == NSOrderedSame) return;
    [savePath setStringValue:saveP];
}

-(IBAction)append:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[UpperX1 stringValue] forKey:@"UPPERX1"];
    [ud setObject:[UpperY1 stringValue] forKey:@"UPPERY1"];
    [ud setObject:[LowerX1 stringValue] forKey:@"LOWERX1"];
    [ud setObject:[LowerY1 stringValue] forKey:@"LOWERY1"];
    [ud setObject:[UpperX2 stringValue] forKey:@"UPPERX2"];
    [ud setObject:[UpperY2 stringValue] forKey:@"UPPERY2"];
    [ud setObject:[LowerX2 stringValue] forKey:@"LOWERX2"];
    [ud setObject:[LowerY2 stringValue] forKey:@"LOWERY2"];
    [ud setObject:[AuthUpperX stringValue] forKey:@"AUPPERX"];
    [ud setObject:[AuthUpperY stringValue] forKey:@"AUPPERY"];
    [ud setObject:[AuthLowerX stringValue] forKey:@"ALOWERX"];
    [ud setObject:[AuthLowerY stringValue] forKey:@"ALOWERY"];
    
    [ud setObject:[titleQ stringValue] forKey:@"TITLEQ"];
    [ud setObject:[subQ stringValue] forKey:@"SUBQ"];
    [ud setObject:[authorQ stringValue] forKey:@"AUTHQ"];
    [ud setObject:[multiTitle stringValue] forKey:@"MULTITITLE"];
    [ud setObject:[multiSubTitle stringValue] forKey:@"MULTISUB"];
    [ud setObject:[multiAuthor stringValue] forKey:@"MULTIAUTH"];
    [ud setObject:[tumeTitleUp stringValue] forKey:@"SPACETITLEU"];
    [ud setObject:[tumeTitleDown stringValue] forKey:@"SPACETITLED"];
    [ud setObject:[tumeAuthor stringValue] forKey:@"SPACEAUTH"];
    [ud setObject:[lendiff stringValue] forKey:@"LENDIFF"];
    
    [ud setObject:[savePath stringValue] forKey:@"SAVEPATH"];
    [ud setObject:([samePath state]==NSOnState)?@"true":@"false" forKey:@"SAMEPATH"];
    [ud setObject:[henbai stringValue] forKey:@"HENBAI"];
    NSString* funcjsx = [NSString stringWithFormat:@""
                         "#include \"funcs_doc.jsx\"\n"
                         "#include \"funcs_unit.jsx\"\n"
                         "#include \"funcs_layout.jsx\"\n"
                         "#include \"funcs_txtobj.jsx\"\n"
                         "#include \"funcs_txt.jsx\"\n"
                         "var DebugScript = false;\n"
                         "var defQ = %d;\n"
                         "var defAuthQ = %d;\n"
                         "var defSubQ = %d;\n"
                         "var multiLineBorder_Title = %d;\n"
                         "var multiLineBorder_Sub = %d;\n"
                         "var multiLineBorder_Auth = %d;\n"
                         "var tumeUpper = %.2lf;\n"
                         "var tumeLower = %.2lf;\n"
                         "var tumeAuth = %.2lf;\n"
                         "var lenDiffBorder = %d;\n"
                         "var henbaiRitu = %.2lf;\n",
                         [titleQ intValue],[authorQ intValue],[subQ intValue],
                         [multiTitle intValue],[multiSubTitle intValue],[multiAuthor intValue],
                         [tumeTitleUp doubleValue],[tumeTitleDown doubleValue],[tumeAuthor doubleValue],
                         [lendiff intValue],[henbai doubleValue]];
    [funcjsx writeToURL:[NSURL fileURLWithPath:[RESPATH stringByAppendingPathComponent:@"funcs.jsx"]] atomically:NO encoding:NSUTF8StringEncoding error:nil];
}


@end
