//
//  ListTableViewController.m
//  WorkTimer
//
//  Created by Sagar Patkar on 9/17/15.
//  Copyright (c) 2015 Sagar Patkar. All rights reserved.
//

#import "ListTableViewController.h"
#import <CoreData/CoreData.h>
#import "WorkDay.h"

@interface ListTableViewController ()

@property (strong) NSMutableArray *workdays;

@end

@implementation ListTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //format the navigation bar
    [self.navigationItem setTitle:@"List"];
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
    
    //setup the managed object context
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSManagedObjectModel *managedObjectModel = [[managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSDictionary *entities = [managedObjectModel entitiesByName];
    NSArray *entityNames = [entities allKeys];
    NSLog(@"All loaded entities are: %@", entityNames);
    
    //create a fetch request and get data to load in the tableView
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"WorkDay"];
    self.workdays = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Function to get insatnce of Managed Object Context
- (NSManagedObjectContext *) managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"Number of rows are %lu", (unsigned long)self.workdays.count);
    return self.workdays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell with details from the managed object
    WorkDay *workDay = [self.workdays objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"Date:%@", workDay.workDate]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"In:%@     Out:%@", workDay.inTime, workDay.outTime]];
    
    return cell;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

@end
