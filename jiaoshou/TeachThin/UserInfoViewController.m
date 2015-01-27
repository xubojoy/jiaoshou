//
//  UserInfoViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14-11-19.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SexViewController.h"
#import "QuestionnaireViewController.h"
#import "LoginViewController.h"
#import "EaseMobProcessor.h"
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"用户注册";
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
    
    NSLog(@"%@",_userName);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sexchange:) name:@"sexchange" object:nil];

}
-(void)sexchange:(NSNotification*)notification
{
    id obj = [notification object];
    _userSex = [NSString stringWithFormat:@"%@",obj];
    NSLog(@"**************%@",_userSex);
    [table reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    _arr = [NSArray arrayWithObjects:@"姓名",@"性别",@"生日",@"请输入密码",@"再次确认密码", nil];
    [self setlayout];
}
-(void)setlayout
{
 
    
    imgvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgvBtn.frame = CGRectMake(WIDTH_VIEW(self.view)/2-36, 15, 72, 72);
    imgvBtn.layer.cornerRadius = 36;
    imgvBtn.layer.masksToBounds = YES;
    [imgvBtn setBackgroundImage:[UIImage imageNamed:@"headimage"] forState:UIControlStateNormal];
    [imgvBtn addTarget:self action:@selector(imgvBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    
    
    header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), 100)];
    [header addSubview:imgvBtn];
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(20, 20, WIDTH_VIEW(self.view)-40, 40);
    sureBtn.layer.cornerRadius = 3;
    sureBtn.backgroundColor = [UIColor redColor];
    [sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), 100)];
    [footer addSubview:sureBtn];
    
    
    
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view)) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.tableHeaderView = header;
    table.tableFooterView = footer;
    [self.view addSubview:table];
}
#pragma table delegate;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 9;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _celltitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, WIDTH_VIEW(cell.contentView)*9/32, 36)];
        _celltitle.textAlignment = NSTextAlignmentLeft;
        _celltitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        _celltitle.textColor = [UIColor blackColor];
        [cell.contentView addSubview:_celltitle];
        
        _cellcontent = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(_celltitle)+10, 4,  WIDTH_VIEW(self.view)/2, 36)];
        _cellcontent.textAlignment = NSTextAlignmentLeft;
        _cellcontent.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        _cellcontent.textColor = [UIColor blackColor];
        [cell.contentView addSubview:_cellcontent];
        
        
        
    }
    //键盘上面的工具栏
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    
    
    
    switch (indexPath.section) {
        case 0:
        {
            tf1 = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_MAXX(_celltitle)+10, 4, WIDTH_VIEW(self.view)*5/8, 36)];
            tf1.placeholder = @"请输入";
            tf1.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf1.autocorrectionType = UITextAutocorrectionTypeNo;
            tf1.keyboardType = UIKeyboardAppearanceDefault;
            tf1.returnKeyType = UIReturnKeyDefault;
            tf1.delegate = self;
            tf1.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf1.inputAccessoryView = topView;
            tf1.text = _Name;
            [cell.contentView addSubview:tf1];
        }
            break;
            case 1:
        {
            if (_userSex!=nil) {
                _cellcontent.text = [NSString stringWithFormat:@"%@",_userSex];
            }
        }
            break;
            case 2:
        {
            if (_userBirthday!=nil) {
                _cellcontent.text = [NSString stringWithFormat:@"%@",_userBirthday];
            }
            
        }
            break;
            case 3:
        {
            tf2 = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_MAXX(_celltitle)+10, 4, WIDTH_VIEW(self.view)*5/8, 36)];
            tf2.placeholder = @"请输入";
            tf2.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf2.autocorrectionType = UITextAutocorrectionTypeNo;
            tf2.keyboardType = UIKeyboardAppearanceDefault;
            tf2.returnKeyType = UIReturnKeyDefault;
            tf2.delegate = self;
            tf2.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf2.inputAccessoryView = topView;
             tf2.secureTextEntry = YES;
            
            [cell.contentView addSubview:tf2];
        }
            break;
            case 4:
        {
            tf3 = [[UITextField alloc]initWithFrame:CGRectMake(VIEW_MAXX(_celltitle)+10, 4, WIDTH_VIEW(self.view)*5/8, 36)];
            tf3.placeholder = @"请输入";
            tf3.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf3.autocorrectionType = UITextAutocorrectionTypeNo;
            tf3.keyboardType = UIKeyboardAppearanceDefault;
            tf3.returnKeyType = UIReturnKeyDefault;
            tf3.delegate = self;
            tf3.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf3.inputAccessoryView = topView;
             tf3.secureTextEntry = YES;
            [cell.contentView addSubview:tf3];
        }
            break;
        default:
            break;
    }
    
    
    _celltitle.text = [_arr objectAtIndex:indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
           // [[NSUserDefaults standardUserDefaults]setObject:tf1.text forKey:@"name"];
            [ManageVC sharedManage].name = [NSString stringWithFormat:@"%@",tf1.text];
            
            SexViewController * sexVC = [[SexViewController alloc]init];
            sexVC.pushFlag = 1;
            [self.navigationController pushViewController:sexVC animated:YES];
        }
            break;
            case 2:
        {
            self.cdp = [[CustomActionSheet alloc] initWithView:nil AndHeight:240];
            //[self.cdp showInView:self.view];
            self.cdp.SureBtnPress = ^(){
                [self datechange];
            };
            
            self.dp = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, WIDTH_VIEW(self.view), 100)];
            self.dp.datePickerMode =  UIDatePickerModeDate;
            [self.dp setMaximumDate:[NSDate date]];
            [self.dp addTarget:self action:@selector(datechange) forControlEvents:UIControlEventValueChanged];
            [self.cdp.backGroundView addSubview:self.dp];
            
            [self.cdp showInView:self.view];
        }
            break;
        default:
            break;
    }
}






//去掉输入的前后空格
-(NSString *)removespace:(UITextField *)textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(void)dismissKeyBoard
{
   // [[NSUserDefaults standardUserDefaults]setObject:tf1.text forKey:@"name"];
    [ManageVC sharedManage].name = [NSString stringWithFormat:@"%@",tf1.text];
    
    
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==tf1) {
        _Name = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
    
    return YES;
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==tf2||textField==tf3)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, -200, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}



-(void)imgvBtnClick:(id)sender
{
    NSLog(@"photo change");
    as =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    as.actionSheetStyle = UIActionSheetStyleBlackOpaque ;
    as.tag = 100;
    [as showInView:self.view];
    
    
}
#pragma mark actionSheet methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imgpicker = [[UIImagePickerController alloc]init];
    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"点击了照相");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
                {
                    //无权限
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }else if(authStatus == AVAuthorizationStatusAuthorized){
                    UIImagePickerController *imgpicker = [[UIImagePickerController alloc]init];
                    imgpicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                    imgpicker.allowsEditing = YES;
                    imgpicker.delegate = self;
                    [self presentViewController:imgpicker animated:YES completion:nil];
                }
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本设备不支持相机模式" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
            break;
        case 1:{
            NSLog(@"相册");
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
            {
                //无权限
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在隐私中设置相册权限" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
                
            }else{
                imgpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imgpicker.allowsEditing = YES;
                imgpicker.delegate = self;
                
                [self presentViewController:imgpicker animated:YES completion:nil];
            }
        }
            break;
            
        case 2:
            NSLog(@"取消");
            [as setHidden:YES];
            break;
        default:
            break;
    }
}
#pragma mark imagePickerController methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0,3_0)
{
   NSLog(@"1");   
   
    self.upload_image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
 
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    NSLog(@"2");
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    imgvBtn.layer.cornerRadius = 36 ;
    [imgvBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.upload_image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
      [table reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma 自定义得datepicker

-(void)datechange
{
    NSDate *selectedDate = [self.dp date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
    _userBirthday = [NSString stringWithFormat:@"%@",dateString];
    NSLog(@"___________%@",_userBirthday);
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:2];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [table reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];

}


-(void)sureBtnClick:(id)sender
{
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    
    
    NSLog(@"sure");
    _Name = [NSString stringWithFormat:@"%@",tf1.text];
    NSString * sex;
    if ([_userSex isEqualToString:@"男"]) {
        sex = @"1";
    }else if([_userSex isEqualToString:@"女"])
    {
        sex = @"2";
    }

    _passWord = [NSString stringWithFormat:@"%@",tf2.text];
    _cpassWord = [NSString stringWithFormat:@"%@",tf3.text];
    NSData *imageData = UIImageJPEGRepresentation(_upload_image, 1.0);
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_userName,@"uname",_Name,@"realname",sex,@"sex",_passWord,@"pwd",_cpassWord,@"cpwd",_userBirthday,@"birthday", Macro_HospitalId,@"hid", nil];
    
    NSString * url = URL_Register;
    NSLog(@"*****%@",url);
    NSLog(@"*****%@",postDict);
    
    NSDictionary * userInfo = [NSDictionary dictionaryWithDictionary:postDict];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
    
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:postDict ImageData:imageData];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSLog(@"^^^^^%@",obj);
        NSString * result = [obj valueForKey:@"code"];
        NSString * uid = [obj valueForKey:@"uid"];
        NSString * reason = [obj valueForKey:@"errmsg"];
        if ([result isEqualToString:@"01"]) {
            NSLog(@"_______注册成功");
            
            [ManageVC sharedManage].uid = [NSString stringWithFormat:@"%@",uid];
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
            [ManageVC sharedManage].name = [NSString stringWithFormat:@"%@",self.userName];
            [[NSUserDefaults standardUserDefaults] setObject:_userName forKey:@"name"];
            [ManageVC sharedManage].pwd = [NSString stringWithFormat:@"%@",self.passWord];
            [[NSUserDefaults standardUserDefaults] setObject:_passWord forKey:@"pwd"];
//            [ManageVC sharedManage].userImg = ;
//            [[NSUserDefaults standardUserDefaults] setObject: forKey:@"userimg"];
//             [EaseMobProcessor registUser];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的帐号注册成功" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"调查问卷", nil];
            alert.tag = 1000;
            [alert show];
            
        }else if([result isEqualToString:@"00"])
        {
            NSLog(@"______注册失败");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
           
            [alert show];
        }
 
    };
    request.failureGetData = ^(void){
        [MBHUDView dismissCurrentHUD];
        [self showNoNetView];//显示没有网络页面
    };

    
    
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

#pragma alert dele
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1000) {
        switch (buttonIndex) {
            case 0:
            {
                LoginViewController * loginvc = [[LoginViewController alloc]init];
               
                [self.navigationController pushViewController:loginvc animated:YES];
            }
                break;
                case 1:
            {
                QuestionnaireViewController * qvc = [[QuestionnaireViewController alloc]init];
                [self.navigationController pushViewController:qvc animated:YES];
            }
                break;
            default:
                break;
        }
    }
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
