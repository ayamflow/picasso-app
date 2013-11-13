//
//  WorkViewController.m
//  Picasso
//
//  Created by Julian on 29/10/2013.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorkViewController.h"
#import "GalleryViewController.h"
#import "WorkModel.h"
#import "DataManager.h"

@interface WorkViewController ()

@end

@implementation WorkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)imgToFullScreen:(UISwipeGestureRecognizer*)sender {
    if (!isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
            prevFrame = self.workImage.frame;
            [self.workImage setFrame:[[UIScreen mainScreen] bounds]];
        }completion:^(BOOL finished){
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
            isFullScreen = FALSE;
        }];
        return;
    }
}

- (void)goToGallery:(UITouch*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WorkModel *workModel = [[[DataManager sharedInstance] getWorkWithNumber:self.workId] init];
    NSString *workDescription = [workModel description];
    
    isFullScreen = FALSE;
    
    self.navigationController.navigationBarHidden = YES;
    
    self.workImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.workImage setClipsToBounds:YES];
    self.workImage.userInteractionEnabled = YES;
    NSString *imageUrl = [NSString stringWithFormat: @"%d.jpg", self.workId];
    self.workImage.image = [UIImage imageNamed:imageUrl];
    self.workImage.layer.zPosition = 1;
    
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.workImage addGestureRecognizer:swipeDown];
    
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imgToMini:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.workImage addGestureRecognizer:swipeUp];
    
    touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToGallery:)];
    [self.workImage addGestureRecognizer:touch];
    
    UITextView *workTextContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    workTextContent.text = workDescription;
    workTextContent.textColor = [UIColor blackColor];
    [self.workContent addSubview:workTextContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
