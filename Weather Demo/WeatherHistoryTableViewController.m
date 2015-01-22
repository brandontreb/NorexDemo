//
//  WeatherHistoryTableViewController.m
//  Weather Demo
//
//  Created by Brandon Trebitowski on 1/22/15.
//  Copyright (c) 2015 Pixegon. All rights reserved.
//

#import "WeatherHistoryTableViewController.h"
#import "Weather.h"
#import "NSMOCManager.h"
#import <CoreData/CoreData.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MFSideMenu.h"

@interface WeatherHistoryTableViewController ()<NSFetchedResultsControllerDelegate>
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation WeatherHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Weather History";
    
    // Set up a date formatter
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Weather *weather = [self.fetchedResultsController objectAtIndexPath:indexPath];
    float tempInF = ([weather.temperature floatValue] - 273.15) * 1.8 + 32;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[weather.dt floatValue]];
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:date];
    cell.textLabel.text = [NSString stringWithFormat:@"%.2f°f",tempInF];
//    cell.detailTextLabel.text = weather.location;
    NSURL *url = [NSURL URLWithString:weather.icon];
    [cell.imageView sd_setImageWithURL:url placeholderImage:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.fetchedResultsController sections][section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

// NSFetchedResultsControllerDelegate
// Placeholders for the fetched results controller delegate methods
//
// Platform: iOS
// Language: Objective-C
// Completion Scope: Class Implementation

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        // Set up the fetch
        NSManagedObjectContext *moc = [[NSMOCManager sharedManager ] managedObjectContext];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
        fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"dt" ascending:NO]];
        
        NSFetchedResultsController *fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                            managedObjectContext:moc
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];
        
        fetchedResultsController.delegate = self;
        self.fetchedResultsController = fetchedResultsController;
        
        // Perform the fetch
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error]) {
            NSLog(@"Error performing fetch %@ User Info: %@", error.localizedDescription, error.userInfo);
            abort();
        }
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch((NSInteger)type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - Actions

- (IBAction)showRightMenuButtonTapped:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{}];
}

@end
