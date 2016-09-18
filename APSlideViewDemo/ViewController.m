//
//  ViewController.m
//  APSlideViewDemo
//
//  Created by chengenluo on 16/9/6.
//  Copyright © 2016年 chengenluo. All rights reserved.
//

#import "ViewController.h"
#import "APSlideView.h"
#import "InnerViewController.h"

@interface ViewController ()
@property (nonatomic, strong) APSlideView *slideView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.slideView = [[APSlideView alloc] initWithFrame:CGRectMake(rect.size.width, 0, 0, 0)];
    self.slideView.dragEnable = YES; //optional
    InnerViewController *innerVC = [[InnerViewController alloc] initWithNibName:@"InnerViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:innerVC];
    self.slideView.viewController = nav;
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect rect = self.slideView.frame;
    rect.size = CGSizeMake(400, self.view.frame.size.height);
    self.slideView.frame = rect;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//右
- (IBAction)popMenuBtnDidClick:(UIButton *)sender
{
    self.slideView.slideDirection = APSlideViewSlideDirectionRight;
    [self slideIn];
}

//左
- (IBAction)leftDidClick:(UIButton *)sender {
    self.slideView.slideDirection = APSlideViewSlideDirectionLeft;
    [self slideIn];
}

//上
- (IBAction)topDidClick:(UIButton *)sender {
    self.slideView.slideDirection = APSlideViewSlideDirectionTop;
    [self slideIn];
}

//下
- (IBAction)bottomDidClick:(UIButton *)sender {
    self.slideView.slideDirection = APSlideViewSlideDirectionBottom;
    [self slideIn];
}

//滑出被点击
- (IBAction)slideOutDidClick:(UIButton *)sender {
    [self slideOut];
}

- (void)slideIn
{
    [self.slideView slideInView:self.view animated:YES complete:^{
        //do something
    }];
}

- (void)slideOut
{
    [self.slideView slideOutWithAnimated:YES complete:^{
        //do something
    }];
}

@end
