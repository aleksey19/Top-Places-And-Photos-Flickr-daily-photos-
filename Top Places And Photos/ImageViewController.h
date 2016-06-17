//
//  ImageViewController.h
//  Imaginarium
//
//  Created by Aleksey on 5/11/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (nonatomic, strong) id photo;
@property (nonatomic, strong) NSString *navTitle;

- (void)fetchPhoto;

@end
