//
//  Header.h
//  IndoorNavigation
//
//  Created by Lc on 15/3/20.
//  Copyright (c) 2015年 SAP SE. All rights reserved.
//

#ifndef IndoorNavigation_Header_h
#define IndoorNavigation_Header_h
#define SCALE 1024/4.8    //定义实际距离与屏幕显示房间尺寸的比例尺
#define NUM_OF_BEACONS 6  //定义beacon总数量
#define MAX_DISTANCE 3  //定义可能的最大beacon距离 单位：米
#define MIN_DISTANCE 1  //定义更新坐标的最小值，单位:屏幕像素
static CFTimeInterval const kDuration = 4.0;



#endif