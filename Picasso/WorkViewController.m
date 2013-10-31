//
//  WorkViewController.m
//  Picasso
//
//  Created by Julian on 29/10/2013.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "WorkViewController.h"
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

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //DataManager *dataManager = [DataManager sharedInstance];
    //WorkModel *workModel = [dataManager getWorkWithNumber:self.workId];
    
    isFullScreen = FALSE;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
