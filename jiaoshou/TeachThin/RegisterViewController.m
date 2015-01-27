//
//  RegisterViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-13.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfoViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"用户注册";
        right = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextClick:)];
        self.navigationItem.rightBarButtonItem = right;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arow"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
        self.navigationItem.leftBarButtonItem = backItem;
        
        
    }
    return self;
}
-(void)backBtnPress
{
    
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _summit = NO;
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setlayout];
}
-(void)setlayout
{
    //工具栏
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    

    //工具栏
    UIToolbar * topView1 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard1)];
    NSArray * buttonsArray1 = [NSArray arrayWithObjects:btnSpace1, doneButton1, nil];
    [topView1 setItems:buttonsArray1];
    
    
    for (int i=0; i<2; i++) {
        line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_oringeY+19+60*i, WIDTH_VIEW(self.view), 1)];
        line1.backgroundColor = RGBACOLOR(224, 224, 224, 1);
        [self.view addSubview:line1];
        
        line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, VIEW_oringeY+64+60*i, WIDTH_VIEW(self.view), 1)];
        line2.backgroundColor = RGBACOLOR(224, 224, 224, 1);
        [self.view addSubview:line2];
    }
    
    //输入框
    tf1 = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH_VIEW(self.view)*7/32,VIEW_oringeY+30, WIDTH_VIEW(self.view)*1/2, 24)];
    tf1.placeholder = @"请输入你的手机号";
    tf1.autocorrectionType = UITextAutocorrectionTypeNo;
    tf1.keyboardType = UIKeyboardTypeNumberPad;
    tf1.returnKeyType = UIReturnKeyDefault;
    tf1.delegate = self;
    tf1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [tf1 setInputAccessoryView:topView];
    [self.view addSubview:tf1];
    
    tf2 = [[UITextField alloc]initWithFrame:CGRectMake(WIDTH_VIEW(self.view)*7/32,VIEW_oringeY+90, WIDTH_VIEW(self.view)/2, 24)];
    tf2.placeholder = @"请输入验证码";
    tf2.autocorrectionType = UITextAutocorrectionTypeNo;
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf2.returnKeyType = UIReturnKeyDefault;
    tf2.delegate = self;
    tf2.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [tf2 setInputAccessoryView:topView1];
    [self.view addSubview:tf2];
    
    imgv = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_MAXX(tf1)+20, VIEW_oringeY+93, 18, 18)];
    imgv.backgroundColor = GXRandomColor;
    imgv.hidden =YES;
    [self.view addSubview:imgv];
    

    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(WIDTH_VIEW(self.view)*3/4, VIEW_oringeY+22, WIDTH_VIEW(self.view)/4, 40);
    sendBtn.backgroundColor = RGBACOLOR(88, 155, 34, 1);
    [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    

    
    
    line3 = [[UILabel alloc]initWithFrame:CGRectMake(30, HEIGHT_VIEW(self.view)-35, WIDTH_VIEW(self.view)-60, 1)];
    line3.backgroundColor = RGBACOLOR(224, 224,224, 1);
    [self.view addSubview:line3];
    
}

//- (BOOL)checkTel:(NSString *)str
//
//{
//    
//    if ([str length] == 0) {
//        return NO;
//    }
//    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    BOOL isMatch = [pred evaluateWithObject:str];
//    
//    if (!isMatch) {
//        
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        return NO;
//    }
//    return YES;
//}


-(void)sendBtnClick:(id)sender
{
    NSLog(@"send");
    
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    if(tf1.text.length==11){
        UIAlertView * alert1 = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:tf1.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert1.tag = 1000;
        [alert1 show];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
#pragma AlertView 代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1000:
        {
            if (1==buttonIndex)
            {
                NSLog(@"点击了确定按钮");
                
                sendBtn.enabled = NO;
                //倒计时按钮
                timebtn = [UIButton buttonWithType:UIButtonTypeCustom];
                timebtn.frame = CGRectMake(100,VIEW_MAXY(line3)-10, 120, 20);
                [timebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               //[timebtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [timebtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                timebtn.backgroundColor = RGBACOLOR(88, 155, 34, 1);
                timebtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:10.0];
                timebtn.hidden = NO;
                [self.view addSubview:timebtn];
                [self startTime];
                
            

                
                NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:tf1.text,@"mobile",nil];
                
                NSString * url = URL_Send;
                NSLog(@"*****%@",url);
                NSLog(@"*****%@",postDict);
                
              
                
                
                JSHttpRequest * request = [[JSHttpRequest alloc]init];
                [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
                request.successGetData = ^(id obj){
                    //如果获取到数据网络页面消失
                    [self removeNonetView];
                    //加载框消失
                    [MBHUDView dismissCurrentHUD];
                    NSString * result = [obj valueForKey:@"code"];
                    NSString * reason = [obj valueForKey:@"Errmsg"];
                    if ([result isEqualToString:@"01"]) {
                        NSLog(@"发送验证码成功");
                    }else if([result isEqualToString:@"00"])
                    {
                        NSLog(@"验证码发送失败");
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:reason delegate:self cancelButtonTitle:@"知道了"otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    
                    
                    
                    
                };
            }
            if (0==buttonIndex) {
                NSLog(@"点击了取消按钮");
            }
        }
            break;
            break;
        default:
            break;
    }
                
                
                
                
                
//                NSString * str2 = [NSString stringWithFormat:@"%d",86];
//                NSLog(@"%@",tf1.text);
//                [SMS_SDK getVerifyCodeByPhoneNumber:tf1.text AndZone:str2 result:^(enum SMS_GetVerifyCodeResponseState state) {
//                    if (1==state) {
//                        NSLog(@"block 获取验证码成功");
//                        
//                        
//                    }
//                    else if(0==state)
//                    {
//                        NSLog(@"block 获取验证码失败");
//                        NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
//                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    }
//                    else if (SMS_ResponseStateMaxVerifyCode==state)
//                    {
//                        NSString* str = [NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
//                        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    }
//                    else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
//                    {
//                        NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
//                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
//                    }
//                    
//                }];
        
//        case 1001:
//        { if (1==buttonIndex)
//        {
//            NSLog(@"点击了确定按钮");
//            
//            NSString * str2 = [NSString stringWithFormat:@"%d",86];
//            [SMS_SDK getVerifyCodeByPhoneNumber:tf1.text AndZone:str2 result:^(enum SMS_GetVerifyCodeResponseState state) {
//                if (1==state) {
//                    NSLog(@"block 获取验证码成功");
//                }
//                else if(0==state)
//                {
//                    NSLog(@"block 获取验证码失败");
//                    NSString* str=[NSString stringWithFormat:@"验证码发送失败 请稍后重试"];
//                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//                else if (SMS_ResponseStateMaxVerifyCode==state)
//                {
//                    NSString* str = [NSString stringWithFormat:@"请求验证码超上限 请稍后重试"];
//                    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//                else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
//                {
//                    NSString* str=[NSString stringWithFormat:@"客户端请求发送短信验证过于频繁"];
//                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//                
//            }];
//        }
//            if (0==buttonIndex) {
//                NSLog(@"点击了取消按钮");
//            }
//        }
    
}
-(void)showNoNetView;
{
    [NonetView shareNetView].delegate = self;
    [self.view addSubview:[NonetView shareNetView]];
    
}
-(void)removeNonetView;
{
    [[NonetView shareNetView] removeFromSuperview];
}

-(void)NetViewReloadData
{
    NSLog(@"________reload____________");
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    
}
#pragma 开启时间线程
-(void)startTime{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [timebtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                timebtn.titleLabel.font =[UIFont fontWithName:@"Arial-BoldMT" size:10.0];
                timebtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            if ([strTime isEqualToString:@"01"]) {
                sendBtn.enabled =YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [timebtn setTitle:[NSString stringWithFormat:@"%@秒后重新获取验证码",strTime] forState:UIControlStateNormal];
                timebtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:10.0];
                timebtn.userInteractionEnabled = NO;
                NSString *  str = [NSString stringWithFormat:@"%@秒后重新发送验证码",strTime];
                NSMutableAttributedString * astr = [[NSMutableAttributedString alloc]initWithString:str];
                [astr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,3)];
                timebtn.titleLabel.attributedText = astr;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}



//-(void)CannotGetSMS
//{
//    sendBtn.enabled = YES;
//    NSString * str=[NSString stringWithFormat:@"我们将重新发送验证码短信到这个号码:%@",tf1.text];
//    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 1001;
//    [alert show];
//}
-(void)submit
{
    //验证号码
    [self.view endEditing:YES];
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:tf1.text,@"mobile",tf2.text,@"code",nil];
    
    NSString * url = URL_checkCode;
    NSLog(@"*****%@",url);
    NSLog(@"*****%@",postDict);
    
    
    
    
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSString * result = [obj valueForKey:@"code"];
       // NSString * reason = [obj valueForKey:@"Errmsg"];
        if ([result isEqualToString:@"01"]) {
            NSLog(@"验证成功");
            imgv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lvgou"]];
            imgv.hidden = NO;
            _summit = YES;
            tf2.userInteractionEnabled = NO;
    
        }else if([result isEqualToString:@"00"])
        {
            NSLog(@"验证失败");
            imgv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hongcha"]];
            imgv.hidden = NO;
            
         
        }
        
        
        
        
        
    };
    
    
    
    
    
    
    
    
    
    
    
//    NSLog(@"去服务端进行验证中...");
//    [SMS_SDK commitVerifyCode:tf2.text result:^(enum SMS_ResponseState state) {
//        if (1==state) {
//            NSLog(@"block 验证成功");
//            imgv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lvgou"]];
//            imgv.hidden = NO;
//            _summit = YES;
//            tf2.userInteractionEnabled = NO;
//            //出现输入密码的视图；
//
//            
//        }
//        else if(0==state)
//        {
//            NSLog(@"block 验证失败");
//            
//            imgv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hongcha"]];
//            imgv.hidden = NO;
//            
//            NSString* str=[NSString stringWithFormat:@"验证码无效 请重新获取验证码"];
//            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"验证失败" message:str delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//            [alert show];
//            
//        }
//    }];
    
    
}
-(void)dismissKeyBoard
{
    
    [tf1 resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
    
    
}
-(void)dismissKeyBoard1
{
    
    [tf2 resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
    if ([tf2.text length]==6) {
        [self submit];
    }
    
}



//去掉输入的前后空格
-(NSString *)removespace:(UITextField *)textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];

   
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];

 
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
    
    return YES;
}




-(void)nextClick:(id)sender
{
   
    if (!_summit) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先验证手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        UserInfoViewController * uivc = [[UserInfoViewController alloc]init];
        uivc.userName = [NSString stringWithFormat:@"%@",tf1.text];
        [self.navigationController pushViewController:uivc animated:YES];
    }
  
    
//    UserInfoViewController * uivc = [[UserInfoViewController alloc]init];
//    uivc.userName = [NSString stringWithFormat:@"%@",tf1.text];
//    [self.navigationController pushViewController:uivc animated:YES];
    
    
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
