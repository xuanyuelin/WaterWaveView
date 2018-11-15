//
//  WaterWaveView.m
//  WuKongStory
//
//  Created by GodLove on 2018/10/19.
//  Copyright © 2018年 Toprays. All rights reserved.
//

#import "WaterWaveView.h"
#import "Masonry.h"

static int timeX = 0;

@implementation WaterWaveView
{
    // 图形
    UIView *fstView;
    UIView *secView;
    UIView *thirdView;
    CAShapeLayer *fstLayer;
    CAShapeLayer *secLayer;
    CAShapeLayer *thirdLayer;
    
    // 数据
    UIColor *bgColor;
    CGFloat fstOffsetX;
    CGFloat secOffsetX;
    CGFloat thirdOffsetX;
    CADisplayLink *displayLink;
}

- (instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        bgColor = color;
        [self initUI];
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshWavePaths)];
        displayLink.preferredFramesPerSecond = 30;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        displayLink.paused = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil) {
        displayLink.paused = NO;
    }else {
        displayLink.paused = YES;
        [displayLink invalidate];
    }
}

- (void)initUI {
    fstView = [UIView new];
    fstView.backgroundColor = [bgColor colorWithAlphaComponent:0.5];
    
    secView = [UIView new];
    secView.backgroundColor = [bgColor colorWithAlphaComponent:0.3];
    
    thirdView = [UIView new];
    thirdView.backgroundColor = [bgColor colorWithAlphaComponent:0.2];
    [self addSubview:thirdView];
    [thirdView addSubview:fstView];
    [thirdView addSubview:secView];
    
    [self initLayout];
}

- (void)initLayout {
    [fstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [secView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (fstLayer == nil) {
        fstLayer = [CAShapeLayer new];
        fstView.layer.mask = fstLayer;
        
        secLayer = [CAShapeLayer layer];
        secView.layer.mask = secLayer;
        
        thirdLayer = [CAShapeLayer layer];
        thirdView.layer.mask = thirdLayer;
        
        // 初始化路径偏移量
        fstOffsetX = 0;
        secOffsetX = 0;//CGRectGetWidth(self.frame)/6;
        thirdOffsetX = 0;//CGRectGetWidth(self.frame)/6*3;
        
        [self createPaths];
    }
}

- (void)createPaths {
    if (fstLayer.path) fstLayer.path = nil;
    if (secLayer.path) secLayer.path = nil;
    if (thirdLayer.path) thirdLayer.path = nil;
    fstLayer.path = [self createSinglePath:fstOffsetX scale:1].CGPath;
    secLayer.path = [self createSinglePath:secOffsetX scale:2].CGPath;
    thirdLayer.path = [self createSinglePath:thirdOffsetX scale:3].CGPath;
}

- (UIBezierPath *)createSinglePath:(CGFloat)offsetx scale:(int)factor {
    // y = Asin(w(x+b))+c
    /// 振幅A取视图高度 视图宽度刚好为一个周期    横向偏移外部传入，纵向偏移为0
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat A = height/4;
    CGFloat W = M_PI*2/width;
    CGFloat offy = A*factor;
    
    UIBezierPath *path = [UIBezierPath new];
    // 路径默认剪切i下半部分
    [path moveToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(0, 0)];
    for (int i = 0; i <= width; i++) {
        CGFloat y = A * sinf(W*(i+offsetx))+offy;
        [path addLineToPoint:CGPointMake(i, y)];
    }
    [path closePath];
    return path;
}

- (void)refreshWavePaths {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat speed = width/256;
    fstOffsetX += speed*0.9;//[self speedAtOffset:0];
    secOffsetX += speed*0.95;//[self speedAtOffset:30];
    thirdOffsetX += speed;//*[self speedAtOffset:60];
    timeX += 1;
    [self createPaths];
}


- (CGFloat)speedAtOffset:(int)offx {
    // 创建一个周期内的分段函数，使得偏离相位能追上来
    CGFloat y = 0;
    int mod = (timeX+offx)%256;
    if (mod <= 127) {
        y = mod/127.0*0.2+0.8;
    }else {
        y = 1-((mod-127)/127.0*0.2);
    }
//    NSLog(@"a == %f,timeX == %d",y,timeX);
    return y;
}

- (void)pauseDisplayLink:(BOOL)suspend {
    displayLink.paused = suspend;
}

@end
