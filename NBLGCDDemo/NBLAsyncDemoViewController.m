//
//  NBLAsyncDemoViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLAsyncDemoViewController.h"

@interface NBLAsyncDemoViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UITextView *infoTextView;

@end


@implementation NBLAsyncDemoViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"dispatch_async";
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
        infoTextView.text = @"执行轨迹：\n\n";
        _infoTextView = infoTextView;
    }

    return _infoTextView;
}

#pragma mark - Action

- (void)start
{
    NSString *threadInfo = [NSString stringWithFormat:@"dispatch_async之前线程信息：%@\n\n", [NSThread currentThread]];
    [self fillTextInfo:threadInfo];
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[NSThread currentThread] setName:@"dispatch_async demo"];
        NSMutableString *resultStr = [NSMutableString string];
        [resultStr appendString:[NSString stringWithFormat:@"任务所在线程信息：%@\n\n", [NSThread currentThread]]];
        [resultStr appendString:@"耗时任务开始执行\n\n"];
        [NSThread sleepForTimeInterval:3.0];//模拟耗时操作
        [resultStr appendString:@"耗时任务执行完毕\n\n"];
        
        //在主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf fillTextInfo:resultStr];
        });
    });

    [self fillTextInfo:@"任务块后的执行代码\n\n"];
}


#pragma mark - Private

- (void)fillTextInfo:(NSString *)info
{
    NSMutableString *tmpStr = [NSMutableString stringWithString:self.infoTextView.text];
    [tmpStr appendString:info];
    self.infoTextView.text = tmpStr;
}

@end
