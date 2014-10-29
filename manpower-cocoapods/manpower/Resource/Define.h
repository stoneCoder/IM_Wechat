//
//  Define.h
//  AutoTour
//
//  Created by hanjin on 14-3-10.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <DDLog.h>
#import "Constants.h"
#import <XMPPFramework/XMPPLogging.h>
#import "SWJSON.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static int ddLogLevel = LOG_LEVEL_ERROR;
#endif

#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_INFO | XMPP_LOG_FLAG_SEND_RECV | XMPP_LOG_FLAG_VERBOSE | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

#pragma mark - 接口API

#define XMPP_HOST_PORT 5222
#define XMPP_HOST_RESOURCE @"iOS"

//#define APIDEBUG

#ifdef APIDEBUG

#define SERVICE_IP @"192.168.102.119"
#define XMPP_HOST_NAME SERVICE_IP
#define XMPP_HOST_DOMAIN SERVICE_IP
#define SERVICE_API [NSString stringWithFormat:@"http://%@:8081/IMServiceManager/",SERVICE_IP]
#define API [NSString stringWithFormat:@"http://%@:9090/",SERVICE_IP]

#else

#define SERVICE_IP @"m.whzm.cn"
#define XMPP_HOST_NAME SERVICE_IP
#define XMPP_HOST_DOMAIN SERVICE_IP
#define SERVICE_API [NSString stringWithFormat:@"http://%@:8090/IMServiceManager/",SERVICE_IP]
#define API [NSString stringWithFormat:@"http://%@:9090/",SERVICE_IP]

#endif

#define URL_MSG_ATTACHMENT_UPLOAD [NSString stringWithFormat:@"%@addEcContentInforMsg",SERVICE_API]
//@"http://192.168.102.119:8081/IMServiceManager/addEcContentInforMsg"

#define IMAGE_DEFAULT_PERSON [UIImage imageNamed:@"defaultPerson"]

#define IMAGE_DEFAULT_ROOM [UIImage imageNamed:@"defaultGroup"]

#define IMAGE_DEFAULT_BACKGROUND [UIImage imageNamed:@"contact_bg"]

#pragma mark - 单例

#define DEFINE_SINGLETON_FOR_HEADER(className) \
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#pragma mark - 颜色
#define LightBgColor [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
#define BoxColor [UIColor colorWithRed:38.0/255.0 green:193.0/255.0 blue:252.0/255.0 alpha:1.0].CGColor;

#define UIColorFromRGBA(rgb,a) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:a]
#define UIColorFromRGB(rgb) UIColorFromRGBA(rgb,1.0f)


#pragma mark - 适配
// 判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
//判断是否时iphone5
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#pragma mark - 其他
#define ccp CGPointMake

#pragma mark - 发消息相关
#define MSG_TYPE_TEXT 0
#define MSG_TYPE_IMAGE 1
#define MSG_TYPE_AUDIO 2
#define MSG_TYPE_LOCATION 3

#define MSG_ARG_TYPE @"msgType"
#define MSG_ARG_BODY @"msg"
#define MSG_ARG_TIME @"sendTime"
#define MSG_ARG_DESC @"description"
#define MSG_ARG_AVATAR @"avatar"
#define MSG_SEND_TIME_FORMATTER @"yyyy-MM-dd HH:mm:ss"

#define URL_FILE_FIELD @"msg"
#define URL_FROM_JID_FIELD @"ecContentInfor.fromJid"
#define URL_TO_JID_FIELD @"ecContentInfor.toJid"
#define URL_MSG_TYPE_FIELD @"ecContentInfor.msgType"
#define URL_RESULT_FIELD @"ecContentInfor"
#define URL_UPLOAD_FIELD @"uploadImage"

#pragma mark - 消息界面布局参数

#define MSG_STATUS_PENDING 2    // 消息接收中/发送中
#define MSG_STATUS_SUCCESS 1    // 消息发送成功
#define MSG_STATUS_FAILURE 0    // 消息发送失败

#define MSG_FONT_SIZE 16    // 消息文字字号
#define MSG_BUBBLE_LENGTH 8 // 气泡尖尖的宽度
#define MSG_NICKNAME_LABEL_HEIGHT 17    // 名字Label的高度
#define MSG_ROW_HEIGHT_DEFAULT 64 // 单行消息的CELL高度
#define MSG_TEXT_MARGIN_H 10    // 消息距气泡左右间距
#define MSG_TEXT_MARGIN_V 10    // 消息距气泡上下间距
#define MSG_IMAGE_MARGIN_H 8
#define MSG_IMAGE_MARGIN_V 4
#define MSG_MSG_MARGIN_H 5
#define MSG_PHOTO_EDGE 41   // 头像边长
#define MSG_CELL_TOP_PADDING 10     // 气泡距cell顶部间距
#define MSG_CONTENT_MAX_WIDTH 220   // 消息气泡最大宽度

#define MSG_SENT_PHOTO_X 270    // 发送消息 头像 X
#define MSG_RECV_PHOTO_X 10     // 接收消息 头像 X
#define MSG_SENT_CONTAINER_X 40 // 发送消息 气泡 X
#define MSG_RECV_CONTAINER_X 60 // 接收消息 气泡 最左边X

#define MSG_IMAGE_DEFAULT_WIDTH 120     // 图片消息 最大宽度
#define MSG_IMAGE_DEFAULT_HEIGHT 213.3  // 图片消息 最大高度    高宽比，16:9

#define MSG_IMAGE_LOADING_WIDTH 120     // 默认图 宽度
#define MSG_IMAGE_LOADING_HEIGHT 100    // 默认图 高度

#define MSG_SHOW_TIME_DIFF 180      // 消息时间差间隔 >= 3分钟，显示时间标签。
#define MSG_TIME_LABEL_HEIGHT 20    // 时间标签高度

#define MSG_CONTAINER_BORDER_WIDTH 1
#define MSG_CONTAINER_BORDER_RADIUS 5

#define MSG_SENT_PHOTO_FRAME CGRectMake(MSG_SENT_PHOTO_X, MSG_CELL_TOP_PADDING, MSG_PHOTO_EDGE, MSG_PHOTO_EDGE)
#define MSG_RECV_PHOTO_FRAME CGRectMake(MSG_RECV_PHOTO_X, MSG_CELL_TOP_PADDING, MSG_PHOTO_EDGE, MSG_PHOTO_EDGE)

#define MSG_CONTAINER_BORDER_COLOR_RECV [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] CGColor]
#define MSG_CONTAINER_BORDER_COLOR_SENT [[UIColor colorWithRed:0.2 green:0.9 blue:0.3 alpha:1] CGColor]

#define ALERT_TEXT_PREPARING_RECORDING @"正在开启录音设备"
#define ALERT_TEXT_SLIDE_UP_CANCEL @"手指上划取消发送"
#define ALERT_TEXT_TOUCH_UP_CANCEL @"松开手指，取消发送"

#define NOFITICATION_CHANGE_FRIEND_NICKNAME @"cn.whzm.notification_change_friend_nickname"
#define NOFITICATION_LOG_OUT @"cn.whzm.notification_log_out"
#define ENABLE_VIBRATE YES  //收到消息是否振动
#define MSG_ENABLE_ENCRYPT true  //启动消息加密
// 消息回执
#define MSG_SENT_SUCCESS @"OK"  // 发消息后，服务器返回OK时，视为消息发送成功
#define MSG_SENT_RECIEPT true //是否启用消息回执

#define RAC_EMPTY_STRING @"<null/>"

#define RECORD_COUNT 5