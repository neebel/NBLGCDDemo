//
//  NBLOnceDemoViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLOnceDemoViewController.h"
#import "NBLPhotoManager.h"

@interface NBLOnceDemoViewController ()

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UITextView *infoTextView;

@end


@implementation NBLOnceDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"dispatch_once";
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
        [startButton setTitle:@"开始创建" forState:UIControlStateNormal];
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
        infoTextView.text = @"对象信息：\n\n";
        _infoTextView = infoTextView;
    }
    
    return _infoTextView;
}

#pragma mark - Action

- (void)start
{
    for (NSInteger i = 0; i < 5; i++) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NBLPhotoManager *photoManager = [NBLPhotoManager sharedManager];
            NSString *tmpStr = [NSString stringWithFormat:@"%@\n\n", photoManager];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf fillTextInfo:tmpStr];
            });
        });
    }
}


#pragma mark - Private

- (void)fillTextInfo:(NSString *)info
{
    NSMutableString *tmpStr = [NSMutableString stringWithString:self.infoTextView.text];
    [tmpStr appendString:info];
    self.infoTextView.text = tmpStr;
}

@end
