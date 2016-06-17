//
//  RequestManager.h
//  Top Places And Photos
//
//  Created by Aleksey on 5/17/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FlickrFetcher.h"

typedef void(^CompletionBlockWithImage)(id imageData);
typedef void(^CompletionBlock)(NSDictionary *dict);
typedef void(^CompletionBlockWithArray)(NSArray *array);

@interface RequestManager : NSObject

- (void)getCountriesWithCompletionBlock:(CompletionBlock)completion;
- (void)requestPhotosForTopPlace:(id)place withCompletionBlock:(CompletionBlockWithArray)completion;
- (void)getImageByPhoto:(id)photo format:(FlickrPhotoFormat)format withCompletionBlock:(CompletionBlockWithImage)completion;

@end
