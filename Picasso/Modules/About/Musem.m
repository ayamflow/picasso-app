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
#import "OrientationUtils.h"

#define kHeaderHeight 260

@interface Musem ()

@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSArray *identifiers;
@property (strong, nonatomic) NSMutableArray *openCellIndexes;

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
    
    [self initData];
    [self initTexts];
    [self initButtons];
    
    // Testing
    self.scrollView.contentSize = CGSizeMake([OrientationUtils nativeDeviceSize].size.width, kHeaderHeight + self.tableView.frame.size.height);
    self.tableView.scrollEnabled = NO;
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, [OrientationUtils nativeDeviceSize].size.width, [OrientationUtils nativeDeviceSize].size.height - kHeaderHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.tableView];
}

- (void)initData {
    self.labels = [NSArray arrayWithObjects:[@"Horaires d'ouverture" uppercaseString], [@"informations pratiques" uppercaseString], [@"accéder à la map" uppercaseString], [@"réserver son billet" uppercaseString], [@"à propos du musée" uppercaseString], nil];
    self.identifiers = [NSArray arrayWithObjects:@"Hours", @"Infos", @"Map", @"Booking", @"About", nil];
    self.openCellIndexes = [[NSMutableArray alloc] init];
}

- (void)initTexts {
    self.navTitle.font = [UIFont fontWithName:@"BrandonGrotesque-Bold" size:22];
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
    SceneChooser *sceneChooser = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneChooser"];
    [self.navigationController pushViewController:sceneChooser animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.labels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:[self.identifiers objectAtIndex:indexPath.row]];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[self.identifiers objectAtIndex:indexPath.row]];
//        cell.textLabel.text = [self.labels objectAtIndex:indexPath.row];
//        cell.textLabel.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:15];
//        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
        label.text = [self.labels objectAtIndex:indexPath.row];
        label.font = [UIFont fontWithName:@"AvenirLTStd-Roman" size:15];
        [label setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width * 0.05, cell.frame.size.height - 1, cell.frame.size.width * 0.9, 1)];
        line.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:line];
        UIImageView *statusIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellPlus.png"]];
        statusIcon.tag = 1;
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
    [self updateCell:cell atIndexPath:indexPath];
}

- (void)closeCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self.openCellIndexes removeObject:@(indexPath.row)];
    [self updateCell:cell atIndexPath:indexPath];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self updateScrollViewContentSize];
    [self changeStatusIconForCell:cell atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.openCellIndexes indexOfObject:@(indexPath.row)] == NSNotFound) {
        return [tableView rowHeight];
    }
    else {
        return 100;//[self.tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    }
}

- (void)changeStatusIconForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    UIImageView *statusIcon = (UIImageView *)[cell.contentView viewWithTag:1];
    statusIcon.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 animations:^{
        statusIcon.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    } completion:^(BOOL finished) {
        if([self.openCellIndexes indexOfObject:@(indexPath.row)] == NSNotFound) {
            statusIcon.image = [UIImage imageNamed:@"cellPlus.png"];
        }
        else {
            statusIcon.image = [UIImage imageNamed:@"cellMinus.png"];
        }
    }];
}

- (void)updateScrollViewContentSize {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.tableView.contentSize.height - kHeaderHeight);
}

@end