//
//  NBLPhotoManager.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/9.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLPhotoManager.h"

@implementation NBLPhotoManager

+ (instancetype)sharedManager
{
    static NBLPhotoManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    
    return _manager;
}

@end
