//
//  Macro.h
//  TeachThin
//
//  Created by 巩鑫 on 14-11-19.
//  Copyright (c) 2014年 巩鑫. All rights reserved.
//

#ifndef TeachThin_Macro_h
#define TeachThin_Macro_h
#import "NonetView.h"
#import "MBHUDView.h"
#import "JSHttpRequest.h"


//医院的Id（该APP此处定义该APP为哪家医院服务）
#define Macro_HospitalId  @"1"





//判断程序的版本
#define IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

//整个屏幕的宽和高
#define VIEW_WEIGHT [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT (IOS_7 ?[UIScreen mainScreen].bounds.size.height :([UIScreen mainScreen].bounds.size.height-64))
#define VIEW_HEIGHT_TAB ([UIScreen mainScreen].bounds.size.height-113)

//控件的尺寸
#define WIDTH_VIEW(view) CGRectGetWidth(view.frame)
#define HEIGHT_VIEW(view) CGRectGetHeight(view.frame)
#define VIEW_MAXX(view) CGRectGetMaxX(view.frame)
#define VIEW_MAXY(view) CGRectGetMaxY(view.frame)

#define VIEW_oringeY  (IOS_7 ? 64:0)


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define GXRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]






//接口
#define MAINURL @"http://www.gmtxw01.com/index.php?"

//拍一拍单品接口
#define URL_PhotoDanpinData(name)  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=product&c=index&a=food_decription&foodname=%@",name]]
//拍一拍菜品接口
#define URL_PhotoCaipinData(name)  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=product&c=index&a=disha&foodname=%@",name]]
//拍一拍单品食物交换分
#define URL_JiaohuanfenData(id,page) [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=product&c=index&a=dish&id=%@&page=%@",id,page]]
//模糊搜索关键字
#define URL_FoodDPData(version) [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=cache&a=getproduct&version=%@",version]]
#define URL_FoodCPData(version) [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=cache&a=getdish&version =%@",version]]

//首页计划执行状态列表
#define URL_MyPlanStatus  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=init"]]
//计划详情页(post)
#define URL_MyPlanDetail  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=infor"]]
//计划星级评分
#define URL_MyPlanStar  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=star"]]
//阶段计划日历状态列表(post)
#define URL_JDPlanDetail  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=details"]]
//处方医嘱(post)
#define URL_PlanCFYZDetail [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=prescription"]]
//处方医嘱(post)
#define URL_PlanYZDetail [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=advice"]]

//我的家人百日计划监督页面post  //Uid:好友id
#define URL_FamilyPlan [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=getFriendPlan"]]

//养我
#define URL_Yangwo [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=plan&a=getbmi"]]



//每日运动模块／营养知识／／／／／／／／／／／／／／／／／／／／
//运动分类
#define URL_menuListType(type) [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=article&c=index&a=arclass&type=%@",type]]
//每日运动列表
#define URL_SportListData(type,typeid,pagesize,page) [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=article&c=index&a=lista&type=%@&typeid=%@&pagesize=%@&page=%@",type,typeid,pagesize,page]]
//每日运动搜索
#define URL_SportSearchList(type,key) [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=article&c=index&a=lista&type=%@&keyword=%@",type,key]]
//每日运动详情
#define URL_SportDetail(id) [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=article&c=index&a=article&aid=%@",id]]

//我的收藏
//收藏列表post  Uid：用户id
#define URL_CollectionList [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=favorite&a=init"]]
//添加收藏 Uid：用户id Artid:文章id Title:收藏标题 Infor：收藏简介
#define URL_AddCollectionData [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=favorite&a=insert"]]
//删除收藏 Uid：用户id id:收藏id
#define URL_DeletCollectionData [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=favorite&a=del"]]

//找专家模块／／／／／／／／／／／／／／／／／／／／／／／
//课室列表
#define URL_KeshiList  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=expert&a=getdepartment"]]
//专家列表
/*(depid:可选 科室idorder:可选 为1按星级排序page:分页 可选默认1pagesize：可选 每页显示多少数据默认10key：搜索专家关键词可选。)*/
#define URL_ProfessorList  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=expert&a=init"]]
//专家详情（pexis,uid）
#define URL_ProfessorDetail  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=expert&a=getexpert"]]
//给专家留言（content：留言内容uid：用户iduserid:专家id）
#define URL_Professorcomment [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=expert&a=saveMessage"]]



//食物配送模块/////////////////////
//实物配送分类
#define URL_FoodmenuType [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=getclass"]]
//实物配送列表
#define URL_FoodMenuList [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=lists"]]
//实物配送搜索
//同上(key)


//实物配送详情
#define URL_Food_Detail [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=show"]]
//判断购物车(uid)
#define URL_JudgeHouwuche [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=getcart"]]
//加入购物车(id, uid)
#define URL_AddFoodToOrder [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=addcart"]]

//购物车列表
#define URL_FoodOrderList [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=cartlist"]]
//删除购物车物品
#define URL_DelFoodToOrder [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=del"]]

//提交订单(Uid:用户idCartid:购物车id多个中间用,分割1，2，3)
#define URL_SubmitOrder [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=save"]]
//我的订单
#define URL_MyOrder [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=shop&a=getorder"]]
//我的体检报告
#define URL_MyChecker [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=getpatien"]]


//量一量 数据上传接口 POST
#define URL_Measure_Data  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=measure&c=index&a=measure_data"]]
//量一量数据查看 GET
#define URL_Measure_Look [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=measure&c=index&a=measure_inserm"]]
//量一量根据日期查看 GET
#define URL_Measure_Date [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=measure&c=index&a=measure_date"]]

//每日食谱／／／／／／／／／／／／／／／／／／／／／／
//数据查看 post
#define URL_Recipes_recipes  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=mrspjk&c=recipes&a=recipes"]]
//计划执行 post
#define URL_Recipes_plan  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=mrspjk&c=recipes&a=plan"]]
//计划不执行 post
#define URL_Recipes_noplan  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=mrspjk&c=recipes&a=noplan"]]


//用户登录注册
//用户登录接口 post
#define URL_Login  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=ulogin"]]
//用户注册接口 post
#define URL_Register  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=regUser"]]
//忘记密码接口 post
#define URL_ForgetPassword  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=modifyPwd"]]

//用户修改资料接口
#define URL_Update [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=update"]]
//会话列表
#define URL_conversion  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=getInfors"]]
#define URL_GetInfo [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=getInfor"]]


//调查问卷列表页接口
#define URL_ZhuCe_list  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=mrspjk&c=zhuce&a=zhuce"]]
//调查文件数据上传
#define URL_ZhuCe_patient  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=patient&c=index&a=inves"]]

//短信验证码
#define URL_Send  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=send"]]
//验证
#define URL_checkCode  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=checkCode"]]
//用户注册环信接口 post
#define URL_Register_huanxin  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=hreg"]]
//搜索好友
#define URL_searchFriend  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=searchFriend"]]

//添加好友
#define URL_addFriend  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=addFriend"]]
#define URL_friendRequest  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=getVerify"]]
//删除好友
#define URL_friend_delete  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=delFriend"]]

//删除好友及好友请求 in-dex.php?m=hkiyun&c=user&a=delFriend
#define URL_friend_deleteAndRequest  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=delFriend"]]

//好友列表 m=hkiyun&c=user&a=getFriendList
#define URL_friend_list  [MAINURL stringByAppendingString:[NSString stringWithFormat:@"m=hkiyun&c=user&a=getFriendList"]]




#endif
