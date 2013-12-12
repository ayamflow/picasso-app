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
#import "OrientationUtils.h"
#import "A3ParallaxScrollView.h"
#import "Colors.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    deviceSize = [OrientationUtils deviceSize];
    
    _datamanager = [[DataManager sharedInstance] init];
    _work = [_datamanager getWorkWithNumber:self.workId];
    _question = [_datamanager getRandomQuestion];

    _parallaxScrollView = [[A3ParallaxScrollView alloc] initWithFrame:self.view.bounds];
    _parallaxScrollView.delegate = self;
    [self.view addSubview:self.parallaxScrollView];
    
    CGSize contentSize = self.parallaxScrollView.frame.size;
    
    _parallaxScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _parallaxScrollView.contentSize = contentSize;
    
    _parallaxY = 0;
    
    // Scroll Content
    _mapBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"map-bg.png"]]];
    _mapBackgroundView.frame = CGRectMake(60, 65, 478, 408);
    [self.parallaxScrollView addSubview:_mapBackgroundView withAcceleration:CGPointMake(0.0f, 0.2f)];
    
    _gridBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"grid-bg.png"]]];
    _gridBackgroundView.frame = CGRectMake(0, 0, deviceSize.size.width, deviceSize.size.height);
    [self.parallaxScrollView addSubview:_gridBackgroundView withAcceleration:CGPointMake(0.0f, 0.1f)];
    
    NSString *imageName = [NSString stringWithFormat: @"%d.jpg", _workId];
    _imageWorkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    _imageWorkView.frame = CGRectMake(60, deviceSize.size.height + 20, _imageWorkView.frame.size.width/2, _imageWorkView.frame.size.height/2);
    
    [_imageWorkView.layer setBorderColor: [[UIColor textColor] CGColor]];
    [_imageWorkView.layer setBorderWidth: 20.0];
    _imageWorkView.layer.zPosition = 1;
    
    [self.parallaxScrollView addSubview:_imageWorkView withAcceleration:CGPointMake(0.0f, 0.5f)];
    _parallaxY = _imageWorkView.frame.origin.y + _imageWorkView.frame.size.height;
    
    _textWorkView.frame = CGRectMake(_imageWorkView.layer.bounds.origin.x + _imageWorkView.layer.bounds.size.width + 61, _parallaxY - _imageWorkView.layer.bounds.size.height/2, _textWorkView.frame.size.width, _textWorkView.frame.size.height);
    _textWorkView.backgroundColor = [UIColor whiteColor];
    _textWorkView.layer.masksToBounds = NO;
    _textWorkView.layer.shadowOffset = CGSizeMake(5, 5);
    _textWorkView.layer.shadowRadius = 5;
    _textWorkView.layer.shadowOpacity = 0.1;
    [self.parallaxScrollView addSubview:_textWorkView withAcceleration:CGPointMake(0.0f, 0.5f)];
    _parallaxY = _textWorkView.frame.origin.y + _textWorkView.frame.size.height;
    
    _descriptionWorkView.frame = CGRectMake(70, (_parallaxY - 10) / 1.35, 420, 0);
    _descriptionWorkView.contentInset = UIEdgeInsetsMake(20.0,0.0,20.0,0.0);
    _descriptionWorkView.backgroundColor = [UIColor whiteColor];
    _descriptionWorkView.layer.masksToBounds = NO;
    _descriptionWorkView.layer.shadowRadius = 5;
    _descriptionWorkView.layer.shadowOpacity = 0.1;
    _descriptionWorkView.text = _work.description;
    [self updateTextViewHeight:_descriptionWorkView];

    [self.parallaxScrollView addSubview:_descriptionWorkView withAcceleration:CGPointMake(0.0f, 0.25f)];
    _parallaxY = _descriptionWorkView.frame.origin.y + _descriptionWorkView.frame.size.height;
    
    _questionView.frame = CGRectMake(_questionView.frame.origin.x, _parallaxY + 100, _questionView.frame.size.width, _questionView.frame.size.height);
    [self.parallaxScrollView addSubview:_questionView withAcceleration:CGPointMake(0.0f, 0.25f)];
    _parallaxY = _questionView.frame.origin.y + _questionView.frame.size.height;
    
    _answerView.frame = CGRectMake(_answerView.frame.origin.x, _parallaxY + 25, _answerView.frame.size.width, _answerView.frame.size.height);
    [self.parallaxScrollView addSubview:_answerView withAcceleration:CGPointMake(0.0f, 0.25f)];
    
    _titleLabel.layer.zPosition = 1;
    [self.parallaxScrollView addSubview:_titleLabel withAcceleration:CGPointMake(0.0f, 0.5f)];
    
    _headerView.layer.zPosition = 1;
    [self.parallaxScrollView addSubview:_headerView withAcceleration:CGPointMake(0.0f, 0.3f)];
    
    _footerView.frame = CGRectMake(_footerView.frame.origin.x, _parallaxScrollView.contentSize.height - 80, _footerView.frame.size.width, _footerView.frame.size.height);
    //[self.parallaxScrollView addSubview:_footerView];
    
    _titleWorkLabel.text = [_work.title  uppercaseString];
    _numbersWorkLabel.text = [[NSString stringWithFormat:@"%li / %ld oeuvres", (long)_work.workId + 1, [_datamanager getWorksNumber] + 1] uppercaseString];
    _textTitleLabel.text = _work.title;
    _textHLabel.text = [NSString stringWithFormat:@"H: %@", _work.h];
    _textLLabel.text = [NSString stringWithFormat:@"L: %@", _work.l];
    _textTechniqueLabel.text = _work.technical;
    
    _questionLabel.text = _question.question;
    _choice1Label.text = _question.choice_1;
    _choice2label.text = _question.choice_2;
    
    _touchChoice1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getQuestionAnswer:)];
    _touchChoice2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getQuestionAnswer:)];
    [_choice1View addGestureRecognizer:_touchChoice1];
    [_choice2View addGestureRecognizer:_touchChoice2];
    
    [self.parallaxScrollView setContentSize:(CGSizeMake(320, 5000))];
}

- (void)updateTextViewHeight:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height + 20);
    textView.frame = newFrame;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //CGPoint contentOffset = _parallaxScrollView.contentOffset;
}

- (void)getQuestionAnswer:(UITapGestureRecognizer*)sender {
    if([_question.choice_1 isEqualToString:_question.choice_correct]) {
        [UIView transitionWithView:_choice1View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice1View setBackgroundColor:[UIColor greenColor]];
        } completion:nil];
        [UIView transitionWithView:_choice2View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice2View setBackgroundColor:[UIColor redColor]];
        } completion:nil];
    } else {
        [UIView transitionWithView:_choice1View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice1View setBackgroundColor:[UIColor redColor]];
        } completion:nil];
        [UIView transitionWithView:_choice2View duration:0.50 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [_choice2View setBackgroundColor:[UIColor greenColor]];
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end