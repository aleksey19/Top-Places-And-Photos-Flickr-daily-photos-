//
//  RequestManager+Sorter.m
//  Top Places And Photos
//
//  Created by Aleksey on 5/21/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "RequestManager+Sorter.h"
#import "FlickrFetcher.h"

@implementation RequestManager (Sorter)

- (void)sortTopPlacesByContriesInArray:(NSMutableArray *)topPlaces withCompletion:(CompletionBlock)completion
{
    NSMutableDictionary *sortedPlacesByContries = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
#warning Sometimes occurs: [NSNull length]: unrecognized selector sent to instance [NSTaggedPointerString isEqualToString:]
    if (topPlaces) {
        for (int i = 0; i < topPlaces.count; i++)
        {
            NSString *country = [topPlaces[i] valueForKeyPath:FLICKR_PLACE_COUNTRY_NAME];
            
            if (i == 0) {
                [arrayTemp addObject:topPlaces[i]];
            } else if ([country isEqualToString:[topPlaces[i - 1] valueForKeyPath:FLICKR_PLACE_COUNTRY_NAME]]) {
                [arrayTemp addObject:topPlaces[i]];
            } else {
                [sortedPlacesByContries setObject:[arrayTemp copy] forKey:[topPlaces[i - 1] valueForKeyPath:FLICKR_PLACE_COUNTRY_NAME]];
                [arrayTemp removeAllObjects];
                
                [arrayTemp addObject:topPlaces[i]];
            }
            if (i == topPlaces.count - 1) {
                [sortedPlacesByContries setObject:arrayTemp forKey:[topPlaces[i] valueForKeyPath:FLICKR_PLACE_COUNTRY_NAME]];
                arrayTemp = nil;
            }
        }
    }
    
    completion(sortedPlacesByContries);
}

@end
