//
//  About.m
//  Picasso
//
//  Created by Florian Morel on 04/11/13.
//  Copyright (c) 2013 PowerRangers. All rights reserved.
//

#import "Musem.h"
#import "SceneChooser.h"
#import "UIViewPicasso.h"
#import "UIViewControllerPicasso.h"
#import "OrientationUtils.h"
#import "HoursPanel.h"
#import "MotionVideoPlayer.h"
#import "InfosPanel.h"
#import "NavigationBarView.h"
#import "UIView+EasingFunctions.h"
#import "easing.h"
#import <MapKit/MapKit.h>
#import "TextUtils.h"

#define kCellLabelTag 1
#define kCellDetailTag 2

#define kCellMap 2

@interface Musem ()

@property (strong, nonatomic) NavigationBarView *navigationBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSArray *identifiers;
@property (strong, nonatomic) NSArray *subviewClasses;
@property (strong, nonatomic) NSMutableArray *openCellIndexes;
@property (strong, nonatomic) NSMutableArray *cellHeights;

@property (assign, nonatomic) BOOL leavingToExplore;

@end

@implementation Musem

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigationBar];
    [self initTableView];
    [self initTableHeader];
//    [self initData];
    [self initTexts];
    [self initBackground];

    self.view.backgroundColor = [UIColor clearColor]; // Maybe an image ?
}

- (void)initBackground {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"simpleBackground" ofType:@".png"];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
    [self.tableView addSubview:background];
    background.tag = 10;
    [background moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height / 2 - background.bounds.size.height / 4)];
    [self.tableView sendSubviewToBack:background];
    
    NSString *bottomPath = [[NSBundle mainBundle] pathForResource:@"bottomBackground" ofType:@".png"];
    UIImageView *bottomBackground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:bottomPath]];
    [self.tableView addSubview:bottomBackground];
    [bottomBackground moveTo:CGPointMake(0, [OrientationUtils nativeDeviceSize].size.height + bottomBackground.bounds.size.height)];
    [self.tableView sendSubviewToBack:bottomBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[MotionVideoPlayer sharedInstance] player] pause];
    [self transitionIn];
}

- (void)initNavigationBar {
    self.navigationBar = [[NavigationBarView alloc] initWithFrame:CGRectMake(0, 0, [OrientationUtils nativeDeviceSize].size.width, 50) andTitle:@"Le musée" andShowExploreButton:YES];
    [self.view addSubview:self.navigationBar];

    [self.navigationBar.backButton addTarget:self action:@selector(transitionOut) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.exploreButton addTarget:self action:@selector(outToExplore) forControlEvents:UIControlEventTouchUpInside];
}

- (void)outToExplore {
    self.leavingToExplore = YES;
    [self transitionOut];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height, [OrientationUtils nativeDeviceSize].size.width, [OrientationUtils nativeDeviceSize].size.height - self.navigationBar.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)initTableHeader {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hotel" ofType:@".png"];
    UIImageView *hotelImage = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:path]];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height, [OrientationUtils nativeDeviceSize].size.width, hotelImage.frame.size.height)];
    [header addSubview:hotelImage];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotelImage.frame.size.width * 0.05, hotelImage.frame.size.height * 3/5, hotelImage.frame.size.width * 0.9, hotelImage.frame.size.height / 5)];
    titleLabel.attributedText = [TextUtils getKernedString:[@"L'hôtel salé" uppercaseString]];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"AvenirLTStd-Black" size:20];
    titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    titleLabel.layer.borderWidth = 2;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotelImage.frame.size.width * 0.05, hotelImage.frame.size.height * 4/5, hotelImage.frame.size.width * 0.9, hotelImage.frame.size.height / 5)];
    subtitleLabel.attributedText = [TextUtils getKernedString:[@"c'est ouvert !" uppercaseString]];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:16];
    [subtitleLabel setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:subtitleLabel];

    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
}

- (void)initData {
    self.labels = [NSArray arrayWithObjects:[@"Horaires d'ouverture" uppercaseString], [@"informations pratiques" uppercaseString], [@"accéder à la map" uppercaseString], [@"réserver son billet" uppercaseString], [@"à propos du musée" uppercaseString], nil];
    self.identifiers = [NSArray arrayWithObjects:@"Hours", @"Infos", @"Map", @"Booking", @"About", nil];
    self.openCellIndexes = [[NSMutableArray alloc] init];
    self.subviewClasses = [NSArray arrayWithObjects:@"HoursPanel", @"InfosPanel", @"HoursPanel", @"HoursPanel", @"HoursPanel", nil];
    self.cellHeights = [NSMutableArray arrayWithCapacity:[self.identifiers count]];
    for(int i = 0; i < [self.identifiers count]; i++) {
        [self.cellHeights addObject:[NSNumber numberWithFloat:[self.tableView rowHeight]]];
    }
}

- (void)initTexts {
    self.hotelTitle.font = [UIFont fontWithName:@"AvenirLTStd-Black" size:20];
    self.hotelTitle.layer.borderColor = [UIColor whiteColor].CGColor;
    self.hotelTitle.layer.borderWidth = 2;
    self.hotelSubtitle.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
}

- (void)navigateBack {
    [self toHome];
}

- (void)navigateToExplore {
    [self toSceneChooser];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.labels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:[self.identifiers objectAtIndex:indexPath.row]];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self.identifiers objectAtIndex:indexPath.row]];
        UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
        label.attributedText = [TextUtils getKernedString:[self.labels objectAtIndex:indexPath.row]];
        label.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
        [label setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width * 0.05, cell.frame.size.height - 1, cell.frame.size.width * 0.9, 1)];
        line.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:line];
        UIImageView *statusIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellPlus.png"]];
        statusIcon.tag = kCellLabelTag;
        [cell.contentView addSubview:statusIcon];
        [statusIcon moveTo:CGPointMake(cell.frame.size.width * 0.1, cell.frame.size.height / 2 - statusIcon.frame.size.height / 2)];
        cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.backgroundColor = [UIColor clearColor];
        [cell setEasingFunction:QuadraticEaseInOut forKeyPath:@"transform"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == kCellMap) [self openMaps];
    if(indexPath.row >= kCellMap) return;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([self.openCellIndexes indexOfObject:@(indexPath.row)] == NSNotFound) {
        [self expandCell:cell atIndexPath:indexPath];
    }
    else {
        [self closeCell:cell atIndexPath:indexPath];
    }
}
         
- (void)expandCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self.openCellIndexes addObject:@(indexPath.row)];
    NSString *subviewName = [self.subviewClasses objectAtIndex:indexPath.row];
    Class SubView = NSClassFromString(subviewName);
    UIView *view = ((UIViewController *)[[SubView alloc] initWithNibName:subviewName bundle:nil]).view;
    view.tag = kCellDetailTag;
    view.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:view];
    [view moveTo:CGPointMake(0, cell.frame.size.height)];
    [self.cellHeights setObject:[NSNumber numberWithFloat:view.frame.size.height] atIndexedSubscript:indexPath.row];
    [self updateCell:cell atIndexPath:indexPath];
    [self changeStatusIconForCell:cell atIndexPath:indexPath];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)closeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self.openCellIndexes removeObject:@(indexPath.row)];
    [self changeStatusIconForCell:cell atIndexPath:indexPath];
    [UIView animateWithDuration:0.4 animations:^{
        CGRect cellFrame = cell.frame;
        cellFrame.size = CGSizeMake(cellFrame.size.width, [self.tableView rowHeight]);
        cell.frame = cellFrame;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    } completion:^(BOOL finished) {
        [[cell.contentView viewWithTag:kCellDetailTag] removeFromSuperview];
        [self updateCell:cell atIndexPath:indexPath];
    }];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.openCellIndexes indexOfObject:@(indexPath.row)] == NSNotFound) {
        return [tableView rowHeight];
    }
    else {
        return [[self.cellHeights objectAtIndex:indexPath.row] floatValue];
    }
}

- (void)changeStatusIconForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    UIImageView *statusIcon = (UIImageView *)[cell.contentView viewWithTag:kCellLabelTag];
    statusIcon.transform = CGAffineTransformIdentity;
    
    UIImage *animatedIconImage;
    if([self.openCellIndexes indexOfObject:@(indexPath.row)] == NSNotFound) {
        animatedIconImage = [UIImage imageNamed:@"cellPlus.png"];
    }
    else {
        animatedIconImage = [UIImage imageNamed:@"cellMinus.png"];
    }
    UIImageView *animatedIcon = [[UIImageView alloc] initWithImage:animatedIconImage];
    animatedIcon.center = statusIcon.center;
    [cell.contentView addSubview:animatedIcon];

    statusIcon.alpha = 1;
    animatedIcon.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        statusIcon.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        animatedIcon.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        statusIcon.alpha = 0;
        animatedIcon.alpha = 1;
    } completion:^(BOOL finished) {
        [animatedIcon removeFromSuperview];
        statusIcon.image = animatedIconImage;
        statusIcon.alpha = 1;
    }];
}

- (void)transitionIn {
    self.navigationBar.alpha = 0;
    self.tableView.tableHeaderView.alpha = 0;
    
    UIView *background = [self.view viewWithTag:10];
    
    for(UIView *view in @[background, self.tableView.tableHeaderView, self.navigationBar]) {
        view.alpha = 0;
        [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        
        [UIView animateWithDuration:0.4 animations:^{
            view.alpha = 1;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y + 20)];
        }];
    }
    [self performSelector:@selector(showTableCells) withObject:self afterDelay:0.2];
}

- (void)showTableCells {
    [self initData];
    [self.tableView reloadData];
}

- (void)transitionOut {
    NSArray *cells = [self.tableView visibleCells];
    for(NSInteger i = [cells count] - 1; i >= 0; i--) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        [UIView animateWithDuration:0.4 delay:([cells count] - i - 1) * 0.1 options:0 animations:^{
            cell.alpha = 0;
            cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 0);
        } completion:nil];
    }

    UIView *background = [self.view viewWithTag:10];
    
    for(UIView *view in @[background, self.tableView.tableHeaderView, self.navigationBar]) {
        [UIView animateWithDuration:0.4 animations:^{
            view.alpha = 0;
            [view moveTo:CGPointMake(view.frame.origin.x, view.frame.origin.y - 20)];
        } completion:^(BOOL finished) {
            [self cleanArrays];
            if(self.leavingToExplore) {
                [self toSceneChooser];
            }
            else {
                [self toHome];
            }

        }];
    }
}

- (void)cleanArrays {
    self.labels = nil;
    self.identifiers = nil;
    self.subviewClasses = nil;
    self.openCellIndexes = nil;
    self.cellHeights = nil;
    [self.tableView removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.alpha = 0;
    cell.layer.anchorPoint = CGPointMake(0.5, 0);
    cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 0);
    [UIView animateWithDuration:0.25 delay:indexPath.row * 0.08 options:0 animations:^{
        cell.alpha = 1.0;
        cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}

// Opening Maps

- (void)openMaps {
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(48.85967, 2.36242);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Musée National Picasso Paris"];
        [mapItem openInMapsWithLaunchOptions:nil];
    }
}

@end