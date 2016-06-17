//
//  RequestManager.m
//  Top Places And Photos
//
//  Created by Aleksey on 5/17/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "RequestManager.h"
#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"
#import "RequestManager+Sorter.h"

@interface RequestManager ()
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *placesInfo;
@end

@implementation RequestManager

- (NSMutableArray *)placesInfo
{
    if (!_placesInfo) {
        _placesInfo = [NSMutableArray array];
    }
    return _placesInfo;
}

- (void)getCountriesWithCompletionBlock:(CompletionBlock)completion;
{
    [self requestAndSortTopPlacesWithInfoWithCompletion:completion];
    
    // group array of places by contries and put into dictionary with key = "contry" and value = dictionary with place content    
}

- (void)requestAndSortTopPlacesWithInfoWithCompletion:(CompletionBlock)completion
{
    self.url = [FlickrFetcher URLforTopPlaces];
#warning Check For leaks OF Info!
    [self.placesInfo removeAllObjects];
    
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetch places", NULL);
    dispatch_async(fetchQ, ^{
        
        NSData *jsonResultData = [NSData dataWithContentsOfURL:self.url];
        NSDictionary *propertyListResult = [NSJSONSerialization JSONObjectWithData:jsonResultData
                                                                           options:0
                                                                             error:NULL];
        NSArray *places = [propertyListResult valueForKeyPath:FLICKR_RESULTS_PLACES];
        
        for (int i = 0; i < places.count; i++) {
            
            dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
            dispatch_async(queue, ^{
                self.url = [FlickrFetcher URLforInformationAboutPlace:[places[i] valueForKey:FLICKR_PLACE_ID]];
                
                NSData *jsonResData = [NSData dataWithContentsOfURL:self.url];
                NSDictionary *placeInfoListResult = [NSJSONSerialization JSONObjectWithData:jsonResData options:0 error:NULL];
#warning *** set a breakpoint in malloc_error_break to debug 
#warning [self.placesInfo addObject:placeInfoListResult];
                [self.placesInfo addObject:placeInfoListResult];
                
                if (self.placesInfo.count == places.count)
                {
                    [self sortArrayOfPlaces:self.placesInfo];
                    [self sortTopPlacesByContriesInArray:self.placesInfo withCompletion:completion];
                }
            });
        }
    });
    
    // sort places by contries
}

// sort cities by contry name: FLICKR_PLACE_COUNTRY_NAME
- (void)sortArrayOfPlaces:(NSArray *)unSortesArray
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PLACE_COUNTRY_NAME ascending:YES];
    NSArray *sortDescriptor = [NSArray arrayWithObject:descriptor];
    self.placesInfo = [NSMutableArray arrayWithArray:[unSortesArray sortedArrayUsingDescriptors:sortDescriptor]];
    
    //    NSLog(@"%@", self.placesInfo);
}

- (void)requestPhotosForTopPlace:(id)place withCompletionBlock:(CompletionBlockWithArray)completion
{
    self.url = [FlickrFetcher URLforPhotosInPlace:[place valueForKey:@"woeid"] maxResults:50];
    dispatch_queue_t queue = dispatch_queue_create("flickr fetch photos for place", NULL);
    dispatch_async(queue, ^{
        NSData *jsonResultData = [NSData dataWithContentsOfURL:self.url];
        NSDictionary *propertyListResult = [NSJSONSerialization JSONObjectWithData:jsonResultData options:0 error:NULL];
        NSArray *photos = [propertyListResult valueForKeyPath:@"photos.photo"];
        completion(photos);
    });
}

- (void)getImageByPhoto:(id)photo format:(FlickrPhotoFormat)format withCompletionBlock:(CompletionBlockWithImage)completion;
{
    self.url = [FlickrFetcher URLforPhoto:photo format:format];
    dispatch_queue_t queue = dispatch_queue_create("flickr fetch image for photo", NULL);
    dispatch_async(queue, ^{
        NSData *jsonResultData = [NSData dataWithContentsOfURL:self.url];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonResultData);
        });
    });
}

@end
