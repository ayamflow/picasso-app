//
//  WorkViewController.m
//  Picasso
//
//  Created by Julian on 29/10/2013.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorkViewController.h"
#import "WorkFullViewController.h"
#import "GalleryViewController.h"
#import "OrientationUtils.h"
#import "Colors.h"
#import "WorkModel.h"
#import "DataManager.h"

@interface WorkViewController ()


@end

@implementation WorkViewController

CGRect deviceSize;
UIImageView *workImage;
CGRect fullWorkImageFrame;
bool isFullWorkView;

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        WorkFullViewController *workFullViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkFullViewController"];
        workFullViewController.workId = self.workId;
        [self.navigationController pushViewController:workFullViewController animated:YES];
    }
}

- (void)goToGallery:(UITouch*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fullWorkView:(UISwipeGestureRecognizer*)sender {
    if(!isFullWorkView) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [workImage setFrame:fullWorkImageFrame];
        }completion:^(BOOL finished){
            isFullWorkView = YES;
        }];
        [UIView animateWithDuration:0.9 delay:0 options:0 animations:^{
            [self.workNavigation setFrame:CGRectMake(20, 502, 280, 66)];
        }completion:NO];
        return;
    }
}

- (void)partWorkView:(UISwipeGestureRecognizer*)sender {
    if(isFullWorkView) {
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            [workImage setFrame:CGRectMake(20, 55, 280, 180)];
        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
                [workImage setFrame:CGRectMake(0, 55, deviceSize.size.width, 180)];
            }completion:^(BOOL finished){
                isFullWorkView = NO;
            }];
        }];
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [self.workNavigation setFrame:CGRectMake(20, 55, 280, 66)];
        }completion:NO];
        return;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    deviceSize = [OrientationUtils deviceSize];
    self.navigationController.navigationBarHidden = YES;
    
    _navigationBar.layer.borderColor = [UIColor blackColor].CGColor;
    _navigationBar.layer.borderWidth = 2.0f;
    
    NSString *imageUrl = [NSString stringWithFormat: @"%d.jpg", self.workId];
    workImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageUrl]];
    
    workImage.contentMode = UIViewContentModeTop;
    workImage.userInteractionEnabled = YES;
    workImage.layer.zPosition = 1;

    fullWorkImageFrame = CGRectMake(20, 120, 280, 380);
    [workImage setFrame:fullWorkImageFrame];
    [workImage setClipsToBounds:YES];
    [self.view addSubview:workImage];
    
    isFullWorkView = YES;
    
    self.workNavigation.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipeDownWorkImage = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fullWorkView:)];
    [swipeDownWorkImage setDirection:UISwipeGestureRecognizerDirectionDown];
    [workImage addGestureRecognizer:swipeDownWorkImage];
    
    UISwipeGestureRecognizer *swipeDownWorkImageButton = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(fullWorkView:)];
    [swipeDownWorkImageButton setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.workNavigation addGestureRecognizer:swipeDownWorkImageButton];
    
    UISwipeGestureRecognizer *swipeUpWorkImage = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(partWorkView:)];
    [swipeUpWorkImage setDirection:UISwipeGestureRecognizerDirectionUp];
    [workImage addGestureRecognizer:swipeUpWorkImage];
    
    UISwipeGestureRecognizer *swipeUpWorkImageButton = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(partWorkView:)];
    [swipeUpWorkImageButton setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.workNavigation addGestureRecognizer:swipeUpWorkImageButton];
    
    UITapGestureRecognizer *tapGallery = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToGallery:)];
    _comeBackGallery.userInteractionEnabled = YES;
    [self.comeBackGallery addGestureRecognizer:tapGallery];
    
    [self.workContent loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"workContent" ofType:@"html"]isDirectory:NO]]];
}

-(void)viewDidAppear:(BOOL)animated
{
    WorkModel *workModel = [[[DataManager sharedInstance] getWorkWithNumber:self.workId] init];
    NSString *script = [NSString stringWithFormat:@"fillData('%@','%@','%@','%@','%@')", workModel.title, workModel.h, workModel.l, workModel.technical, workModel.description];
    [self.workContent stringByEvaluatingJavaScriptFromString:script];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
