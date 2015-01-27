//
//  ListMenuView.m
//  Lianxi
//
//  Created by 王园园 on 14-8-27.
//  Copyright (c) 2014年 王园园. All rights reserved.
//

#import "ListMenuView.h"

@implementation ListMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:[self ListTable]];
        self.layer.masksToBounds = YES;
        _MenuImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-20,self.frame.size.height/2-60, 20, 40)];
        [_MenuImage setImage:[UIImage imageNamed:@"menuImage1"]];
        [self addSubview:_MenuImage];
        [_MenuImage setUserInteractionEnabled:YES];
        
        //创建"点击手势"识别器
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapGesture:)];
        [_MenuImage addGestureRecognizer:tapGesture];
        //创建清扫按钮(左，右)
        UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(doSwipeGesture:)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [_MenuImage addGestureRecognizer:swipeGesture];
        
        UISwipeGestureRecognizer *swipeGesture2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(doSwipeGesture:)];
        [swipeGesture2 setDirection:UISwipeGestureRecognizerDirectionRight];
        [_MenuImage addGestureRecognizer:swipeGesture2];
        
    }
    return self;
}

-(UITableView *)ListTable
{
    if(!_ListTable){
        _ListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-20, self.frame.size.height) style:UITableViewStylePlain];
        _ListTable.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _ListTable.delegate = self;
        _ListTable.dataSource = self;
        _ListTable.rowHeight = 50.f;
    }
    _ListTable.alpha = 0.;
    return _ListTable;
}

-(void)ocurMenuView
{
    _ListTable.alpha = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame=CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    _MenuImage.frame = CGRectMake(self.frame.size.width-40,self.frame.size.height/2-50, 20, 30);
    [_MenuImage setImage:[UIImage imageNamed:@"menuImage2"]];
    [UIView commitAnimations];
}
-(void)hidenMenuView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    self.frame=CGRectMake(-self.frame.size.width+20, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    _MenuImage.frame = CGRectMake(self.frame.size.width-20,self.frame.size.height/2-60, 20, 40);
    [_MenuImage setImage:[UIImage imageNamed:@"menuImage1"]];
    _ListTable.alpha = 0;
    [UIView commitAnimations];
}
//“点击手势”相应方法
-(void)doTapGesture:(UITapGestureRecognizer *)recognizer;
{
    if(self.center.x<0){
        [self ocurMenuView];
    }else{
        [self hidenMenuView];
    }
}
//“清扫手势”响应方法
-(void)doSwipeGesture:(UISwipeGestureRecognizer *)recognizer;
{
    if((recognizer.direction==UISwipeGestureRecognizerDirectionRight) && (self.center.x<0))
    {
        [self ocurMenuView];
    }
    else if((recognizer.direction==UISwipeGestureRecognizerDirectionLeft) && (self.center.x>0))
    {
        [self hidenMenuView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return _ListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
        view_bg.backgroundColor = _selectCellColor;
        cell.selectedBackgroundView = view_bg;
        
        
     
        cell.textLabel.frame = CGRectMake(10, 0, 60, 50);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.tag = 3000;
        cell.textLabel.textColor = _titleColor;
        cell.textLabel.highlightedTextColor = _tapColor;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
     
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_ListArr[indexPath.row] valueForKey:@"name"]];
    return cell;
}

-(void)setListDataArr:(NSArray *)arr;
{
    _ListArr = [NSArray arrayWithArray:arr];
    [_ListTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hidenMenuView];
    if(self.TapActionBlock){
        self.TapActionBlock(indexPath.row);
    }
}
@end
