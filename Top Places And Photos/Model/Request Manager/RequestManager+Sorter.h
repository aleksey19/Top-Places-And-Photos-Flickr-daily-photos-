//
//  RequestManager+Sorter.h
//  Top Places And Photos
//
//  Created by Aleksey on 5/21/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "RequestManager.h"

@interface RequestManager (Sorter)

- (void)sortTopPlacesByContriesInArray:(NSMutableArray *)topPlaces withCompletion:(CompletionBlock)completion;
@end
