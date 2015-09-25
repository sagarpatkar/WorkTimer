//
//  LocationViewController.h
//  WorkTimer
//
//  Created by Sagar Patkar on 9/17/15.
//  Copyright (c) 2015 Sagar Patkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
{
    // button to use the selected location
    IBOutlet UIButton *useLocationButton;
    
    //MapView in the current view
    IBOutlet MKMapView *workMap;
    
    NSDate *inDateTime;
    NSDate *outDateTime;
    NSDate *locationSetDateTime;
}

@property (nonatomic, retain) IBOutlet UIButton *useLocationButton;
@property (nonatomic, retain) IBOutlet MKMapView *workMap;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDate *inDateTime;
@property (nonatomic, strong) NSDate *outDateTime;
@property (nonatomic, strong) NSDate *locationSetDateTime;


@end
