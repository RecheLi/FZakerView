//
//  FZakerView.m
//  FZaker
//
//  Created by Apple on 16/9/13.
//  Copyright © 2016年 Linitial. All rights reserved.
//

#import "FZakerView.h"

@interface FZakerView () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;


@end

@implementation FZakerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panPullView:)];
        [self addGestureRecognizer:pangesture];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self configBehavior];
    }
    return self;
}

- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:[UIApplication sharedApplication].keyWindow];
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
    [collisionBehavior addBoundaryWithIdentifier:@"collisionBoundary" fromPoint:CGPointMake(0, self.bounds.size.height) toPoint:CGPointMake(self.bounds.size.width+1, self.bounds.size.height)];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    //动力元素行为
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    itemBehaviour.elasticity = 0.4; //弹性
    [self.animator addBehavior:itemBehaviour];
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
