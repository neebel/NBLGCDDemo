//
//  NBLBarrierDemoViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLBarrierDemoViewController.h"

@interface NBLBarrierDemoViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UITextView *infoTextView;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation NBLBarrierDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dispatch barrier";
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


- (dispatch_queue_t)concurrentQueue
{
    if (!_concurrentQueue) {
        dispatch_queue_t concurrentQueue = dispatch_queue_create("cn.neebel.GCDDemoBarrier", DISPATCH_QUEUE_CONCURRENT);
        _concurrentQueue = concurrentQueue;
    }

    return _concurrentQueue;
}

#pragma mark - Action

- (void)start
{
    for (NSInteger i = 0; i < 3; i++) {
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"任务%@", [NSNumber numberWithInteger:i].stringValue);
        });
    }
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        NSLog(@"任务barrier");
    });
    
    for (NSInteger i = 3; i < 6; i++) {
        dispatch_async(self.concurrentQueue, ^{
            NSLog(@"任务%@", [NSNumber numberWithInteger:i].stringValue);
        });
    }
    
}

@end
