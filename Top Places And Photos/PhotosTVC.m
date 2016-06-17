//
//  PhotosTVC.m
//  Top Places And Photos
//
//  Created by Aleksey on 5/22/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "PhotosTVC.h"
#import "RequestManager.h"
#import "ImageViewController.h"

@interface PhotosTVC ()
@property (nonatomic, strong) RequestManager *requestManager;
@end

@implementation PhotosTVC

- (RequestManager *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[RequestManager alloc] init];
    }
    return _requestManager;
}

- (NSString *)navTitle
{
    if (!_navTitle) {
        _navTitle = @"";
    }
    
    return _navTitle;
}

- (IBAction)fetchPhotos
{
    [self.spinner beginRefreshing];
    [self.requestManager requestPhotosForTopPlace:[self.place valueForKey:@"place"] withCompletionBlock:^(NSArray *array) {
        self.photos = array;
        [self.spinner endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = [NSString stringWithString:self.navTitle];
}

- (void)setupView
{
    self.navigationItem.title = [NSString stringWithString:self.navTitle];
//    self.navigationController.title = @"Title";
//    self.navigationController.topViewController.title = @"Title";
    [self.tableView reloadData];
}

#pragma mark prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // show photo on click
    if ([segue.identifier isEqualToString:@"Photo Detail"]) {
        if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            ImageViewController *destIVC = (ImageViewController *)segue.destinationViewController;
            destIVC.navTitle = [[self.photos objectAtIndex:indexPath.row] valueForKey:@"title"];
            destIVC.photo = [self.photos objectAtIndex:indexPath.row];
            [destIVC fetchPhoto];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo Cell"];
    
    cell.textLabel.text = [self.photos[indexPath.row] valueForKey:@"title"];
    
    if ([cell.textLabel.text isEqualToString:@""]) {
        cell.textLabel.text = @"no photo title";
    }
    
    return cell;
}

@end
