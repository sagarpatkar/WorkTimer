//
//  LocationViewController.m
//  WorkTimer
//
//  Created by Sagar Patkar on 9/17/15.
//  Copyright (c) 2015 Sagar Patkar. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import "WorkDay.h"
#import "AppDelegate.h"

@interface LocationViewController ()

@property (nonatomic) CLLocationCoordinate2D workLocation;

@end

@implementation LocationViewController

NSUserDefaults *standardDefaults;

@synthesize useLocationButton, workMap;
@synthesize locationManager, workLocation;
@synthesize inDateTime, outDateTime, locationSetDateTime;



- (void) awakeFromNib
{
    [super awakeFromNib];
    
    //setup the locationManager
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    //set self as the mapView delegate
    [self.workMap setDelegate:self];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add a longPressGesture to the map view
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration=2.0;
    [self.workMap addGestureRecognizer:longPress];
    
    //diable the use location button until the user selects a location.
    [self.useLocationButton setEnabled:NO];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //format the navigation bar
    [self.navigationItem setTitle:@"Set Location"];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:24],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Check if the user defaults already has a work location stored
    standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if([[[standardDefaults dictionaryRepresentation] allKeys] containsObject:@"locationLatitude"] && [[[standardDefaults dictionaryRepresentation] allKeys] containsObject:@"locationLongitude"])
    {
        // Show the stored work location
        CLLocationCoordinate2D currentWorkLocation;
        currentWorkLocation.latitude = [standardDefaults floatForKey:@"locationLatitude"];
        currentWorkLocation.longitude = [standardDefaults floatForKey:@"locationLongitude"];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = currentWorkLocation;
        annotation.title = @"I work here.";
        [workMap addAnnotation:annotation];
        
        MKCircle *workCircle = [MKCircle circleWithCenterCoordinate:currentWorkLocation radius:250];
        [self.workMap addOverlay:workCircle];
        
        self.workLocation = currentWorkLocation;
       
    }
    else
    {
         NSLog(@"work Location Not Found");
        //Alert the user to set a work location
        UIAlertView *workLocationAlert = [[UIAlertView alloc]initWithTitle:@"Work Location" message:@"Please  press at a location for 2 seconds to set it as your work location." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [workLocationAlert show];
        
    }
}


/*
    Function Name: handleLongPress: (UILongPressGestureRecognizer *) gestureRecogniser
    Params: UILongPressGestureRecognizer
    Output: void
*/
- (void) handleLongPress: (UILongPressGestureRecognizer *) gestureRecogniser
{
    //return if the gesture has not ended
    if (gestureRecogniser.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    
    //remove earlier annotations and overlays
    [self.workMap removeOverlays:self.workMap.overlays];
    [self.workMap removeAnnotations:self.workMap.annotations];
    
    //Get coordintaes for the touched location
    CGPoint touchPoint= [gestureRecogniser locationInView:workMap];
    self.workLocation= [workMap convertPoint:touchPoint toCoordinateFromView:workMap];
    NSLog(@"Location: %f", self.workLocation.latitude);
    NSLog(@"Location: %f", self.workLocation.longitude);
    
    //Add a pin to the location
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = self.workLocation;
    annotation.title = @"I work here.";
    [workMap addAnnotation:annotation];
    
    //Create a overlay circle to show the geofenced area around the location
    MKCircle *workCircle = [MKCircle circleWithCenterCoordinate:self.workLocation radius:250];
    [self.workMap addOverlay:workCircle];
    
    [self.useLocationButton setEnabled:YES];
}

//Delegate method for the mapview
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay
{
    MKCircleView* circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    return circleView;
}

//Delegate method for the mapview
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationIdentifier = @"Annotation";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

//Delegate method for the mapview
- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered work region");
    
    self.inDateTime = [NSDate date];
    
    //Create the dateformatter object
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    
    //Set the required date format
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    
    //Get the string date
    NSString* str = [formatter stringFromDate:self.inDateTime];
    
    //Display on the console
    NSLog(@"In Time:%@", str);
    
}

//Delegate method for the mapview
- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited work region");
    self.outDateTime = [NSDate date];
    
    //Create the dateformatter object
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    
    //Set the required date format
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    
    //Get the string date
    NSString* str = [formatter stringFromDate:self.outDateTime];
    
    //Display on the console
    NSLog(@"Out Time:%@", str);
    
    /*
     Set the in time to the time the location was set if the in time is nil
     Useful in cases where the user sets the location while at work
     */
    if (self.inDateTime == nil)
    {
        self.inDateTime = self.locationSetDateTime;
    }
    
    //persist the data once the user exits the work location
    [self saveWorkDayDetails];
}

/*
 Function Name: saveWorkDayDetails
 Persists the in and out timings
*/
- (void) saveWorkDayDetails
{
    //get the managedObjectContext from the app delegate instance
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    //Use dateFormatter to get String values for in time, out time and hours spent
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    NSString *workDateString = [dateFormatter stringFromDate: self.inDateTime];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    NSString *inTimeString = [timeFormatter stringFromDate: self.inDateTime];
    NSString *outTimeString = [timeFormatter stringFromDate: self.outDateTime];
    
    NSTimeInterval timeInterval = [self.outDateTime timeIntervalSinceDate:self.inDateTime];
    NSNumber *hours = [NSNumber numberWithDouble:timeInterval];
    NSString *hoursString = hours.stringValue;
    
    //Used the ManagedObject subclass to persist the properties
    WorkDay *newWorkDay = [NSEntityDescription insertNewObjectForEntityForName:@"WorkDay" inManagedObjectContext:context];
    newWorkDay.inTime = inTimeString;
    newWorkDay.outTime = outTimeString;
    newWorkDay.workDate = workDateString;
    newWorkDay.hoursSpent = hoursString;
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

/*
 Function Name: useLocation:(id)sender
 Adds the selected location as the desired work location and starts monitoring
 Params: sender, the button
 */
- (IBAction)useLocation:(id)sender
{
    self.locationSetDateTime = [NSDate date];
    
    //save the selected location in userDefaults
    standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setFloat:self.workLocation.latitude forKey:@"locationLatitude"];
    [standardDefaults setFloat:self.workLocation.longitude forKey:@"locationLongitude"];
    [standardDefaults setObject:self.locationSetDateTime forKey:@"locationSetDateTime"];
    
    //create a circular region around the location and start monitoring
    CLCircularRegion *circularRegion = [[CLCircularRegion alloc] initWithCenter:self.workLocation radius:250 identifier:@"WorkLocation"];
    [self.locationManager startMonitoringForRegion:(CLRegion *) circularRegion];
    
    //dismiss the view once the user has set the location
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotate
{
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
