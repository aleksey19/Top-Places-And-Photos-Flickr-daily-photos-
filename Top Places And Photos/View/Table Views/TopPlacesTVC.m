//
//  TopPlacesTVC.m
//  Top Places And Photos
//
//  Created by Aleksey on 5/17/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "RequestManager.h"
#import "FlickrFetcher.h"
#import "PhotosTVC.h"

@interface TopPlacesTVC ()
@property (nonatomic, strong) RequestManager *requestManager;

@property (nonatomic, strong) NSDictionary *places;
@property (nonatomic, strong) NSArray *allContries;

@property (weak, nonatomic) IBOutlet UIRefreshControl *spinner;
@end
@implementation TopPlacesTVC

#pragma mark Setters & Getters

// Request manager which requests info
- (RequestManager *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[RequestManager alloc] init];
    }
    return _requestManager;
}

// allContries array keeps inside names of all countries which was requested
// needed for displaying sections
- (NSArray *)allContries
{
    if (!_allContries) {
        _allContries = [[self.places allKeys] copy];
        _allContries = [_allContries sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return _allContries;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.places count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.allContries[section];
    return [[self.places valueForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Top Place Cell"];
    cell.textLabel.text = [[[self.places valueForKey:self.allContries[indexPath.section]] objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PLACE_CITY_NAME];
    cell.detailTextLabel.text = [[[self.places valueForKey:self.allContries[indexPath.section]] objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PLACE_REGION_NAME];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.allContries[section];
}

#pragma mark prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // show photo on click
    if ([segue.identifier isEqualToString:@"Detail Photos"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotosTVC class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            PhotosTVC *destTVC = (PhotosTVC *)segue.destinationViewController;
            destTVC.navTitle = [[[self.places valueForKey:self.allContries[indexPath.section]] objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PLACE_CITY_NAME];
            destTVC.place = [[self.places valueForKey:self.allContries[indexPath.section]] objectAtIndex:indexPath.row];
            [destTVC fetchPhotos];            
        }
    }
}

#pragma mark viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchTopPlaces];
    [self setupView];
}

- (void)setupView
{
    self.title = @"Top Places";
}

- (IBAction)fetchTopPlaces
{
    [self.spinner beginRefreshing];
    [self.requestManager getCountriesWithCompletionBlock:^(NSDictionary *places)
    {
        self.places = places;
        [self.spinner endRefreshing];
        [self.tableView reloadData];
    }];
}

@end
