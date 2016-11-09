//
//  NBLSignalDemoViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLSignalDemoViewController.h"

@interface NBLSignalDemoViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UITextView *infoTextView;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@property (nonatomic, strong) NSObject *obj;

@end

@implementation NBLSignalDemoViewController
dispatch_semaphore_t semaphore;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信号量";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.infoTextView];
    semaphore = dispatch_semaphore_create(1);
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
        infoTextView.text = @"执行结果请查看控制台输出";
        _infoTextView = infoTextView;
    }
    
    return _infoTextView;
}


- (dispatch_queue_t)concurrentQueue
{
    if (!_concurrentQueue) {
        dispatch_queue_t concurrentQueue = dispatch_queue_create("cn.neebel.GCDDemoSignal", DISPATCH_QUEUE_CONCURRENT);
        _concurrentQueue = concurrentQueue;
    }
    
    return _concurrentQueue;
}

#pragma mark - Action

- (void)start
{
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(self.concurrentQueue, ^{
            NSObject *object = [weakSelf buildAnObj];
            NSLog(@"%@", object);
        });
    }
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSObject *object = [weakSelf buildAnObj];
            NSLog(@"%@", object);
        });
    }
}


#pragma mark - Private

//目的是只创建一个对象
- (NSObject *)buildAnObj
{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (!self.obj) {//这个判断在多线程访问时是不安全的，可能存在多个线程同时进入执行的情况，使用信号量机制充当锁就没问题了
        self.obj = [[NSObject alloc] init];
    }
    dispatch_semaphore_signal(semaphore);
    
    return self.obj;
}

@end
