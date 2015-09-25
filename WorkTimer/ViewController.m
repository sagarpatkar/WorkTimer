//
//  ViewController.m
//  WorkTimer
//
//  Created by Sagar Patkar on 9/16/15.
//  Copyright (c) 2015 Sagar Patkar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize setLocationButton, getListButton, aboutButton, dashboardView;

/* Following two method implementations only show that we can add a button action from the code
    or also decide on a screen navigation to happen directly from the storyboard */
- (IBAction)getHourList:(id)sender
{
    NSLog(@"User wants to view the hour list.");
}
- (IBAction)setWorkLocation:(id)sender
{
    NSLog(@"User wants to set an office location.");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

//Formatting the buttons before the view appears
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.setLocationButton.layer setCornerRadius:5.0];
    self.setLocationButton.contentEdgeInsets = UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f);
    [self.getListButton.layer setCornerRadius:5.0];
    self.getListButton.contentEdgeInsets = UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f);
    
    [self.aboutButton.layer setCornerRadius:5.0];
    self.aboutButton.contentEdgeInsets = UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 15.0f);
    
    [self.dashboardView.layer setCornerRadius:10.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}


@end

