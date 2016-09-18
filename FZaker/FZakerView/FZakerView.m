//
//  FZakerView.m
//  FZaker
//
//  Created by Apple on 16/9/13.
//  Copyright © 2016年 Linitial. All rights reserved.
//

#import "FZakerView.h"

@interface FZakerView () <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;


@end

@implementation FZakerView

- (instancetype)initWithFrame:(CGRect)frame referenceView:(UIView *)view {
    self = [super initWithFrame:frame];
    if (self) {
        self.referenceView = view;
        self.originRect = self.referenceView.bounds;
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panPullView:)];
        [self addGestureRecognizer:pangesture];
        [self.referenceView addSubview:self];
        [self configBehavior];
    }
    return self;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.referenceView];
        _animator.delegate = self;
    }
    return _animator;
}

- (void)configBehavior {
    if (self.animator.behaviors) {
        [self.animator removeAllBehaviors];
    }
    //重力行为
    UIGravityBehavior* gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self]];
    gravityBeahvior.magnitude = 6.0;
    [self.animator addBehavior:gravityBeahvior];
    
    //碰撞行为
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self]];
//    [collisionBehavior addBoundaryWithIdentifier:@"collisionBoundary1" fromPoint:CGPointMake(-0.5, 0) toPoint:CGPointMake(self.bounds.size.width-.5, 0)];
    [collisionBehavior addBoundaryWithIdentifier:@"collisionBoundary" fromPoint:CGPointMake(0, self.bounds.size.height+1) toPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height+1)];

    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    //动力元素行为
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    itemBehaviour.elasticity = 0.55; //弹性
    itemBehaviour.friction = 0.3;
    [self.animator addBehavior:itemBehaviour];
}


- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    NSLog(@"end");
//    self.frame = self.originRect;
    
}

- (void)panPullView:(UIPanGestureRecognizer *)pangesture {
    if (self.animator.isRunning) { //防止降落过程中拖动
        return;
    }
    CGPoint offset = [pangesture translationInView:self];
    NSLog(@"y is %f",self.center.y + offset.y);
    if (self.center.y + offset.y>335.0) {
        return;
    }
    if (pangesture.state == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(self.center.x, self.center.y + offset.y)];
        [pangesture setTranslation:CGPointMake(0, 0) inView:self];
    } else if(pangesture.state == UIGestureRecognizerStateEnded){
        if ( self.center.y + offset.y>=0) {
            [self configBehavior];
        } else {
            [UIView animateWithDuration:0.34 animations:^{
                self.frame = CGRectMake(0, -self.bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height-64);
            }];
        }
    }
}


@end
