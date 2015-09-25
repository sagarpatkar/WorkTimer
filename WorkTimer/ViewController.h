//
//  ViewController.h
//  WorkTimer
//
//  Created by Sagar Patkar on 9/16/15.
//  Copyright (c) 2015 Sagar Patkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    //button to set work location
    IBOutlet UIButton *setLocationButton;
    
    //button to get the work day list
    IBOutlet UIButton *getListButton;
    
    IBOutlet UIButton *aboutButton;
    
    IBOutlet UIView *dashboardView;
}

@property (nonatomic, strong) IBOutlet UIButton *setLocationButton;
@property (nonatomic, strong) IBOutlet UIButton *getListButton;
@property (nonatomic, strong) IBOutlet UIView *dashboardView;
@property (nonatomic, strong) IBOutlet UIButton *aboutButton;

- (IBAction)getHourList:(id)sender;
- (IBAction)setWorkLocation:(id)sender;

@end