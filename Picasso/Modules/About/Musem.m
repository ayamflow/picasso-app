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
#import "InfosPanel.h"

#define kCellLabelTag 1
#define kCellDetailTag 2

@interface Musem ()

@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSArray *identifiers;
@property (strong, nonatomic) NSArray *subviewClasses;
@property (strong, nonatomic) NSMutableArray *openCellIndexes;
@property (assign, nonatomic) CGFloat lastUpdatedCellHeight;

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
    
    [self initTableView];
    [self initTableHeader];
    [self initData];
    [self initTexts];
    [self initButtons];
    
    [self initNavBarShadow];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navBar.frame.size.height, [OrientationUtils nativeDeviceSize].size.width, [OrientationUtils nativeDeviceSize].size.height - self.navBar.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)initTableHeader {
    UIImageView *hotelImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel.png"]];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, self.navBar.frame.size.height, [OrientationUtils nativeDeviceSize].size.width, hotelImage.frame.size.height)];
    [header addSubview:hotelImage];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotelImage.frame.size.width * 0.05, hotelImage.frame.size.height * 3/5, hotelImage.frame.size.width * 0.9, hotelImage.frame.size.height / 5)];
    titleLabel.text = [@"L'hôtel salé" uppercaseString];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"AvenirLTStd-Black" size:20];
    titleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    titleLabel.layer.borderWidth = 2;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(hotelImage.frame.size.width * 0.05, hotelImage.frame.size.height * 4/5, hotelImage.frame.size.width * 0.9, hotelImage.frame.size.height / 5)];
    subtitleLabel.text = [@"c'est ouvert !" uppercaseString];
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:16];
    [subtitleLabel setTextAlignment:NSTextAlignmentCenter];
    [header addSubview:subtitleLabel];

    self.tableView.tableHeaderView = header;
}

- ( void)initNavBarShadow {
    self.navBar.layer.masksToBounds = NO;
    self.navBar.layer.shadowOffset = CGSizeMake(0, 5);
    self.navBar.layer.shadowRadius = 3;
    self.navBar.layer.shadowOpacity = 0.3;
    [self.view bringSubviewToFront:self.navBar];
}

- (void)initData {
    self.labels = [NSArray arrayWithObjects:[@"Horaires d'ouverture" uppercaseString], [@"informations pratiques" uppercaseString], [@"accéder à la map" uppercaseString], [@"réserver son billet" uppercaseString], [@"à propos du musée" uppercaseString], nil];
    self.identifiers = [NSArray arrayWithObjects:@"Hours", @"Infos", @"Map", @"Booking", @"About", nil];
    self.openCellIndexes = [[NSMutableArray alloc] init];
    self.subviewClasses = [NSArray arrayWithObjects:@"HoursPanel", @"InfosPanel", @"HoursPanel", @"HoursPanel", @"HoursPanel", nil];
}

- (void)initTexts {
    self.navTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:20];
    self.hotelTitle.font = [UIFont fontWithName:@"AvenirLTStd-Black" size:20];
    self.hotelTitle.layer.borderColor = [UIColor whiteColor].CGColor;
    self.hotelTitle.layer.borderWidth = 2;
    self.hotelSubtitle.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:13];
}

- (void)initButtons {
    [self.backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
    [self.exploreButton addTarget:self action:@selector(navigateToExplore) forControlEvents:UIControlEventTouchUpInside];
}

- (void)navigateBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigateToExplore {
    [self navigateToExploreMode];
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
        label.text = [self.labels objectAtIndex:indexPath.row];
        label.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:15];
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
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [cell.contentView addSubview:view];
    [view moveTo:CGPointMake(0, cell.frame.size.height)];
    self.lastUpdatedCellHeight = view.frame.size.height;
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
        return self.lastUpdatedCellHeight;
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

@end