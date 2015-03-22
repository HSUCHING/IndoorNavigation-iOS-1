//
//  ViewController.h
//  CalPositionByDistance
//
//  Created by Lc on 15/3/2.
//  Copyright (c) 2015年 Lc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BeaconClient.h"
#import "storage.h"
#import "iBeacon.h"
#import "PathBuilderView.h"
#import "ShapeView.h"
#import "NaviAlgo.h"
#import "Header.h"
#import "ShelfCargoViewController.h"


@interface PathBuilderViewController : UIViewController{
//    NSMutableArray *choosedPoints;
    NSMutableArray *pathPoints;
    NSMutableArray *aIBeacons;
    NSTimer *ressTimer;
    BOOL drawOrClear;
    NSMutableArray *storageArray;
    NSMutableArray *footprintArray;
    CFTimeInterval kDuration;
}

@property (nonatomic, retain) NSMutableArray *choosedPoints;

@property (nonatomic, retain) BeaconClient *beaconClient;
- (void) drawFootprint:(NSTimer *) myTimer;
- (void) clearFootprint:(NSTimer *) myTimer;
@end

