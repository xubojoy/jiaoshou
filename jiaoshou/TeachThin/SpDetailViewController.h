//
//  SpDetailViewController.h
//  TeachThin
//
//  Created by 王园园 on 14-11-20.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpDetailViewController : UIViewController<UIWebViewDelegate,NetViewDelegate>
{
    UIScrollView *scroll;
    UIButton *homeBtn;

    UIWebView *webview;
    UIActivityIndicatorView *indicator;
}

@property(nonatomic,retain)NSDictionary *Datadict;
@property(nonatomic,retain)NSString *type;  //1运动 0营养知识
@property(nonatomic,retain)NSString *imageurl;
@property(nonatomic,retain)NSString *newsid;
@property(nonatomic,retain)NSString *cotentStr;


@end
