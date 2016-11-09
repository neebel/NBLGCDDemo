//
//  NBLApplyDemoViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLApplyDemoViewController.h"

@interface NBLApplyDemoViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UITextView *infoTextView;

@end

@implementation NBLApplyDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"dispatch_apply";
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
        infoTextView.text = @"执行信息请看控制台输出";
        _infoTextView = infoTextView;
    }
    
    return _infoTextView;
}

#pragma mark - Action

- (void)start
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_apply(2, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        switch (i) {
            case 0:
            {
                dispatch_group_enter(group);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [NSThread sleepForTimeInterval:1.0];//模拟耗时任务，可以调整时间模拟任务一和二的完成顺序
                    NSLog(@"任务1完成");
                    dispatch_group_leave(group);
                });
            }
                break;
                
            case 1:
            {
                dispatch_group_enter(group);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [NSThread sleepForTimeInterval:2.0];//模拟耗时任务，可以调整时间模拟任务一和二的完成顺序
                    NSLog(@"任务2完成");
                    dispatch_group_leave(group);
                });
            }
                break;
                
            default:
                break;
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });
}

@end
