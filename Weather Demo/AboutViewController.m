//
//  AboutViewController.m
//  Weather Demo
//
//  Created by Brandon Trebitowski on 1/21/15.
//  Copyright (c) 2015 Pixegon. All rights reserved.
//

#import "AboutViewController.h"
#import "MFSideMenu.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRightMenuButtonTapped:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{}];
}
@end
