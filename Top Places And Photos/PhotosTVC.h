//
//  PhotosTVC.h
//  Top Places And Photos
//
//  Created by Aleksey on 5/22/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIRefreshControl *spinner;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) id place;

- (void)setupView;
- (IBAction)fetchPhotos;


@end
