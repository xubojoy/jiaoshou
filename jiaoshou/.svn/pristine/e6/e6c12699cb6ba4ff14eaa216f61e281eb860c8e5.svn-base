//
//  SetViewController.m
//  TeachThin
//
//  Created by 巩鑫 on 14/11/13.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import "SetViewController.h"
#import "SexViewController.h"
#import "EatingViewController.h"
#import "EatingHabitsViewController.h"
#import "CaseViewController.h"
#import "ActStrengthViewController.h"
#import "SpecialCrowdViewController.h"



@interface SetViewController ()

@end

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"修改资料";
        
        UIBarButtonItem * right  = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
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
    _sexChange = NO;
  

    self.navigationController.navigationBarHidden = NO;
    
    
    
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(havetel:) name:@"havetel" object:nil];
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actStrength:) name:@"actStrength" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sexchange:) name:@"sexchange" object:nil];    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(eating:) name:@"eating" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(case1:) name:@"case" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allergy:) name:@"allergy" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(special:) name:@"special" object:nil];
    
    
}
//-(void)havetel:(NSNotification*)notification
//{
//    _tel = [notification object];
//    NSLog(@"%@",_tel);
//}
-(void)actStrength:(NSNotification*)notification
{
    
    id obj = [notification object];
    NSLog(@"劳动强度的数据数组是%@",obj);
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:obj, nil];
    NSMutableArray * arr1 = [arr objectAtIndex:0];
    _actstrength = [arr1 componentsJoinedByString:@","];
   NSLog(@"&&&&&&&&&&&&&&%@",_actstrength);
   [table reloadData];
    
}
-(void)sexchange:(NSNotification*)notification
{
    id obj = [notification object];
    _userSex = [NSString stringWithFormat:@"%@",obj];
    NSLog(@"**************%@",_userSex);
  
    [table reloadData];
    
}


-(void)eating:(NSNotification*)notification
{
    id obj = [notification object];
    NSLog(@"饮食偏好的数据数组是%@",obj);
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:obj, nil];
    NSMutableArray * arr1 = [arr objectAtIndex:0];
    _eating= [arr1 componentsJoinedByString:@","];
    NSLog(@"&&&&&&&&&&&&&&%@",_eating);
    [table reloadData];
    
    
    
}

-(void)case1:(NSNotification*)notification
{
    id obj = [notification object];
    NSLog(@"病史的数据数组是%@",obj);
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:obj, nil];
    NSMutableArray * arr1 = [arr objectAtIndex:0];
    _case1= [arr1 componentsJoinedByString:@","];
    NSLog(@"&&&&&&&&&&&&&&%@",_case1);
    [table reloadData];
    
    
    
    
}
-(void)allergy:(NSNotification*)notification
{
    
    id obj = [notification object];
    NSLog(@"过敏源的数据数组是%@",obj);
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:obj, nil];
    NSMutableArray * arr1 = [arr objectAtIndex:0];
    _allergy= [arr1 componentsJoinedByString:@","];
    NSLog(@"&&&&&&&&&&&&&&%@",_allergy);
    [table reloadData];
    
}

-(void)special:(NSNotification*)notification
{
    
    id obj = [notification object];
    NSLog(@"特殊人群的数据数组是%@",obj);
    NSMutableArray * arr = [NSMutableArray arrayWithObjects:obj, nil];
    NSMutableArray * arr1 = [arr objectAtIndex:0];
    _special= [arr1 componentsJoinedByString:@","];
    NSLog(@"&&&&&&&&&&&&&&%@",_special);
    [table reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _Arr = [[NSArray alloc]initWithObjects:@"汉族",@"壮族",@"满族",@"回族",@"苗族",@"维吾尔族",@"土家族",@"彝族",@"蒙古族",@"藏族",@"布依族",@"朝鲜族",@"瑶族", nil];
    _Arr1 = [[NSArray alloc]initWithObjects:@"小学",@"初中",@"高中",@"大专",@"本科",@"研究生",@"硕士",@"博士", nil];
    
    [self loadData];
    

}
-(void)loadData
{
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    NSString * uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    NSString * url = URL_GetInfo;
    NSLog(@"%@_________%@",url,postDict);
    
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:postDict ImageData:nil];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSString * code = [obj valueForKey:@"code"];
        NSLog(@"%@",obj);
        if ([code isEqualToString:@"01"]) {
            _UserDict = [obj valueForKey:@"result"];
            NSLog(@"++++++++++++%@",_UserDict);
            
            _userSex = [_UserDict valueForKey:@"sex"];            [table reloadData];
            _clan = [_UserDict valueForKey:@"nation"];
            _EnucationLevel = [_UserDict valueForKey:@"culture"];
            _actstrength = [_UserDict valueForKey:@"work"];
            _eating = [_UserDict valueForKey:@"diet"];
            _case1 = [_UserDict valueForKey:@"medical"];
            _allergy = [_UserDict valueForKey:@"allergen"];
            _special = [_UserDict valueForKey:@"special"];
            _sid = [_UserDict valueForKey:@"id_s"];
            _gWeight = [_UserDict valueForKey:@"goal_weight"];
            _imgurl = [_UserDict valueForKey:@"picurl"];
            [self setlayout];
            
            
        }else if ([code isEqualToString:@"00"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无数据" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
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

-(void)setlayout
{
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_VIEW(self.view), HEIGHT_VIEW(self.view)) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}
#pragma table delegate;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 10;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 12;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section==3) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell * cell;

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _celltitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 80, 36)];
        _celltitle.textAlignment = NSTextAlignmentCenter;
        _celltitle.font = [UIFont systemFontOfSize:15.0];
        _celltitle.textColor = [UIColor blackColor];
        [cell.contentView addSubview:_celltitle];
        
        _cellcontent = [[UILabel alloc]initWithFrame:CGRectMake(100, 14, 140, 24)];
        [cell.contentView addSubview: _cellcontent];
        
        
    }
    UIToolbar * topview = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topview setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topview setItems:buttonsArray];
    
    
    switch (indexPath.section) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            _celltitle.text = @"头像";
            
            _imgv = [[UIImageView alloc]initWithFrame:CGRectMake(250, 2, 40, 40)];
            _imgv.layer.cornerRadius = 20;
            _imgv.layer.masksToBounds = YES;
            if (![_imgurl isEqualToString:@""]) {
                NSURL * url = [NSURL URLWithString:_imgurl];
                NSData * imgdata = [NSData dataWithContentsOfURL:url];
                _imgv.image = [UIImage imageWithData:imgdata];
            }
          
            [cell.contentView addSubview:_imgv];
            
            [_cellcontent removeFromSuperview];
            
        }
            break;
            case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            _celltitle.text = @"手机号";
            
//            tf1 = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 140, 24)];
//
//            tf1.clearButtonMode = UITextFieldViewModeWhileEditing;
//            tf1.autocorrectionType = UITextAutocorrectionTypeNo;
//            tf1.keyboardType = UIKeyboardTypeNumberPad;
//            tf1.returnKeyType = UIReturnKeyDefault;
//            tf1.delegate = self;
//            tf1.autocapitalizationType = UITextAutocapitalizationTypeNone;
//            tf1.inputAccessoryView = topview;
//            tf1.text = _tel;
//            [cell.contentView addSubview:tf1];
            _cellcontent.text = [ManageVC sharedManage].name;
            
            
            
        }
            break;
            case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            _celltitle.text = @"昵称";
            
            tf2 = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 140, 24)];
            tf2.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf2.autocorrectionType = UITextAutocorrectionTypeNo;
            tf2.keyboardType = UIKeyboardAppearanceDefault;
            tf2.returnKeyType = UIReturnKeyDefault;
            tf2.delegate = self;
            tf2.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf2.inputAccessoryView = topview;
            tf2.placeholder = [_UserDict valueForKey:@"truename"];
            tf2.text = _realnamel;
             [cell.contentView addSubview:tf2];
            
            
            
        }
            break;
            case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    _celltitle.text = @"生日";
                    
                    if (!_Birthday) {
                        
                    }else
                    {
                        _cellcontent.text = [_UserDict valueForKey:@"birth"];
                    }
                  
                }
                    break;
                    case 1:
                {
                    
                
                    _celltitle.text = @"性别";
                    NSString * sex1 = _userSex;
                    NSLog(@"++++++%@",_userSex);
                        if ([sex1 isEqualToString:@"1"]) {
                            _cellcontent.text = @"男";
                        }else if ([sex1 isEqualToString:@"0"])
                        {
                            _cellcontent.text = @"女";
                        }else {
                            _cellcontent.text =_userSex;
                        }
                   
                    
                   
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
            case 4:
        {
            _celltitle.text = @"民族";
            _cellcontent.text = _clan;
        }
            break;
        case 5:
        {
            _celltitle.text = @"文化程度";
            _cellcontent.text = _EnucationLevel;
        }
            break;
            case 6:
        {
            _celltitle.text = @"劳动强度";
            _cellcontent.text = _actstrength;
        }
            break;
        case 7:
        {
            _celltitle.text = @"饮食嗜好";
            _cellcontent.text = _eating;
    
        }
            break;
        case 8:
        {
             _celltitle.text = @"慢性病";
            _cellcontent.text = _case1;
        }
            break;
        case 9:
        {
              _celltitle.text = @"过敏源";
            _cellcontent.text = _allergy;
        
        }
            break;
        case 10:
        {
             _celltitle.text = @"特殊人群";
            _cellcontent.text = _special;
        }
            break;
        case 11:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
             _celltitle.text = @"目标体重";
            _cellcontent.text = [_UserDict valueForKey:@"goal_weight"];
        }
            break;
        default:
            break;
    }
    _cellcontent.textAlignment = NSTextAlignmentCenter;
    _cellcontent.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
    _cellcontent.backgroundColor = [UIColor clearColor];
    _cellcontent.textColor = [UIColor blackColor];
    _cellcontent.lineBreakMode = NSLineBreakByCharWrapping;
    _cellcontent.numberOfLines = 0 ;
    _cellcontent.tag = 1000;
    [_cellcontent sizeToFit];
    
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    switch (indexPath.section) {
        case 0:
        {
            as =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
            as.actionSheetStyle = UIActionSheetStyleBlackOpaque ;
            as.tag = 100;
            [as showInView:self.view];
            
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
               case 0:
                {
                    self.cdp = [[CustomActionSheet alloc]initWithHeight:250 WithSheetTitle:@"请选择日期"];
                    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
                    
                    rightButton.tintColor = RGBACOLOR(0, 94, 196, 1);
                    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(docancel)];
                    leftButton.tintColor = RGBACOLOR(0, 94, 196, 1);
                    
                    
                    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    
                    
                    NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,rightButton,nil];
                    
                    [self.cdp.toolbar setItems: array];
                    
                    
                    
                    self.dp = [[UIDatePicker alloc]init];
                    self.dp.datePickerMode =  UIDatePickerModeDate;
                    self.dp.bounds = CGRectMake(0, 0, WIDTH_VIEW(self.view), 100);
                    
                    [self.dp addTarget:self action:@selector(datechange) forControlEvents:UIControlEventValueChanged];
                    [self.cdp addSubview:self.dp];
                  
                    [self.cdp showInView:self.view];
                    
                }
                    break;
                    
                
                case 1:
                {
                    SexViewController * sexvc = [[SexViewController alloc]init];
                    sexvc.pushFlag = 2;
                    [self.navigationController pushViewController:sexvc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
         case 4:
        {
            self.cas = [[CustomActionSheet alloc]initWithHeight:250 WithSheetTitle:@"请选择日期"];
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done1)];
            
            rightButton.tintColor = RGBACOLOR(0, 94, 196, 1);
            UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(docancel1)];
            leftButton.tintColor = RGBACOLOR(0, 94, 196, 1);
            
            
            UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            
            NSArray *array = [[NSArray alloc] initWithObjects:leftButton,fixedButton,rightButton,nil];
            
            [self.cas.toolbar setItems: array];
            
            //picker view;
            self.pv = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 320, 100)];
            self.pv.delegate = self;
            self.pv.dataSource = self;
            self.pv.showsSelectionIndicator = YES;
            self.pv.tag = 1000;
            [self.pv selectRow:2 inComponent:0 animated:YES];
            [self.cas addSubview:self.pv];
             [self.cas showInView:self.view];
        }
            break;
            case 5:
        {
            self.cas = [[CustomActionSheet alloc]initWithHeight:250 WithSheetTitle:@"请选择日期"];
            UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done2)];
            
            rightButton2.tintColor = RGBACOLOR(0, 94, 196, 1);
            UIBarButtonItem *leftButton2  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(docancel2)];
            leftButton2.tintColor = RGBACOLOR(0, 94, 196, 1);
            
            
            UIBarButtonItem *fixedButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            
            NSArray *array2 = [[NSArray alloc] initWithObjects:leftButton2,fixedButton2,rightButton2,nil];
            
            [self.cas.toolbar setItems: array2];
            
            //picker view;
            self.pv = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 320, 100)];
            self.pv.delegate = self;
            self.pv.dataSource = self;
            self.pv.showsSelectionIndicator = YES;
            self.pv.tag = 1001;
            [self.pv selectRow:2 inComponent:0 animated:YES];
            [self.cas addSubview:self.pv];
            //[self.cas showFromRect:CGRectMake(0, HEIGHT_VIEW(self.view)-49, WIDTH_VIEW(self.view), 49) inView:self.view animated:YES];
            [self.cas showInView:self.view];
            
            
        }
            break;
            case 6:
        {
            ActStrengthViewController * asvc = [[ActStrengthViewController alloc]init];
            [self.navigationController pushViewController:asvc animated:YES];
        }
            break;
            case 7:
        {
            EatingViewController * eatingVC =[[EatingViewController alloc]init];
            [self.navigationController pushViewController:eatingVC animated:YES];
            
            
        }
            break;
            case 8:
        {
            CaseViewController * caseVC = [[CaseViewController alloc]init];
            [self.navigationController pushViewController:caseVC animated:YES];
            
            
        }
            break;
            case 9:
        {
            EatingHabitsViewController * ehvc = [[EatingHabitsViewController alloc]init];
            [self.navigationController pushViewController:ehvc animated:YES];
        }
            break;
            case 10:
        {
            SpecialCrowdViewController * scvc = [[SpecialCrowdViewController alloc]init];
            [self.navigationController pushViewController:scvc animated:YES];
            
            
        }
            break;
 
        default:
            break;
    }
    
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
    [_imgv setImage:image] ;
    self.upload_image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_imgv setImage:image];
    self.upload_image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



//去掉输入的前后空格
-(NSString *)removespace:(UITextField *)textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(void) dismissKeyBoard
{
    
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _realnamel = tf2.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.view.frame=CGRectMake(0,0,VIEW_WEIGHT, VIEW_HEIGHT);
    [UIView commitAnimations];
    
    return YES;
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==tf2)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, -130, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}

#pragma 自定义得datepicker
-(void)done

{
    if(self.cdp.OKBtnbloack){
        self.cdp.OKBtnbloack();
    }
  
    [table reloadData];
    [self.cdp dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)docancel

{
    [self.cdp dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)datechange
{
    NSDate *selectedDate = [self.dp date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [formatter stringFromDate:selectedDate];
 
    NSLog(@"%@",dateString);
    _Birthday = [NSString stringWithFormat:@"%@",dateString];
    
    
}
#pragma 自定义得datepicker
-(void)done1

{
    if(self.cas.OKBtnbloack){
        self.cas.OKBtnbloack();
    }
    if (!_clan) {
        _clan = @"满族";
    }

    [table reloadData];
    [self.cas dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)docancel1

{
    [self.cas dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma 自定义得datepicker
-(void)done2

{
    if(self.cas.OKBtnbloack){
        self.cas.OKBtnbloack();
    }
    if (!_EnucationLevel) {
        _EnucationLevel = @"高中";
    }
    
    
    [table reloadData];
    [self.cas dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)docancel2

{
    [self.cas dismissWithClickedButtonIndex:0 animated:YES];
}



#pragma mark Picker Datasource Protocol

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.pv.tag == 1000) {
        return [_Arr count];
    }else
        return [_Arr1 count];
    
}

#pragma mark -
#pragma mark Picker Delegate Protocol

//设置当前行的内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * pickerlabel = (UILabel*)view;
    if (!pickerlabel) {
        pickerlabel = [[UILabel alloc]init];
        pickerlabel.adjustsFontSizeToFitWidth = YES;
        [pickerlabel setTextAlignment:NSTextAlignmentCenter];
        [pickerlabel setBackgroundColor:[UIColor clearColor]];
        [pickerlabel setFont:[UIFont boldSystemFontOfSize:16]];
        pickerlabel.textColor = [UIColor blackColor];
        
    }
    
    pickerlabel.text = [self pickerView:self.pv titleForRow:row forComponent:0];
    
    
    
    return pickerlabel;
    
    
    
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(self.pv.tag==1000){
        
        return [_Arr objectAtIndex:row];
    }else if(self.pv.tag==1001)
    {
        return [_Arr1 objectAtIndex:row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if (self.pv.tag==1000) {
        _clan = [_Arr objectAtIndex:row];
        NSLog(@"^^^^^^^^^^^^^%@",_clan);
        [table reloadData];
    }else if(self.pv.tag==1001)
    {
        _EnucationLevel = [_Arr1 objectAtIndex:row];
        NSLog(@"**************%@",_EnucationLevel);
        [table reloadData];
    }
    
}


-(void)rightClick:(id)sender
{
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
   // NSString * uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString * uid = [_UserDict valueForKey:@"uid"];
    NSData *imageData = UIImageJPEGRepresentation(_upload_image, 1.0);
    NSString * sid  = _sid;
    NSString * realname = _realnamel;
    NSString * birthday = _Birthday;
    NSString * sex = _userSex;
    NSString * nation = _clan;
    NSString * elevel = _EnucationLevel;
    NSString * act = _actstrength;
    NSString * eat = _eating;
    NSString * case1 = _case1;
    NSString *  allergy = _allergy;
    NSString * speical = _special;

    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",realname,@"realname",birthday,@"birthday",sex,@"sex",nation,@"nation",elevel,@"culture",act,@"work", eat,@"diet",case1,@"chronic",allergy,@"allergen",speical,@"special",sid,@"id_s", nil];
    
    NSString * url = URL_Update;
    NSLog(@"*****%@",url);
    NSLog(@"*****%@",postDict);
    
//13445646444464
    JSHttpRequest * request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:url pragma:postDict ImageData:imageData];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSLog(@"^^^^^%@",obj);
        NSString * result = [obj valueForKey:@"code"];
        if ([result isEqualToString:@"01"]) {
            NSLog(@"提交成功");
            NSDictionary * userInfo = [NSDictionary dictionaryWithDictionary:postDict];
            [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
         
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的资料修改成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            alert.tag = 1000;
            [alert show];
            
        }else
        {
            NSLog(@"提交失败");
            [MBHUDView dismissCurrentHUD];
        }
    };
    request.failureGetData = ^{
        NSLog(@"网络获取失败");
    };
    
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
