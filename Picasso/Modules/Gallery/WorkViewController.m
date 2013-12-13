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
#import "NavigationBarView.h"
#import "StatsFooterView.h"
#import "DataManager.h"
#import "SceneManager.h"
#import "TextUtils.h"

@interface WorkViewController ()

@property (nonatomic, assign) CGRect deviceSize;
@property (nonatomic, strong) DataManager *datamanager;
@property (nonatomic, strong) WorkModel *work;
@property (nonatomic, assign) int scrollViewSize;
@property (strong, nonatomic) NavigationBarView *navigationBar;
@property (strong, nonatomic) StatsFooterView *statsFooterView;

@end

@implementation WorkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        WorkFullViewController *workFullViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkFullViewController"];
        workFullViewController.workId = self.workId;
        workFullViewController.showExploreButton = self.showExploreButton;
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

    _datamanager = [DataManager sharedInstance];
    _work = [_datamanager getWorkWithNumber:self.workId];
    
    _navBarMiniWorkView.layer.borderColor = [UIColor blackColor].CGColor;
    _navBarMiniWorkView.layer.borderWidth = 2.0f;
    
    NSString *imageName = [NSString stringWithFormat: @"%d.jpg", self.workId];
    _workImage.image = [self imageWithImage:[UIImage imageNamed:imageName] scaledToWidth:self.deviceSize.size.width];
    [_workImage setClipsToBounds:YES];
    _workImage.contentMode = UIViewContentModeTop;
    _workImage.userInteractionEnabled = YES;
    _workImage.layer.zPosition = 1;
    CGRect workImageFrame = _workImage.frame;
    workImageFrame.size.height = _workImage.image.size.height;
    _workImage.frame = workImageFrame;
    
    _scrollViewSize = _workImage.frame.size.height;
    _scrollViewSize += 100;
    
    CGRect headerWorkViewFrame = _headerWorkView.frame;
    headerWorkViewFrame.origin.y = _scrollViewSize;
    _headerWorkView.frame = headerWorkViewFrame;
    
    _scrollViewSize += _headerWorkView.frame.size.height;
    _scrollViewSize += 25;
    
    CGRect descriptionWorkFrame = _descriptionWorkView.frame;
    descriptionWorkFrame.origin.y = _scrollViewSize;
    _descriptionWorkView.frame = descriptionWorkFrame;
    _descriptionWorkView.userInteractionEnabled = NO;
    _descriptionWorkView.font = [UIFont fontWithName:@"AvenirLTStd-Light" size:13];
    _descriptionWorkView.attributedText = [TextUtils getKernedString:_work.description];
    _descriptionWorkView.layoutManager.delegate = self;
    _descriptionWorkView.textAlignment = NSTextAlignmentJustified;
    [self updateTextViewHeight:_descriptionWorkView];
    
    _scrollViewSize += _descriptionWorkView.frame.size.height;
    _scrollViewSize += 25;
    
    CGRect textWorkViewFrame = _textWorkView.frame;
    textWorkViewFrame.origin.y = _scrollViewSize;
    _textWorkView.frame = textWorkViewFrame;
    
    _scrollViewSize += _textWorkView.frame.size.height;
    _scrollViewSize += 25;
    
    CGRect creditWorkViewFrame = _creditWorkView.frame;
    creditWorkViewFrame.origin.y = _scrollViewSize;
    _creditWorkView.frame = creditWorkViewFrame;
    
    _titleMiniWorkLabel.attributedText = [TextUtils getKernedString:[_work.title uppercaseString]];
    _titleMiniWorkLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:10];
    _dateMiniWorkLabel.attributedText = [TextUtils getKernedString:_work.year];
    _dateMiniWorkLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:10];
    
    _titleWorkLabel.attributedText = [TextUtils getKernedString:[_work.title  uppercaseString]];
    _titleWorkLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Medium" size:14];
    _numberWorkLabel.attributedText = [TextUtils getKernedString:[NSString stringWithFormat:@"n°00%ld", (long)_work.workId + 1]];
    
    _textTitleLabel.attributedText = [TextUtils getKernedString:_work.place];
    _hWorkLabel.attributedText = [TextUtils getKernedString:_work.h];
    _lWorkLabel.attributedText = [TextUtils getKernedString:_work.l];
    _materialWorkLabel.attributedText = [TextUtils getKernedString:_work.technical];
    
    _scrollViewSize += 100;
    
    _contentWorkView.delegate = self;
    [_contentWorkView setContentSize:(CGSizeMake(self.deviceSize.size.width, _scrollViewSize))];
    
    [self initNavigationBar];
    [self initStatsFooter];
}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 20, [OrientationUtils nativeDeviceSize].size.width, 20) andTitle:@"Galerie" andShowExploreButton:self.showExploreButton];
    [self.view addSubview:self.navigationBar];
    
    [self.navigationBar.backButton setImage:[UIImage imageNamed:@"navBackButton.png"] forState:UIControlStateNormal];
    [self.navigationBar.backButton addTarget:self action:@selector(backToGallery) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.showExploreButton) {
        [self.navigationBar.exploreButton addTarget:self action:@selector(backToScene) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)initStatsFooter {
    self.statsFooterView = [[StatsFooterView alloc] initWithFrame:CGRectMake(0, [OrientationUtils nativeDeviceSize].size.height - 20, [OrientationUtils nativeDeviceSize].size.width, 20)];
    [self.view addSubview:self.statsFooterView];
    [self.view bringSubviewToFront:self.statsFooterView];
}

- (void)backToGallery {
    GalleryViewController *galleryView = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
    [self.navigationController pushViewController:galleryView animated:NO];
}

- (void)backToScene {
    SceneManager *sceneManager = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
    sceneManager.shouldResume = YES;
    [self.navigationController pushViewController:sceneManager animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //CGPoint contentOffset = _contentWorkView.contentOffset;
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

- (UIImage*)imageWithImage:(UIImage*) sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 5;
}
@end
