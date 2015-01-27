//
//  OrderViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"订单详情";
        self.view.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    return self;
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setlayout];
}
-(void)setlayout
{
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 114, WIDTH_VIEW(self.view)-50, 50)];
    label1.text = @"您已经成功提交订单，我们的客服会在午餐前给您打电话，谢谢您的使用";
    label1.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont fontWithName:@"Helvetica" size:15.];
    label1.numberOfLines = 2;
    [self.view addSubview:label1];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, VIEW_MAXY(label1), WIDTH_VIEW(self.view)-80, 40)];
    label2.text = @"客服电话: 010-88888888";
    label2.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont fontWithName:@"Helvetica" size:15.];
    [self.view addSubview:label2];
    
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(VIEW_WEIGHT-70, VIEW_HEIGHT-60, 50, 50);
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn"] forState:UIControlStateNormal];
    [homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
}
-(void)HomeBtnPress{
    
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
