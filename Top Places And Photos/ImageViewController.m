//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Aleksey on 5/11/16.
//  Copyright © 2016 Aleksey. All rights reserved.
//

#import "ImageViewController.h"
#import "RequestManager.h"
#import "FlickrFetcher.h"
#import "DataManager.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) RequestManager *requestManager;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

#pragma mark Setters & Getters

- (RequestManager *)requestManager
{
    if (!_requestManager) {
        _requestManager = [[RequestManager alloc] init];
    }
    return _requestManager;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.scrollView.zoomScale = 1.0;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    self.scrollView.contentSize = self.image.size; // self.image ? self.image.size : CGSizeZero;

    [self.spinner stopAnimating];
}

- (NSString *)navTitle
{
    if (!_navTitle) {
        _navTitle = @"";
    }
    return _navTitle;
}

- (void)fetchPhoto
{
    [self.spinner startAnimating];
    [self.requestManager getImageByPhoto:self.photo format:FlickrPhotoFormatLarge withCompletionBlock:^(id imageData) {
        self.image = [UIImage imageWithData:imageData];
    }];
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode
{
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
        self.navigationItem.leftBarButtonItem.title = self.splitViewController.viewControllers[0].title;
    }
}

#pragma mark viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    [self setupView];
}

- (void)setupView
{
    self.navigationItem.title = [NSString stringWithString:self.navTitle];
}
@end
