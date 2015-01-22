//
//  HomeViewController.m
//  Weather Demo
//
//  Created by Brandon Trebitowski on 1/21/15.
//  Copyright (c) 2015 Pixegon. All rights reserved.
//

#import "HomeViewController.h"
#import "MFSideMenu.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

// Core Data
#import "NSMOCManager.h"
#import "Weather.h"

#define kAPIEndpoint @"http://api.openweathermap.org/data/2.5/weather?q=Albuquerque,NM"

@interface HomeViewController ()
@property(nonatomic, weak) IBOutlet UILabel *locationLabel;
@property(nonatomic, weak) IBOutlet UILabel *tempLabel;
@property(nonatomic, weak) IBOutlet UIImageView *iconImageView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Current Weather";
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Update the weather everytime this screen is shown
    [self fetchCurrentWeather];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRightMenuButtonTapped:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{}];
}

- (void) fetchCurrentWeather {
    // Perform a GET on the weather API
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kAPIEndpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\nJSON Weather:\n %@", responseObject);
        
        // Update the UI
        float tempInKelvin = [responseObject[@"main"][@"temp"] floatValue];
        float tempInF = (tempInKelvin - 273.15) * 1.8 + 32;
        self.locationLabel.text = responseObject[@"name"];
        self.tempLabel.text = [NSString stringWithFormat:@"%.2f°f",tempInF];
        
        // Remotely fetch the image
        NSString *imageURLString = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",responseObject[@"weather"][0][@"icon"]];
        NSURL *url = [NSURL URLWithString:imageURLString];
        [self.iconImageView sd_setImageWithURL:url placeholderImage:nil];
        
        // Check to see if the record exists. key on dt
        NSNumber *dt = responseObject[@"dt"];
        NSManagedObjectContext *context = [[NSMOCManager sharedManager] managedObjectContext];
        
        // Create the fetch request
        NSError *error = nil;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"dt = %@", dt]];
        [request setFetchLimit:1];
        NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
        
        Weather *weather = nil;
        // Count will be 0 if the record doesn't exist
        if(fetchedObjects.count == 0) {
            // Create a new record
            weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather"
                                                             inManagedObjectContext:context];
        } else {
            weather = fetchedObjects.firstObject;
        }
        
        weather.temperature = responseObject[@"main"][@"temp"];
        weather.location = responseObject[@"name"];
        weather.icon = imageURLString;
        weather.dt = dt;
        NSError *aerror = nil;
        [context save:&aerror];
        
        if(aerror) {
            NSLog(@"Error saving weather info: %@", aerror);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
