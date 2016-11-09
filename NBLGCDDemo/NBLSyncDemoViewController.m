//
//  NBLSyncDemoViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLSyncDemoViewController.h"

@interface NBLSyncDemoViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UITextView *infoTextView;

@end

@implementation NBLSyncDemoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"dispatch_sync";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.infoTextView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (UIButton *)startButton
{
    if (!_startButton) {
        UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 80, 80, 30)];
        [startButton setTitle:@"点我开始" forState:UIControlStateNormal];
        [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        startButton.backgroundColor = [UIColor blueColor];
        _startButton = startButton;
    }
    
    return _startButton;
}


- (UITextView *)infoTextView
{
    if (!_infoTextView) {
        UITextView *infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(60, 120, self.view.frame.size.width - 120, 300)];
        infoTextView.textColor = [UIColor redColor];
        infoTextView.text = @"执行轨迹请看控制台输出";
        _infoTextView = infoTextView;
    }
    
    return _infoTextView;
}

#pragma mark - Action

- (void)start
{
    NSLog(@"准备执行dispatch_sync");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"正在执行Block");
        [NSThread sleepForTimeInterval:2.0];//模拟耗时操作
    });
    
    NSLog(@"dispatch_sync后面代码");
//      死锁
//    NSLog(@"准备执行dispatch_sync");
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"正在执行Block");
//        [NSThread sleepForTimeInterval:2.0];//模拟耗时操作
//    });
//    
//    NSLog(@"dispatch_sync后面代码");
}

@end
