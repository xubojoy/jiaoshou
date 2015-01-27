//
//  CustomActionSheet.m
//  LZWCustomActionSheet
//
//  Created by hbh  on 14-9-26.
//  Copyright (c) 2014年 lizhiwei. All rights reserved.
//

#import "LZWCustomActionSheet.h"

#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION                        0.25f
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.8]


@implementation LZWCustomActionSheet

-(id)initWithView:(UIView *)view AndHeight:(float)height{
    self = [super init];
    if (self) {
        
        strYear = [[Datetime GetYear:[NSDate date]] intValue];
        strMonth = [[Datetime GetMonth:[NSDate date]] intValue];
        dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
        timePacker = YES;
        
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        //生成LZWActionSheetView
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 200), VIEW_WEIGHT, height)];
        self.backGroundView.backgroundColor = [UIColor whiteColor] ;
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 44)];
        toolBar.barStyle = UIBarStyleDefault;
        
        
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStyleDone target: self action: @selector(done)];
//        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(docancel)];
//        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
//        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,fixedButton,rightButton, nil];
//        [toolBar setItems: array];		

        
        //给LZWActionSheetView添加响应事件(如果不加响应事件则传过来的view不显示)
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
        [self.backGroundView addGestureRecognizer:tapGesture1];
        
        
        [self addSubview:self.backGroundView];
        [self.backGroundView addSubview:toolBar];
        [self setCalenView];
        
        //[self.backGroundView addSubview:view];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 5, 50, 40);
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:RGBACOLOR(0., 120., 254., 1) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(docancel) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:cancelBtn];
        
        UIButton *SureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        SureBtn.frame = CGRectMake(VIEW_WEIGHT-50, 5, 50, 40);
        SureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [SureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [SureBtn setTitleColor:RGBACOLOR(5., 120., 254., 1) forState:UIControlStateNormal];
        [SureBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:SureBtn];
        

        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-height, [UIScreen mainScreen].bounds.size.width, height)];
            
        } completion:^(BOOL finished) {
            
        }];


    }
    
    return self;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)showInView:(UIView *)view{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    
}

- (void)tappedBackGroundView
{
    //
}

-(void)done{
    
    //[self.doneDelegate done];
    if(_SureBtnPress){
        self.SureBtnPress(selectTime);
    }
    [self tappedCancel];
}

-(void)docancel
{
    [self tappedCancel];
}



-(void)setCalenView
{
    _CalenderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 400)];
    [self AddHandleSwipe];
    [self.backGroundView addSubview:_CalenderView];
    [_CalenderView addSubview:[self CreatTitleView]];
    NSMutableArray* weekarr = [[NSMutableArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    for (int i = 0; i < 7; i++) {
        UILabel* lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithString:weekarr[i]];
        lable.textColor = [UIColor blackColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.frame = CGRectMake(i*45.7, 40,45.7, 28);
        lable.adjustsFontSizeToFitWidth = YES;
        lable.font = [UIFont systemFontOfSize:12.0f];
        lable.textAlignment = NSTextAlignmentCenter;
        [_CalenderView addSubview:lable];
        
    }
    [self AddDaybuttenToCalendarWatch];
}

-(UIView*)CreatTitleView
{
    UIView * titleview = [[UIView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT/2-50, 0, 100, 40)];
    titleview.backgroundColor = [UIColor clearColor];
    [titleview addSubview:[self CalendarTitleLabel]];
    titleview.tag = 3000;
    return titleview;
}
//制作阳历lable
-(UILabel *)CalendarTitleLabel{
    
    calendarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 ,100, 40)];
    calendarTitleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    calendarTitleLabel.font = [UIFont boldSystemFontOfSize:18];  //设置文本字体与大小
    //titleLabel.textColor = [UIColor colorWithRed:(255.0/255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha:1];  //设置文本颜色
    calendarTitleLabel.textColor = [UIColor lightGrayColor];
    //    if ((strYear == [[Datetime GetYear] intValue])&&(strMonth ==[[Datetime GetMonth] intValue])){
    //        calendarTitleLabel.text = [Datetime getDateTime];
    //    }else {// }
    
    if (strMonth < 10) {
        calendarTitleLabel.text = [NSString stringWithFormat:@"%d年  %d月",strYear,strMonth];
    }else calendarTitleLabel.text = [NSString stringWithFormat:@"%d年%d月",strYear,strMonth];
    
    //设置标题
    
    //calendarTitleLabel.text = [Datetime getDateTime];  //设置标题
    calendarTitleLabel.hidden = NO;
    calendarTitleLabel.tag = 2001;
    calendarTitleLabel.adjustsFontSizeToFitWidth = YES;
    return calendarTitleLabel;
}
//在CalendarWatch中重新部署数据
-(void)reloadDateForCalendarWatch{
    dayArray = nil;
    dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
    
    NSLog(@"strMonth===%d",strMonth);
    
    [self reloadDaybuttenToCalendarWatch];
    [_CalenderView addSubview:[self CreatTitleView]];
}


-(void)reloadDaybuttenToCalendarWatch{
    for (int i = 0; i < 42; i++)
        [[_CalenderView viewWithTag:301+i] removeFromSuperview];
    [self AddDaybuttenToCalendarWatch];
    
}
-(void)AddDaybuttenToCalendarWatch{
    float calenderHeight = 35;
    for (int i = 0; i < 42; i++) {
        UIButton * butten = [[UIButton alloc]init];
        butten.frame = CGRectMake((i%7)*45.7, 68+(i/7)*calenderHeight, 45.7, 40);
        [butten setTag:i+301];
        [butten addTarget:self action:@selector(buttenTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        butten.showsTouchWhenHighlighted = YES;
        
        UILabel * linelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 45.7, 1)];
        linelabel.backgroundColor = RGBACOLOR(207., 207., 207., 1);
        [butten addSubview:linelabel];
        
        
        UILabel* lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithString:dayArray[i]];
        lable.textColor = RGBACOLOR(174., 174., 174., 1);
        lable.backgroundColor = [UIColor clearColor];
        lable.frame = CGRectMake(7.5, 5, 30, 30);
        lable.adjustsFontSizeToFitWidth = YES;
        lable.layer.cornerRadius = 15;
        lable.layer.masksToBounds = YES;
        [butten addSubview:lable];
        
        
        if (([[Datetime GetDay:[NSDate date]] intValue]== [dayArray[i] intValue])&&(strMonth == [[Datetime GetMonth:[NSDate date]] intValue])&&(strYear == [[Datetime GetYear:[NSDate date]] intValue])) {
            lable.backgroundColor = RGBACOLOR(91., 154., 53., 1);
            lable.textColor = [UIColor whiteColor];
            selectTime = [NSString stringWithFormat:@"%d-%d-%@",strYear,strMonth,dayArray[i]];
        }
        
        [_CalenderView addSubview:butten];
    }
}
-(void)buttenTouchUpInsideAction:(id)sender{
    NSInteger t = [sender tag]-301;
    dayArray = nil;
    dayArray = [Datetime GetDayArrayByYear:strYear andMonth:strMonth];
    
    NSLog(@"%d年%d月%@日",strYear,strMonth,dayArray[t]);
    selectTime = [NSString stringWithFormat:@"%d-%d-%@",strYear,strMonth,dayArray[t]];
    calendarTitleLabel.text = [NSString stringWithFormat:@"%d年%d月%@日",strYear,strMonth,dayArray[t]];
}

//添加左右滑动手势
-(void)AddHandleSwipe{
    //声明和初始化手势识别器
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipe:)];
    //对手势识别器进行属性设定
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //把手势识别器加到view中去
    [_CalenderView addGestureRecognizer:swipeLeft];
    [_CalenderView addGestureRecognizer:swipeRight];
}
//左滑事件
- (void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    strMonth = strMonth+1;
    if(strMonth == 13){
        strYear++;strMonth = 1;
    }
    [self reloadDateForCalendarWatch];
    
    [[_CalenderView viewWithTag:3000] removeFromSuperview];
    
    
    
}
//右滑事件
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    strMonth = strMonth-1;
    if(strMonth == 0){
        strYear--;
        strMonth = 12;
    }
    [self reloadDateForCalendarWatch];
    [[_CalenderView viewWithTag:3000] removeFromSuperview];
    
}


@end
