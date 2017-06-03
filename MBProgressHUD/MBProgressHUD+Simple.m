//
//  HUDView+Extension.m
//  shangcheng
//
//  Created by wxl on 15/7/5.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MBProgressHUD+Simple.h"

@implementation MBProgressHUD (Simple)
static MBProgressHUD *_HUD;

+ (id)showOnlyText:(NSString*)text
{
    _HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
    _HUD.mode = MBProgressHUDModeText;
    _HUD.labelText = text;
    _HUD.margin = 15.f;
    _HUD.removeFromSuperViewOnHide = YES;
    
    [_HUD hide:YES afterDelay:2];
    return _HUD;
}

+ (id)showIndicatorWithText:(NSString*)text
{
    _HUD = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] windows] firstObject]];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:_HUD];
//    _HUD.labelText = text;
    _HUD.detailsLabelText = text;
    [_HUD hide:YES afterDelay:2];
    [_HUD show:YES];
    
    return _HUD;
}

+ (void)hide
{
    [_HUD hide:YES];
}

@end
