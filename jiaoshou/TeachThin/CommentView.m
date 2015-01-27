//
//  CommentView.m
//  TeachThin
//
//  Created by 王园园 on 15-1-5.
//  Copyright (c) 2015年 巩鑫. All rights reserved.
//

#import "CommentView.h"

#import "DXMessageToolBar.h"

#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"

#define KPageCount 20
@interface CommentView()<UITableViewDataSource, UITableViewDelegate, IChatManagerDelegate, DXMessageToolBarDelegate, IDeviceManagerDelegate>//,DXChatBarMoreViewDelegate
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
    BOOL _isScrollToBottom;
    BOOL _isRecording;
    
    NSMutableArray  *_allMessagesFrame;
    
}

@property (nonatomic) BOOL isChatGroup;
@property (strong, nonatomic) NSString *chatter;


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) NSDate *chatTagDate;

@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;

@end

@implementation CommentView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayout];
    }
    return self;
}

-(void)setLayout
{
    _allMessagesFrame = [NSMutableArray array];

    [self addSubview:[self tableView]];
    [self addSubview:self.chatToolBar];
    
//    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
//        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
//    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self addGestureRecognizer:tap];
}
// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
        self.tableView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.frame.size.height - [DXMessageToolBar defaultHeight], self.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        
        ChatMoreType type = _isChatGroup == YES ? ChatMoreTypeGroupChat : ChatMoreTypeChat;
        _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) typw:type];
        _chatToolBar.moreView.backgroundColor = [UIColor lightGrayColor];
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _chatToolBar;
}

#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KeyBoardChange" object:@(toHeight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:YES];
}


//发送消息
- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

-(void)sendTextMessage:(NSString *)text
{
    //提交加载数据
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:text,@"content",[ManageVC sharedManage].uid,@"uid",_expid,@"userid", nil];
    JSHttpRequest *request = [[JSHttpRequest alloc]init];
    [request StartWorkPostWithurlstr:URL_Professorcomment pragma:pragma ImageData:nil];
    request.successGetData = ^(id obj){
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"DataDict-----%@",dict);
        if([[dict valueForKey:@"code"] isEqualToString:@"01"]){
            //提交留言成功
            NSString *content = text;
            NSDate *date = [NSDate date];
            //转时间字符串
            NSString *time = [ManageVC DateStrFromDate:date Withformat:@"yyyy-MM-dd HH:mm:ss"];
            [self addMessageWithContent:content time:time];// 1、增加数据源
            [self.tableView reloadData];
            // 2、滚动至当前行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    };
    request.failureGetData = ^(void){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    };
    
}


#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = [ManageVC sharedManage].userImg;
    msg.type = MessageTypeMe;
    mf.message = msg;
    [_allMessagesFrame addObject:mf];
}

//////////////////////////////total////////////////////////////
-(void)setCommentData:(NSArray *)Arr WithexpId:(NSString *)userid;
{
    _expid = userid;
    NSString *previousTime = nil;

    for (NSDictionary *dict in Arr) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dict = dict;
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        messageFrame.message = message;
        
        previousTime = message.time;
        
        [_allMessagesFrame addObject:messageFrame];
    }
    [self.tableView reloadData];
    
    // 3、滚动至最后一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}




#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}





- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

- (void)showRoomContact:(id)sender
{
    [self endEditing:YES];
}






@end
