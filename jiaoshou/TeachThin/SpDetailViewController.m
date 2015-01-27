//
//  SpDetailViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "SpDetailViewController.h"

@interface SpDetailViewController ()

@end

@implementation SpDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"收藏"] style:UIBarButtonItemStyleBordered target:self action:@selector(LoveBtnPress)];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    return self;
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.bounces = NO;
    [self.view addSubview:scroll];
    
    webview = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    webview.backgroundColor = [UIColor clearColor];
    webview.opaque = NO;
    webview.dataDetectorTypes = UIDataDetectorTypeNone;
    [scroll addSubview:webview];
    
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT/2-20, VIEW_HEIGHT/2, 38, 38)];
    [self.view addSubview:indicator];
    indicator.center = self.view.center;
    [indicator startAnimating];
    
    
    homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(VIEW_WEIGHT-70, VIEW_HEIGHT-60, 50, 50);
    [homeBtn setImage:[UIImage imageNamed:@"homeBtn"] forState:UIControlStateNormal];
    homeBtn.layer.cornerRadius = 5.;
    [homeBtn addTarget:self action:@selector(HomeBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];

}

-(void)HomeBtnPress{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self loadlinkData];
}


#pragma mark -
#pragma mark - Load
-(void)loadlinkData
{
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    NSString *urlstr = URL_SportDetail(_newsid);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkWithUrlstr:urlstr];
    request.successGetData = ^(id obj){
        //如果获取到数据网络页面消失
        [self removeNonetView];
        //加载框消失
        [MBHUDView dismissCurrentHUD];
        NSDictionary *dict = (NSDictionary *)obj;
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            //获取到分类列表的值
            _Datadict = [NSDictionary dictionaryWithDictionary:dict];
            _cotentStr = [dict valueForKey:@"html"];
            [self setWebData];
        }else{
            [self InfoAlert:@"暂无数据" ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [MBHUDView dismissCurrentHUD];
        [self showNoNetView];//显示没有网络页面
    };
}

-(void)InfoAlert:(NSString *)message ok:(NSString *)OK cacel:(NSString *)Cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:OK otherButtonTitles:Cancel, nil];
    [alert show];
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

    [self loadlinkData];
    [MBHUDView hudWithBody:@"加载中" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:100000.0 show:YES];
    
}


-(void)setWebData
{
    NSString *webviewText = @"<style>body{margin:0;background-color:transparent;font:34px/48px Custom-Font-Name}</style>";
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@",_cotentStr];
    [webview loadHTMLString:htmlString baseURL:nil]; //在 WebView 中显示本地的字符
    webview.scalesPageToFit = YES;
    webview.scrollView.bounces = NO;
    //_webView.userInteractionEnabled = NO;
    webview.delegate = self;
    [scroll addSubview:webview];
    NSString *height_str=  [webview stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
        int webViewHeight = [height_str intValue];
    webview.frame = CGRectMake(10,0, VIEW_WEIGHT-15,webViewHeight);
    [scroll setContentSize:CGSizeMake(VIEW_WEIGHT, VIEW_MAXY(webview))];
}

- (void )webViewDidStartLoad:(UIWebView  *)webView   //网页开始加载的时候调用
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    //[self showNetView];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
    CGRect frame = webview.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [scroll setContentSize:CGSizeMake(0, VIEW_MAXY(webview))];
}
//添加收藏
-(void)LoveBtnPress
{
    NSString *urlstr = URL_AddCollectionData;
    NSString *uid = [ManageVC sharedManage].uid;
    NSString *title = [NSString stringWithFormat:@"%@",[_Datadict valueForKey:@"title"]];
    NSString *info = [NSString stringWithFormat:@"%@",[_Datadict valueForKey:@"description"]];
    NSDictionary *prama = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",_newsid,@"artid",title,@"title",info,@"infor",_imageurl,@"picurl",_type,@"type",nil];
    NSLog(@"_____________________url%@----%@",urlstr,prama);
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:urlstr pragma:prama ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----+++++++%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            
            [self InfoAlert:@"成功收藏" ok:@"知道了" cacel:nil];
    
        }else{
            [self InfoAlert:[dict valueForKey:@"error"] ok:@"知道了" cacel:nil];
        }
    };
    request.failureGetData = ^(void){
        [self InfoAlert:@"请检查网络" ok:@"知道了" cacel:nil];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
