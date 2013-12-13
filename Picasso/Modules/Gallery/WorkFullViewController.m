//
//  WorkFullViewController.m
//  Picasso
//
//  Created by RENARD Julian on 13/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "DataManager.h"
#import "WorkModel.h"
#import "QuestionModel.h"
#import "WorkFullViewController.h"
#import "WorkViewController.h"
#import "OrientationUtils.h"
#import "A3ParallaxScrollView.h"
#import "Colors.h"
#import "GalleryViewController.h"
#import "SceneManager.h"
#import "UIViewPicasso.h"
#import "TextUtils.h"

@interface WorkFullViewController ()

@property (nonatomic, strong) A3ParallaxScrollView *parallaxScrollView;
@property (nonatomic, strong) UIImageView *mapBackgroundView;
@property (nonatomic, strong) UIImageView *gridBackgroundView;
@property (nonatomic, strong) UIImageView *imageWorkView;
@property (nonatomic, strong) UITapGestureRecognizer *touchChoice1;
@property (nonatomic, strong) UITapGestureRecognizer *touchChoice2;
@property (nonatomic, strong) DataManager *datamanager;
@property (nonatomic, strong) WorkModel *work;
@property (nonatomic, strong) QuestionModel *question;
@property (nonatomic, assign) int parallaxY;
@property (nonatomic, assign) BOOL isQuestionDiscover;
@property (strong, nonatomic) NavigationBarView *navigationBar;

@end

@implementation WorkFullViewController

CGRect deviceSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        WorkViewController *workViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkViewController"];
        workViewController.workId = self.workId;
        workViewController.showExploreButton = self.showExploreButton;
        workViewController.didRotate = YES;
        [self.navigationController pushViewController:workViewController animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    deviceSize = [OrientationUtils deviceSize];
    
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:self.navigationBar.frame andTitle:@"Galerie" andShowExploreButton:self.showExploreButton];
    
    _datamanager = [DataManager sharedInstance];
    _work = [_datamanager getWorkWithNumber:self.workId];
    _question = [_datamanager getRandomQuestion];

    _parallaxScrollView = [[A3ParallaxScrollView alloc] initWithFrame:self.view.bounds];
    _parallaxScrollView.delegate = self;
    [self.view addSubview:self.parallaxScrollView];
    
    CGSize contentSize = self.parallaxScrollView.frame.size;
    
    // Update text
    _titleWorkLabel.attributedText = [TextUtils getKernedString:[_work.title  uppercaseString]];
    _titleWorkLabel.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:24];
    _numbersWorkLabel.attributedText = [TextUtils getKernedString:[[NSString stringWithFormat:@"%d / %d œuvres", MAX(0, [[[DataManager sharedInstance] getGameModel] lastUnlockedWork] + 1), [[DataManager sharedInstance] getWorksNumber]] uppercaseString]];
    [_numbersWorkLabel sizeToFit];
    _textTitleLabel.attributedText = [TextUtils getKernedString:_work.title];
    //[_textTitleLabel sizeToFit];
    _textTitleLabel.font = [UIFont fontWithName:@"AvenirLTStd-Heavy" size:10];
    _textHLabel.attributedText = [TextUtils getKernedString:_work.h];
    _textHLabel.font = [UIFont fontWithName:@"AvenirLTStd-Light" size:10];
    _textLLabel.attributedText = [TextUtils getKernedString:_work.l];
    _textLLabel.font = [UIFont fontWithName:@"AvenirLTStd-Light" size:10];
    _textTechniqueLabel.attributedText = [TextUtils getKernedString:_work.technical];
    _textTechniqueLabel.font = [UIFont fontWithName:@"AvenirLTStd-Light" size:10];
    //[_textTechniqueLabel sizeToFit];
    _textPlaceLabel.attributedText = [TextUtils getKernedString:_work.place];
    _textPlaceLabel.font = [UIFont fontWithName:@"AvenirLTStd-Light" size:10];
    
    _questionLabel.attributedText = [TextUtils getKernedString:[_question.question uppercaseString]];
    _choice1Label.attributedText = [TextUtils getKernedString:_question.choice_1];
    _choice2label.attributedText = [TextUtils getKernedString:_question.choice_2];
    _answerTextView.attributedText = [TextUtils getKernedString:_question.explanation];
    _questionLabel.font = _choice1Label.font = _choice2label.font = _answerTextView.font = [UIFont fontWithName:@"BrandonGrotesque-Regular" size:17];
    _answerTextView.alpha = 0.0f;
    
    _parallaxScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _parallaxScrollView.contentSize = contentSize;
    
    // Map background
    _mapBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"map-bg.png"]]];
    _mapBackgroundView.frame = CGRectMake(60, 65, 478, 408);
    [self.parallaxScrollView addSubview:_mapBackgroundView withAcceleration:CGPointMake(0.0f, 0.2f)];
    
    // Grid background
    _gridBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grid-bg.png"]]];
    _gridBackgroundView.frame = CGRectMake(0, 0, deviceSize.size.width, deviceSize.size.height);
    [self.parallaxScrollView addSubview:_gridBackgroundView withAcceleration:CGPointMake(0.0f, 0.1f)];
    
    // Title view
    _titleLabel.layer.zPosition = 1;
    [self.parallaxScrollView addSubview:_titleLabel withAcceleration:CGPointMake(0.0f, 0.6f)];
    
    // Work header
    _headerView.layer.zPosition = 1;
    [self.parallaxScrollView addSubview:_headerView withAcceleration:CGPointMake(0.0f, 0.5f)];
    
    // Work image
    _imageWorkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat: @"%d.jpg", _workId]]];
    _imageWorkView.frame = CGRectMake(60, deviceSize.size.height + 50, _imageWorkView.frame.size.width/2, _imageWorkView.frame.size.height/2);
    
    [_imageWorkView.layer setBorderColor: [[UIColor textColor] CGColor]];
    [_imageWorkView.layer setBorderWidth: 20.0];
    _imageWorkView.layer.zPosition = 1;
    [self.parallaxScrollView addSubview:_imageWorkView withAcceleration:CGPointMake(0.0f, 0.4f)];
    
    // Text work view
    _textWorkView.frame = CGRectMake(_imageWorkView.frame.origin.x + _imageWorkView.frame.size.width, _imageWorkView.frame.origin.y + ( _imageWorkView.frame.size.height/2 - (170/2) ), 200, 150);
    _textWorkView.backgroundColor = [UIColor whiteColor];
    _textWorkView.layer.masksToBounds = NO;
    _textWorkView.layer.shadowOffset = CGSizeMake(5, 5);
    _textWorkView.layer.shadowRadius = 5;
    _textWorkView.layer.shadowOpacity = 0.1;
    [self.parallaxScrollView addSubview:_textWorkView withAcceleration:CGPointMake(0.0f, 0.5f)];
    _parallaxY = _textWorkView.frame.origin.y + _textWorkView.frame.size.height;
    
    // Description work view

    _viewDescription.frame = CGRectMake(100, _imageWorkView.frame.origin.y + _imageWorkView.frame.size.height, 460, 0);
    _descriptionWorkView.frame = CGRectMake(30, _descriptionWorkView.frame.origin.y, 400, 0);
    _viewDescription.backgroundColor = [UIColor whiteColor];
    _viewDescription.layer.masksToBounds = NO;
    _viewDescription.layer.shadowRadius = 5;
    _viewDescription.layer.shadowOpacity = 0.1;
    _descriptionWorkView.attributedText = [TextUtils getKernedString:_work.description];
    _descriptionWorkView.font = [UIFont fontWithName:@"AvenirLTStd-Light" size:13];
    _descriptionWorkView.layoutManager.delegate = self;
    _descriptionWorkView.textAlignment = NSTextAlignmentJustified;
    
    [self updateTextViewHeight:_descriptionWorkView];
    _viewDescription.frame = CGRectMake(80, _imageWorkView.frame.origin.y + _imageWorkView.frame.size.height, 460, _descriptionWorkView.frame.size.height + 30);
    [self.parallaxScrollView addSubview:_viewDescription withAcceleration:CGPointMake(0.0f, 0.42f)];
    
    // Question view
    _questionView.frame = CGRectMake(20, _viewDescription.frame.origin.y + _viewDescription.frame.size.height + 350, _questionView.frame.size.width, _questionView.frame.size.height);
    [self.parallaxScrollView addSubview:_questionView withAcceleration:CGPointMake(0.0f, 0.50f)];
    
    _answerTextView.frame = CGRectMake(_answerTextView.frame.origin.x, _questionBgView.frame.origin.y + _questionBgView.frame.size.height + 150, _answerTextView.frame.size.width, _answerTextView.frame.size.height);
    [self.parallaxScrollView addSubview:_answerTextView withAcceleration:CGPointMake(0.0f, 0.25f)];
     [self.parallaxScrollView bringSubviewToFront:self.answerTextView];
    
    _isQuestionDiscover = NO;
    

    [self.parallaxScrollView setContentSize:(CGSizeMake(320, 6000))];
    
    [self initNavigationBar];

    // Add gesture recognizer for choices
/*    _touchChoice1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getQuestionAnswer:)];
    _touchChoice2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getQuestionAnswer:)];
    _touchChoice1.delegate = self;
    _touchChoice2.delegate = self;
    
    [_choice1View addGestureRecognizer:_touchChoice1];
    [_choice2View addGestureRecognizer:_touchChoice2];*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.didRotate) {
        [self transitionIn];
    }
}

- (void)transitionIn {
    NSArray *subviews = [NSArray arrayWithArray:[[self.parallaxScrollView.subviews reverseObjectEnumerator] allObjects]];

    CGFloat delay = 0;
    
    self.navigationBar.alpha = 0;
    [self.navigationBar moveTo:CGPointMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y + 20)];

    for(UIView *view in subviews) {
        view.alpha = 0;
        [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        
        [UIView animateWithDuration:0.6 delay:delay options:0 animations:^{
            view.alpha = 1;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        } completion:nil];
        delay += 0.07;
    }
    
    [UIView animateWithDuration:0.6 delay:delay options:0 animations:^{
        self.navigationBar.alpha = 1;
        [self.navigationBar moveTo:CGPointMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y - 20)];
    } completion:nil];

}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 20, [OrientationUtils nativeLandscapeDeviceSize].size.width, 20) andTitle:@"" andShowExploreButton:self.showExploreButton];
    [self.view addSubview:self.navigationBar];
    
    [self.navigationBar.backButton setImage:[UIImage imageNamed:@"navBackButton.png"] forState:UIControlStateNormal];
    [self.navigationBar.backButton addTarget:self action:@selector(transitionOutToGallery) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.showExploreButton) {
        [self.navigationBar.exploreButton addTarget:self action:@selector(transitionOutToScene) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)transitionOutToGallery {
    NSArray *subviews = [NSArray arrayWithArray:[[self.parallaxScrollView.subviews reverseObjectEnumerator] allObjects]];
    
    CGFloat delay = 0.14;
    NSInteger transitionDone = 0;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.navigationBar.alpha = 0;
        [self.navigationBar moveTo:CGPointMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y - 20)];
    }];
    
    for(UIView *view in subviews) {
        [UIView animateWithDuration:0.6 delay:delay options:0 animations:^{
            view.alpha = 0;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        } completion:^(BOOL finished) {
            if(transitionDone >= [subviews count] - 1) {
                [self backToGallery];
            }
        }];
        transitionDone++;
        delay += 0.07;
    }
}

- (void)transitionOutToScene {
    NSArray *subviews = [NSArray arrayWithArray:[[self.parallaxScrollView.subviews reverseObjectEnumerator] allObjects]];
    
    CGFloat delay = 0.14;
    NSInteger transitionDone = 0;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.navigationBar.alpha = 0;
        [self.navigationBar moveTo:CGPointMake(self.navigationBar.frame.origin.x, self.navigationBar.frame.origin.y - 20)];
    }];
    for(UIView *view in subviews) {
        [UIView animateWithDuration:0.6 delay:delay options:0 animations:^{
            view.alpha = 0;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        } completion:^(BOOL finished) {
            if(transitionDone >= [subviews count] - 1) {
                [self backToScene];
            }
        }];
        transitionDone++;
        delay += 0.07;
    }
}

- (void)backToGallery {
    GalleryViewController *galleryView = [self.storyboard instantiateViewControllerWithIdentifier:@"GalleryViewController"];
    galleryView.shouldUpdateRotation = YES;
    [self.navigationController pushViewController:galleryView animated:NO];
}

- (void)backToScene {
    SceneManager *sceneManager = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneManager"];
    sceneManager.shouldResume = YES;
    [self.navigationController pushViewController:sceneManager animated:NO];
}

- (void)updateTextViewHeight:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height + 20);
    textView.frame = newFrame;
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = _parallaxScrollView.contentOffset;
    UIView *answer = [self.parallaxScrollView viewWithTag:20];
    if(contentOffset.y > _questionBgView.frame.origin.y + _questionBgView.frame.size.height) {
        if(!_isQuestionDiscover) {
            if([_question.choice_1 isEqualToString:_question.choice_correct]) {
                [UIView transitionWithView:_choice1View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [_choice2View setAlpha:0.0f];
                } completion:nil];
            } else {
                [UIView transitionWithView:_choice2View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [_choice1View setAlpha:0.0f];
                } completion:nil];
            }
            [UIView transitionWithView:_answerTextView duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [_answerTextView moveTo:CGPointMake(_answerTextView.frame.origin.x, 350)];
                [_answerTextView setAlpha:1.0f];
            } completion:nil];
        }
    }
    if(contentOffset.y > _questionBgView.frame.origin.y) {
        [UIView transitionWithView:_choice1View duration:0.75 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice1View moveTo:CGPointMake(_choice1View.frame.origin.x, 160)];
            [answer moveTo:CGPointMake(_choice1View.frame.origin.x, 160)];
        } completion:nil];
        [UIView transitionWithView:_choice2View duration:0.80 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice2View moveTo:CGPointMake(_choice2View.frame.origin.x, 160)];
        } completion:nil];
    }
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = _parallaxScrollView.contentOffset;
    /*
    if(contentOffset.y >= _questionView.frame.origin.y && contentOffset.y <= _questionView.frame.origin.y + _questionView.frame.size.height - 500) {
        [UIView transitionWithView:_choice1View duration:0.75 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice1View moveTo:CGPointMake(_choice1View.frame.origin.x, 160)];
        } completion:nil];
        [UIView transitionWithView:_choice2View duration:0.80 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice2View moveTo:CGPointMake(_choice2View.frame.origin.x, 160)];
        } completion:nil];
    }
    */
    
    if(contentOffset.y > _questionView.frame.origin.y + (_questionBgView.frame.size.height/2) - 200 && contentOffset.y <= _questionView.frame.origin.y + _questionBgView.frame.size.height) {
        if(!_isQuestionDiscover) {
            if([_question.choice_1 isEqualToString:_question.choice_correct]) {
                [UIView transitionWithView:_choice1View duration:0.90 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [_choice2View setAlpha:0.0f];
                } completion:nil];
            } else {
                [UIView transitionWithView:_choice2View duration:0.90 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    [_choice1View setAlpha:0.0f];
                } completion:nil];
            }
            [UIView transitionWithView:_answerTextView duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [_answerTextView setAlpha:1.0f];
            } completion:nil];
        }
    }
}
 
- (void)getQuestionAnswer:(UITapGestureRecognizer*)sender {
    NSLog(@"touch");
    if(!_isQuestionDiscover) {
        NSLog(@"is question is discover");
        if([_question.choice_1 isEqualToString:_question.choice_correct]) {
            [UIView transitionWithView:_choice1View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [_choice2View setAlpha:0.0f];
            } completion:nil];
        } else {
            [UIView transitionWithView:_choice2View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [_choice1View setAlpha:0.0f];
            } completion:nil];
        }
        [UIView transitionWithView:_answerTextView duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_answerTextView moveTo:CGPointMake(_answerTextView.frame.origin.x, 350)];
            [_answerTextView setAlpha:1.0f];
        } completion:nil];
    }
}

- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect {
    return 5;
}
@end