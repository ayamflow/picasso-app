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
            prevFrame = self.workImage.frame;
            CGRect fullWorkImageFrame = CGRectMake(0, 80, deviceSize.size.width, deviceSize.size.height);
            [self.workImage setFrame:fullWorkImageFrame];
        }completion:^(BOOL finished){
            _workContent.userInteractionEnabled = FALSE;
            isFullScreen = TRUE;
        }];
        return;
    }
}

- (void)imgToMini:(UISwipeGestureRecognizer*)sender {
    if (isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [self.workImage setFrame:prevFrame];
        }completion:^(BOOL finished){
            _workContent.userInteractionEnabled = TRUE;
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
