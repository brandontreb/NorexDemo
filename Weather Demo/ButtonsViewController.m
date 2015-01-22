//
//  ButtonsViewController.m
//  Weather Demo
//
//  Created by Brandon Trebitowski on 1/21/15.
//  Copyright (c) 2015 Pixegon. All rights reserved.
//

#import "ButtonsViewController.h"
#import "MFSideMenu.h"

@interface ButtonsViewController ()

@end

@implementation ButtonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Buttons";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteButtonTapped:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"TEST"
                                message:@"Deleted!"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}

- (IBAction)pushMeButtonTapped:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"TEST"
                               message:@"You pushed the button!"
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}

- (IBAction)showRightMenuButtonTapped:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{}];
}

@end
