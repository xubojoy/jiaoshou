//
//  CheckDetailViewController.m
//  TeachThin
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import "CheckDetailViewController.h"

@interface CheckDetailViewController ()

@end

@implementation CheckDetailViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"体检报告";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backbtn"] style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnPress) ];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)backBtnPress
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex:(index-1)] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTableView];
}
-(UITableViewCell *)setCell1
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(0, 0, VIEW_WEIGHT, 80);
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 55, 55)];
    imgView.backgroundColor = [UIColor yellowColor];
    imgView.layer.cornerRadius = 27.5f;
    imgView.layer.masksToBounds = YES;
    NSString *imgstr = [NSString stringWithFormat:@"%@",[ManageVC sharedManage].userImg];
    [imgView setImageWithURL:[NSURL URLWithString:imgstr]];
    [cell addSubview:imgView];
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(imgView)+10, 15, VIEW_WEIGHT-80, 25)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];

    NSString *sex =@"女";
    if(_sex){
        sex = @"男";
    }
    NSString *str = [NSString stringWithFormat:@"%@   %@  %@   %@",_name,sex,_age,_nation];
    NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc]initWithString: str];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(_name.length,str1.length-_name.length)];
    [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0] range:NSMakeRange(_name.length,str1.length-_name.length)];
    nameLabel.attributedText = str1;
    [cell addSubview:nameLabel];
    
    
    UILabel *cotentLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_MAXX(imgView)+10,VIEW_MAXY(nameLabel)+5, VIEW_WEIGHT-80, 25)];
    cotentLabel.backgroundColor = [UIColor clearColor];
    cotentLabel.textColor = [UIColor grayColor];
    cotentLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    cotentLabel.text = [NSString stringWithFormat:@"%@",_professor];
    [cell addSubview:cotentLabel];
    
    return cell;
}

-(void)setTableView
{
    if(!table){
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, VIEW_HEIGHT) style:UITableViewStyleGrouped];
        table.backgroundColor = RGBACOLOR(241., 242., 245., 1);
        table.delegate = self;
        table.dataSource = self;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:table];
    }
}

#pragma mark - UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section==0){
        return 1.;
    }else if(section==1){
        return 6;
    }else
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSArray *arr = @[@"身高",@"体重",@"体重指数(BMI)",@"理想体重",@"体形",@"每日总能量"];
    NSArray *value = @[@"cm",@"weight",@"bmi",@"dreamkg",@"figure",@"energy"];
    UITableViewCell *cell;
    UILabel *titleLable;
    UILabel *cotentLable;
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
        if(indexPath.section==0){
            cell.frame = CGRectMake(0, 0, VIEW_WEIGHT, 80);
            cell = [self setCell1];
            
        }else {
            
            titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 140, 40)];
            titleLable.textAlignment = NSTextAlignmentLeft;
            titleLable.font = [UIFont systemFontOfSize:15.];
            titleLable.textColor = [UIColor blackColor];
            [cell addSubview:titleLable];
            
            if(indexPath.section==1){
                cotentLable = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 120, 40)];
                cotentLable.textAlignment = NSTextAlignmentLeft;
                cotentLable.font = [UIFont systemFontOfSize:15.];
                cotentLable.textColor = RGBACOLOR(167., 165., 165., 1);
                [cell addSubview:cotentLable];
            }else if (indexPath.section==2&&indexPath.row==0){
                openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                openBtn.frame = CGRectMake(VIEW_WEIGHT-60, 0, 40, 40);
                [openBtn setImage:[UIImage imageNamed:@"my_xiala"] forState:UIControlStateNormal];
                [openBtn addTarget:self action:@selector(OpenBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                openBtn.selected = NO;
                [cell addSubview:openBtn];
            }
            
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 0.5)];
            line.backgroundColor = RGBACOLOR(220., 220., 220., 1);
            [cell addSubview:line];
        }
    }
    
    if(indexPath.section==1){
        titleLable.text = arr[indexPath.row];
        cotentLable.text = [_DataDict valueForKey:value[indexPath.row]];
    }else if(indexPath.section==2){
        if(indexPath.row==0){
            titleLable.text = @"查看建议";
        }else{
            titleLable.frame = CGRectMake(20, 10, VIEW_WEIGHT-30, 40);
            titleLable.tag = 1000;
            titleLable.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            titleLable.font = [UIFont systemFontOfSize:13.];
            titleLable.text = [_DataDict valueForKey:@"suggestions"];
            titleLable.numberOfLines =0;
            [titleLable sizeToFit];
        }
    }
       return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 80;
    }else if(indexPath.section==2&&indexPath.row==1){
        if(openBtn.selected==YES){
            UITableViewCell *cell = (UITableViewCell *)[self tableView:table cellForRowAtIndexPath:indexPath];
            UILabel *lable = (UILabel *)[cell viewWithTag:1000];
            return CGRectGetHeight(lable.frame)+20;
        }else
            return 0;
    }
    return 40.;
}

-(void)OpenBtnPress:(UIButton *)btn
{
    btn.selected = !btn.selected;
    //刷新某一行
    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:2];
    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
    [table reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 0.5)];
    view.backgroundColor = RGBACOLOR(220., 220., 220., 1);
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 30)];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WEIGHT, 0.6)];
    line.backgroundColor = RGBACOLOR(220., 220., 220., 1);
    [view addSubview:line];
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
