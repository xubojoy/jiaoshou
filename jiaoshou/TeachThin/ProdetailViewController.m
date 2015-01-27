//
//  ProdetailViewController.m
//  TeachThin
//
//  Created by 王园园 on 14-12-31.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#import "ProdetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+AFNetworking.h"

#define oringeHeight 70.


@interface ProdetailViewController ()
@property BOOL istapInfoCell;
@end

@implementation ProdetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"专家详情";
    // Do any additional setup after loading the view.
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    _istapInfoCell = NO;
    table = [[UITableView alloc]initWithFrame:CGRectMake(0,0, VIEW_WEIGHT, VIEW_HEIGHT) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.bounces = NO;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
    
    [self.view addSubview:[self setCommentView]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"________%@",_ProfessorDict);
    [table reloadData];
    if(!_InfoData){
        [self loadData];
    }
}
-(void)loadData
{
    NSString *urlstr = URL_ProfessorDetail;
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    NSString *expid = [_ProfessorDict valueForKey:@"userid"];
    NSString *uid = [ManageVC sharedManage].uid;
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:expid,@"expid",uid,@"uid",nil];
    NSLog(@"+++++%@,%@",urlstr,pragma);
    [request StartWorkPostWithurlstr:urlstr pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            _InfoData = [NSDictionary dictionaryWithDictionary:dict];
            _personDict = [_InfoData valueForKey:@"result"];
            _commentArr = [_InfoData valueForKey:@"consult"];
            [table reloadData];
            [commentView setCommentData:_commentArr WithexpId:[_ProfessorDict valueForKey:@"userid"]];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有科室数据" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
    request.failureGetData = ^(void){
    };
}



#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section==0){
        specailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(cell==nil){
            cell = [[specailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",[_ProfessorDict valueForKey:@"realname"]];
        NSString *cotent = [NSString stringWithFormat:@"职位 %@\n科室 %@",[_ProfessorDict valueForKey:@"job_title"],[_ProfessorDict valueForKey:@"depname"]];
        cell.cotentLabel.text = cotent;
        cell.cotentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.cotentLabel.numberOfLines = 0;
        [cell.cotentLabel sizeToFit];
        [cell.imgView setImageWithURL:[NSURL URLWithString:[_ProfessorDict valueForKey:@"picurl"]]];
   
        return cell;
    }else if (indexPath.section==1||indexPath.section==2){
        UITableViewCell *cell;
        UILabel *titleLabel;
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section==1){
            infolable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, VIEW_WEIGHT-40, 30)];
            infolable.font =  [UIFont systemFontOfSize:15.];
            infolable.textColor = RGBACOLOR(74., 74., 74., 1);
            [cell addSubview:infolable];
             NSString *str = [NSString stringWithFormat:@"%@\n个人简介",[_ProfessorDict valueForKey:@"realname"]];
            if(_personDict)
            {
                str = [NSString stringWithFormat:@"%@\n%@",[_ProfessorDict valueForKey:@"realname"],[_personDict valueForKey:@"infor"]];
            }
            infolable.text = str;
            infolable.numberOfLines = 3;
            if(_istapInfoCell){
                infolable.numberOfLines = 0;
            }
            infolable.lineBreakMode = NSLineBreakByWordWrapping;
            [infolable sizeToFit];
            cell.layer.masksToBounds = YES;
        }else{
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, VIEW_WEIGHT-40, 30)];
            titleLabel.font =  [UIFont systemFontOfSize:15.];
            titleLabel.textColor = RGBACOLOR(74., 74., 74., 1);
            [cell addSubview:titleLabel];
            NSString *Str = @"医护评价  ★ ★ ★ ★ ★";
            NSInteger star = [[_personDict valueForKey:@"stars"] integerValue];
            NSMutableAttributedString * str2 = [[NSMutableAttributedString alloc]initWithString: Str];
            [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,star*2)];
            [str2 addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(211., 211., 211., 1) range:NSMakeRange(5+star*2,Str.length-5-star*2)];
            titleLabel.attributedText = str2 ;
        }
        return cell;
    }else{
        UITableViewCell *cell;
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 65.;
    }else if (indexPath.section==1){
        float h;
        if(_istapInfoCell){
            h = (infolable.frame.size.height>70)?infolable.frame.size.height+20:70;
            if(commentView){
                commentView.frame = CGRectMake(0, 315+(h-70.), VIEW_WEIGHT, VIEW_HEIGHT-315-(h-70.));
            }
            return h;
        }else{
            if(commentView){
                commentView.frame = CGRectMake(0, 315, VIEW_WEIGHT, VIEW_HEIGHT-315);
            }
            return 70;
        }
        
    }else
        return 40.;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 20.;
    }else if(section==3){
        return 25.;
    }else{
        return 1.;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==3){
        return 0.5;
    }else
    return 10.;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 25)];
    if(section==3){
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 25)];
        lable.text = @"咨询专家";
        lable.textColor = [UIColor blackColor] ;
        lable.font = [UIFont systemFontOfSize:12.];
        [view addSubview:lable];
        view.backgroundColor = RGBACOLOR(220., 220., 220., 1);
    }
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        _istapInfoCell = !_istapInfoCell;
        if(_istapInfoCell){
            infolable.numberOfLines = 0;
            [infolable sizeToFit];
        }else{
            infolable.numberOfLines = 3;
            [infolable sizeToFit];
        }
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(UIView *)setCommentView
{
    commentView = [[CommentView alloc]initWithFrame:CGRectMake(0, 315, VIEW_WEIGHT, VIEW_HEIGHT-315)];
    commentView.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:@"KeyBoardChange" object:nil];
    return commentView;
}

-(void)keyBoardChange:(NSNotification *)notify
{
    NSInteger num = [[notify object] integerValue];
    if(num<100){
        commentView.frame = CGRectMake(0, 315, VIEW_WEIGHT, VIEW_HEIGHT-315);
    }else
    commentView.frame = CGRectMake(0, 315-num, VIEW_WEIGHT, VIEW_HEIGHT-315+num);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
