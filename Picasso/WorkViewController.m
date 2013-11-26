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
@property (weak, nonatomic) IBOutlet UIView *scrollViewContent;

@end

@implementation WorkViewController

CGRect deviceSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        WorkFullViewController *workFullViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkFullViewController"];
        workFullViewController.workId = self.workId;
        [self.navigationController pushViewController:workFullViewController animated:YES];
    }
}

- (void)imgToFullScreen:(UISwipeGestureRecognizer*)sender {
    if (!isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            prevFrame = self.workImage.frame;
            CGRect fullWorkImageFrame = CGRectMake(0, 80, deviceSize.size.width, deviceSize.size.height);
            [self.workImage setFrame:fullWorkImageFrame];
        }completion:^(BOOL finished){
            self.workContent.userInteractionEnabled = NO;
            isFullScreen = TRUE;
        }];
        return;
    }
}

- (void)imgToMini:(UISwipeGestureRecognizer*)sender {
    NSLog(@"imgtomini");
    if (isFullScreen) {
        NSLog(@"is full screen");
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [self.workImage setFrame:prevFrame];
        }completion:^(BOOL finished){
            self.workContent.userInteractionEnabled = YES;
            isFullScreen = NO;
        }];
        return;
    }
}

- (void)goToGallery:(UITouch*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    deviceSize = [OrientationUtils deviceSize];
    _navigationBar.backgroundColor = [UIColor textColor];
    
    WorkModel *workModel = [[[DataManager sharedInstance] getWorkWithNumber:self.workId] init];
    
    isFullScreen = FALSE;
    
    self.navigationController.navigationBarHidden = YES;
    
    _workImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.workImage setClipsToBounds:YES];
    _workImage.userInteractionEnabled = YES;
    NSString *imageUrl = [NSString stringWithFormat: @"%d.jpg", self.workId];
    _workImage.image = [UIImage imageNamed:imageUrl];
    _workImage.layer.zPosition = 1;
    
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imgToMini:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    [self.workImage addGestureRecognizer:swipeDown];
    [self.workImage addGestureRecognizer:swipeUp];
    
    touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToGallery:)];
    _comebackGallery.userInteractionEnabled = YES;
    [self.comebackGallery addGestureRecognizer:touch];
    
    [self.workContent setDelegate:self];
    _workContent.userInteractionEnabled = YES;
    _workContent.scrollEnabled = YES;
    
    _workTitle.text = (NSString *)[workModel title];
    _workTitle.textColor = [UIColor textColor];
    
    _workYear.text = (NSString *)[workModel year];
    _workYear.textColor = [UIColor textColor];
    
    _workL.text = (NSString *)[@"L: " stringByAppendingString:(NSString *)[workModel l]];
    _workH.text = (NSString *)[@"H: " stringByAppendingString:(NSString *)[workModel h]];
    
    _workTechnical.text = (NSString *)[workModel technical];
    
    _workDescription.text = (NSString *)[workModel description];
    _workDescription.textColor = [UIColor blackColor];
//    _workDescription.scrollEnabled = NO;
    
//    CGSize descriptionSize = [_workDescription sizeThatFits:CGSizeMake(320, 5000)];
    
//    _workDescription.bounds = CGRectMake(0, 0, descriptionSize.width, descriptionSize.height);
    
    NSLog(NSStringFromCGRect(_workDescription.frame));
    
    _workContent.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollViewContent.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_scrollViewContent, _workContent);
    [_workContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollViewContent]|" options:0 metrics: 0 views:viewsDictionary]];
    [_workContent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollViewContent]|" options:0 metrics: 0 views:viewsDictionary]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
