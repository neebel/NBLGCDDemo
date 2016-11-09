//
//  NBLGroupDemoViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLGroupDemoViewController.h"

@interface NBLGroupDemoViewController ()

@property (nonatomic, strong) UIButton *blockThreadStartButton;
@property (nonatomic, strong) UIButton *unBlockThreadStartButton;
@property (nonatomic, strong) UITextView *infoTextView;

@end


@implementation NBLGroupDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dispatch group";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.blockThreadStartButton];
    [self.view addSubview:self.unBlockThreadStartButton];
    [self.view addSubview:self.infoTextView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (UIButton *)blockThreadStartButton
{
    if (!_blockThreadStartButton) {
        UIButton *blockThreadStartButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 80, 160, 30)];
        [blockThreadStartButton setTitle:@"阻塞线程的Group" forState:UIControlStateNormal];
        [blockThreadStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [blockThreadStartButton addTarget:self action:@selector(startBlockGroup) forControlEvents:UIControlEventTouchUpInside];
        blockThreadStartButton.backgroundColor = [UIColor blueColor];
        _blockThreadStartButton = blockThreadStartButton;
    }
    
    return _blockThreadStartButton;
}


- (UIButton *)unBlockThreadStartButton
{
    if (!_unBlockThreadStartButton) {
        UIButton *unBlockThreadStartButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 120, 180, 30)];
        [unBlockThreadStartButton setTitle:@"非阻塞线程的Group" forState:UIControlStateNormal];
        [unBlockThreadStartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [unBlockThreadStartButton addTarget:self action:@selector(startUnBlockGroup) forControlEvents:UIControlEventTouchUpInside];
        unBlockThreadStartButton.backgroundColor = [UIColor blueColor];
        _unBlockThreadStartButton = unBlockThreadStartButton;
    }
    
    return _unBlockThreadStartButton;
}


- (UITextView *)infoTextView
{
    if (!_infoTextView) {
        UITextView *infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(80, 160, self.view.frame.size.width - 120, 300)];
        infoTextView.textColor = [UIColor redColor];
        infoTextView.text = @"执行信息请看控制台输出";
        _infoTextView = infoTextView;
    }
    
    return _infoTextView;
}

#pragma mark - Action

- (void)startBlockGroup
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [NSThread sleepForTimeInterval:1.0];//模拟耗时任务，可以调整时间模拟任务一和二的完成顺序
        NSLog(@"任务1完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [NSThread sleepForTimeInterval:2.0];//模拟耗时任务，可以调整时间模拟任务一和二的完成顺序
        NSLog(@"任务2完成");
        dispatch_group_leave(group);
    });
    
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"所有任务完成");
}


- (void)startUnBlockGroup
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [NSThread sleepForTimeInterval:1.0];//模拟耗时任务，可以调整时间模拟任务一和二的完成顺序
        NSLog(@"任务1完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:2.0];//模拟耗时任务，可以调整时间模拟任务一和二的完成顺序
        NSLog(@"任务2完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });
    
    NSLog(@"非阻塞所以会先打印这句话");
}

@end
