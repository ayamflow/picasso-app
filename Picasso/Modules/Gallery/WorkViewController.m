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

@property (nonatomic, assign) CGRect deviceSize;
@property (nonatomic, assign) bool isFullWorkView;
@property (nonatomic, strong) DataManager *datamanager;
@property (nonatomic, strong) WorkModel *work;

@end

@implementation WorkViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _deviceSize = [OrientationUtils deviceSize];
    self.navigationController.navigationBarHidden = YES;

    _datamanager = [[DataManager sharedInstance] init];
    _work = [_datamanager getWorkWithNumber:self.workId];
    
    NSString *imageName = [NSString stringWithFormat: @"%d.jpg", self.workId];
    _workImage.image = [UIImage imageNamed:imageName];
    [_workImage setClipsToBounds:YES];
    _workImage.contentMode = UIViewContentModeTop;
    _workImage.userInteractionEnabled = YES;
    _workImage.layer.zPosition = 1;
    
    CGSize contentSize = self.contentWorkView.frame.size;
    
    _contentWorkView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentWorkView.contentSize = contentSize;
    
    _descriptionWorkView.userInteractionEnabled = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    _titleWorkLabel.text = [_work.title  uppercaseString];
    _numberWorkLabel.text = [NSString stringWithFormat:@"n°00%ld", (long)_work.workId + 1];
    _descriptionWorkView.text = _work.description;
    [self updateTextViewHeight:_descriptionWorkView];
    
    _textWorkView.frame = CGRectMake(20, _descriptionWorkView.frame.origin.y + _descriptionWorkView.frame.size.height + 40, _textWorkView.frame.size.width, _textWorkView.frame.size.height);
    _creditWorkView.frame = CGRectMake(20, _textWorkView.frame.origin.y + _textWorkView.frame.size.height + 30, _creditWorkView.frame.size.width, _creditWorkView.frame.size.height);
    
    [self updateScrollViewHeight:_contentWorkView];
    
    _workImage.frame = _contentWorkView.frame;
    [_contentWorkView setContentSize:_workImage.frame.size];

}

- (void)updateTextViewHeight:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)updateScrollViewHeight:(UIScrollView *)scrollView
{
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
