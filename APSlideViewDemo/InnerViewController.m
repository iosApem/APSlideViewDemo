//
//  InnerViewController.m
//  APSlideViewDemo
//
//  Created by chengenluo on 16/9/6.
//  Copyright © 2016年 chengenluo. All rights reserved.
//

#import "InnerViewController.h"

@interface InnerViewController ()

@end

@implementation InnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"子页面";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipBtnDidClick:(UIButton *)sender {
    
    InnerViewController *innerVC = [[InnerViewController alloc] initWithNibName:@"InnerViewController" bundle:nil];
    [self.navigationController pushViewController:innerVC animated:YES];
    
}



@end
