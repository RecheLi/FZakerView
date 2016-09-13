//
//  ViewController.m
//  FZaker
//
//  Created by Apple on 16/9/13.
//  Copyright © 2016年 Linitial. All rights reserved.
//

#import "ViewController.h"
#import "FZakerView.h"

@interface ViewController ()

@property (nonatomic, strong) FZakerView *fzakerView;

@property (nonatomic, strong) UIButton *dropButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.dropButton];
    [self initFakeZakerView];
}

- (void)initFakeZakerView {
    _fzakerView = [[FZakerView alloc] initWithFrame:CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    _fzakerView.backgroundColor = [UIColor darkGrayColor];
    _fzakerView.userInteractionEnabled = YES;
    [self.view addSubview:_fzakerView];
    
}

- (UIButton *)dropButton {
    if (!_dropButton) {
        _dropButton = ({
            UIButton *dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
            dropButton.frame = CGRectMake(100, 100, 60, 30);
            dropButton.backgroundColor = [UIColor redColor];
            [dropButton setTitle:@"降落" forState:UIControlStateNormal];
            [dropButton addTarget:self action:@selector(drop) forControlEvents:UIControlEventTouchUpInside];
            dropButton;
        });
    }
    return _dropButton;
}

- (void)drop {
    [UIView animateWithDuration:0.34 animations:^{
        _fzakerView.frame = CGRectMake(0, -self.view.bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height);
    }];
    [_fzakerView configBehavior];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
