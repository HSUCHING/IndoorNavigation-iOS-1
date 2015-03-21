//
//  PathBuilderView.m
//  AnimatedPath
//
//  Created by Andrew Hershberger on 11/13/13.
//  Copyright (c) 2013 Two Toasters, LLC. All rights reserved.
//

#import "PathBuilderView.h"
#import "ShapeView.h"
#import <CoreLocation/CoreLocation.h>

static CGFloat const kPointDiameter = 7.0;

@interface PathBuilderView ()  <CLLocationManagerDelegate>
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSValue *prospectivePointValue;
@property (nonatomic) NSUInteger indexOfSelectedPoint;
@property (nonatomic) CGVector touchOffsetForSelectedPoint;
@property (nonatomic, strong) NSTimer *pressTimer;
@property (nonatomic) BOOL ignoreTouchEvents;

@property (nonatomic , strong) CALayer *naviIcon;
@property (nonatomic , strong) CLLocationManager *locationManager;


@end

@implementation PathBuilderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _points = [[NSMutableArray alloc] init];
        self.multipleTouchEnabled = NO;
        
        _ignoreTouchEvents = NO;
        _indexOfSelectedPoint = NSNotFound;
        
        _pathShapeView = [[ShapeView alloc] init];
        _pathShapeView.shapeLayer.fillColor = nil;
        _pathShapeView.backgroundColor = [UIColor clearColor];
        _pathShapeView.opaque = NO;
        _pathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pathShapeView];
        
        _prospectivePathShapeView = [[ShapeView alloc] init];
        _prospectivePathShapeView.shapeLayer.fillColor = nil;
        _prospectivePathShapeView.backgroundColor = [UIColor colorWithRed:239 green:240 blue:242 alpha:1];
        _prospectivePathShapeView.opaque = NO;
        _prospectivePathShapeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_prospectivePathShapeView];
        
        _pointsShapeView = [[ShapeView alloc] init];
        _pointsShapeView.backgroundColor = [UIColor clearColor];
        _pointsShapeView.opaque = NO;
        _pointsShapeView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pointsShapeView];
        
        if ([CLLocationManager headingAvailable]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingHeading];
        }
        self.naviIcon = [[CALayer alloc] init];
        self.naviIcon.frame = CGRectMake(369, 880,30,30);
        self.naviIcon.contents = (id)[[UIImage imageNamed:@"navigator"] CGImage];
        [self.layer addSublayer:self.naviIcon];
        
    }
    return self;}

-(void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    CGFloat headings = M_PI*newHeading.trueHeading/180.0f;
    //CGFloat headings = newHeading.trueHeading;
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D fromValue = self.naviIcon.transform;
    anim.fromValue = [NSValue valueWithCATransform3D:fromValue];
    
    CATransform3D toValue = CATransform3DMakeRotation(headings, 0, 0, 1);
    anim.toValue = [NSValue valueWithCATransform3D:toValue];
    anim.duration = 0.2;
    anim.removedOnCompletion = YES;
    self.naviIcon.transform = toValue;
    [self.naviIcon addAnimation:anim forKey:nil];
    
    
}

- (void)addPointsIn:(NSMutableArray*)thosePoints shapViewOrNot:(BOOL)shapViewOrNot{
    self.points = thosePoints;
    [self updatePathsByView:shapViewOrNot];
    
}

- (void)updatePathsByView:(BOOL)shapViewOrNot
{
    if ([self.points count] >= 2) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [self.points insertObject:[self.points firstObject] atIndex:0];
        [path moveToPoint:[[self.points firstObject] CGPointValue]];

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [self.points count] - 1)];
        [self.points enumerateObjectsAtIndexes:indexSet
                                       options:0
                                    usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                                        [path addLineToPoint:[pointValue CGPointValue]];
                                    }];
        if (shapViewOrNot == YES) {
            self.pathShapeView.shapeLayer.path = path.CGPath;
        }else{
            self.prospectivePathShapeView.shapeLayer.path = path.CGPath;
        }
        
    }
    else {
        self.pathShapeView.shapeLayer.path = nil;
    }
}

- (void)DrawSelf:(float)x y:(float)y{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint selfPoint = CGPointMake(x, y);

    [path appendPath:[UIBezierPath bezierPathWithArcCenter:selfPoint radius:kPointDiameter / 2.0 startAngle:0.0 endAngle:2 * M_PI clockwise:YES]];
    
    self.pointsShapeView.shapeLayer.path = path.CGPath;
}

- (void)Clear{
    [self.points removeAllObjects];
}



@end
