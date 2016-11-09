//
//  ViewController.m
//  NBLGCDDemo
//
//  Created by snb on 16/11/8.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "ViewController.h"
#import "NBLAsyncDemoViewController.h"
#import "NBLAfterDemoViewController.h"
#import "NBLSyncDemoViewController.h"
#import "NBLOnceDemoViewController.h"
#import "NBLBarrierDemoViewController.h"
#import "NBLGroupDemoViewController.h"
#import "NBLApplyDemoViewController.m"
#import "NBLSignalDemoViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray     *titles;

@end


static NSString *tableViewCellIdentifier = @"tableViewCellIdentifier";

@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD常见函数使用示例";
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:tableViewCellIdentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    
    return _tableView;
}


- (NSArray *)titles
{
    if (!_titles) {
        NSArray *titles = [NSArray arrayWithObjects:@"dispatch_async", @"dispatch_after", @"dispatch_sync", @"dispatch_once", @"Dispatch barrier" , @"Dispatch group", @"dispatch_apply", @"信号量", nil];
        _titles = titles;
    }
    
    return _titles;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [[NBLAsyncDemoViewController alloc] init];
            break;
            
        case 1:
            vc = [[NBLAfterDemoViewController alloc] init];
            break;
            
        case 2:
            vc = [[NBLSyncDemoViewController alloc] init];
            break;
        
        case 3:
            vc = [[NBLOnceDemoViewController alloc] init];
            break;
            
        case 4:
            vc = [[NBLBarrierDemoViewController alloc] init];
            break;
            
        case 5:
            vc = [[NBLGroupDemoViewController alloc] init];
            break;
            
        case 6:
            vc = [[NBLApplyDemoViewController alloc] init];
            break;
            
        case 7:
            vc = [[NBLSignalDemoViewController alloc] init];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
