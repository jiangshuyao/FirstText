//
//  PortApi.h
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/7/1.
//  Copyright © 2016年 SY. All rights reserved.
//

#ifndef PortApi_h
#define PortApi_h

//视频列表请求接口
#define  get_VideoList_Url     @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"

//美女列表请求接口page代表的是第几页
#define  get_GirlList_Url(page)    [NSString stringWithFormat:@"http://www.tngou.net/tnfs/api/list?page=%d&rows=100",page]

//美女图片显示请求头
#define pinterestImageUrl   @"http://tnfs.tngou.net/image"//显示图片Http请求


#endif /* PortApi_h */
