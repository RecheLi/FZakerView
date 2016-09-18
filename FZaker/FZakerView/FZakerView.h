//
//  FZakerView.h
//  FZaker
//
//  Created by Apple on 16/9/13.
//  Copyright © 2016年 Linitial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZakerView : UIImageView

@property (nonatomic, strong) UIView *referenceView;

@property (nonatomic, assign) CGRect originRect;

- (instancetype)initWithFrame:(CGRect)frame referenceView:(UIView *)view;

- (void)configBehavior;

@end
