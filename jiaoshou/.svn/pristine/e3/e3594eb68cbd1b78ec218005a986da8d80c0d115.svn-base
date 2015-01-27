//
//  professorViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-12-15.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "professorViewController.h"
#import "ProfessorListViewController.h"
#import "ProfossorSearchViewController.h"




@interface professorViewController ()

@end

@implementation professorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"找专家";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
        self.navigationItem.leftBarButtonItem = backItem;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"SearchBtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(SearchBtnPress)];
    }
    return self;
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}
-(void)SearchBtnPress
{
    ProfossorSearchViewController *searchVC = [[ProfossorSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



@end
