//
//  WaterWaveView.h
//  WuKongStory
//
//  Created by GodLove on 2018/10/19.
//  Copyright © 2018年 Toprays. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaterWaveView : UIView

- (instancetype)initWithColor:(UIColor *)color;

- (void)pauseDisplayLink:(BOOL)suspend;

@end

NS_ASSUME_NONNULL_END
