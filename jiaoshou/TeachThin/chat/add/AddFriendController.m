//
//  AddFriendController.m
//  TeachThin
//
//  Created by myStyle on 14-11-27.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "AddFriendController.h"
#import "FriendDetailController.h"
#import "ApplyFriendControllerViewController.h"
#import "ApplyEntity.h"

@interface AddFriendController ()<UITextFieldDelegate>
@property (strong, nonatomic) NSMutableArray *friendSource;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UILabel *noLabel;

@end

@implementation AddFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.friendSource = [NSMutableArray array];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.title = @"查找好友";
    self.view.backgroundColor = RGBACOLOR(236, 238, 239, 1);
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:searchButton]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back_arow"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [self initTelNoView];
    [self initNOLabel];
}

#pragma mark - getter
-(void)initNOLabel{
    self.noLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 40)];
    self.noLabel.text = @"输入手机号查找";
    [self.view addSubview:self.noLabel];
}

-(void)initTelNoView{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 90, 300, 40)];
    self.textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.cornerRadius = 3;
    
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.font = [UIFont systemFontOfSize:15.0];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"输入手机号";
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//#warning 此处为验证手机号是否有效
//-(BOOL) validateMobile:(NSString *)mobile
//{
//    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|18[0-9]|14[57])[0-9]{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}

#pragma mark - action

- (void)searchAction
{
    [self.textField resignFirstResponder];
    
    if (self.textField.text.length > 0 && self.textField.text.length==11) {
#warning 由用户体系的用户，需要添加方法在已有的用户体系中查询符合填写内容的用户
#warning 以下代码为测试代码，默认用户体系中有一个符合要求的同名用户
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if ([self.textField.text isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能添加自己为好友" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        //判断是否已发来申请
        NSArray *applyArray = [[ApplyFriendControllerViewController shareController] dataSource];
        if (applyArray && [applyArray count] > 0) {
            for (ApplyEntity *entity in applyArray) {
                ApplyStyle style = [entity.style intValue];
                BOOL isGroup = style == ApplyStyleFriend ? NO : YES;
                if (!isGroup && [entity.applicantUsername isEqualToString:_textField.text]) {
                    NSString *str = [NSString stringWithFormat:@"%@已经给你发来了申请", _textField.text];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
        }

        NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:self.textField.text,@"phone", nil];
        NSString *url = URL_searchFriend;
        JSHttpRequest *request = [[JSHttpRequest alloc] init];
        [request StartWorkPostWithurlstr:url pragma:postDic ImageData:nil];
        request.successGetData = ^(id obj){
            NSLog(@">>>>>>>>>request.successGetData>>>>>>>>>>%@",obj);
            [self.friendSource removeAllObjects];
            [self.friendSource addObject:obj];
            NSString * result = [obj valueForKey:@"code"];
            if ([result isEqualToString:@"01"]) {
                FriendDetailController *fdc = [[FriendDetailController alloc] init];
                fdc.telPhone = self.textField.text;
                fdc.dataSource = self.friendSource;
                NSLog(@">>>>>>>>>>>>>fdc.dataSource:%@",fdc.dataSource);
                [self.navigationController pushViewController:fdc animated:YES];
            }else if ([result isEqualToString:@"00"]){
                
            }
  
        };
    }else{
       
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"请输入有效的手机号"
                     customizationBlock:nil
                        completionBlock:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles: nil];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号" delegate:nil cancelButtonTitle:@"" otherButtonTitles:@"确定", nil];
//        [alert show];
    }
}

@end
