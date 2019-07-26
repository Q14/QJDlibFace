//
//  ViewController.m
//  QJDlibFace
//
//  Created by Q14 on 2019/7/26.
//  Copyright © 2019 Gengmei. All rights reserved.
//

#import "ViewController.h"
#import "SessionHandler.h"

@interface ViewController ()
@property (nonatomic, strong) SessionHandler *sessionHandler;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.bgView = [[UIView alloc] init];
    self.view.frame = self.view.bounds;
    [self.view addSubview:self.bgView];
    
    self.sessionHandler = [[SessionHandler alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.sessionHandler openSession];
    self.sessionHandler.layer.frame = self.bgView.bounds;
    [self.bgView.layer addSublayer:self.sessionHandler.layer];
    [self.view layoutIfNeeded];
//    [self.sessionHandler ]
}
@end
