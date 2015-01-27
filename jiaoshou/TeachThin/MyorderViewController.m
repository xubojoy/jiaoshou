//
//  MyorderViewController.m
//  TeachThin
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import "MyorderViewController.h"

@interface MyorderViewController ()

@end

@implementation MyorderViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
