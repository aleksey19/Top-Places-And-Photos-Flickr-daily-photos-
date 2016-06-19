//
//  DataManager.m
//  Top Places And Photos
//
//  Created by Aleksey on 6/17/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation DataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)savePhoto:(id)photo
{
    NSMutableArray *photos = [[NSMutableArray alloc] initWithArray:[self.userDefaults valueForKey:@"photos"]];

    if (!photos) {
        photos = [NSMutableArray new];
        [photos addObject:photo];
        [self.userDefaults setValue:photos forKey:@"photos"];
    }
    else if (photos.count < 50) {
        [photos addObject:photo];
        [self.userDefaults setValue:photos forKey:@"photos"];
    }
}

- (NSArray *)retrievePhotos
{
    NSArray *photos = [NSArray arrayWithArray:[self.userDefaults valueForKey:@"photos"]];
    return photos;
}

@end
