//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

#define REFRESH_HEADER_FILLER_HEIGHT 1000.0f
#define REFRESH_HEADER_HEIGHT 52.0f

//Hardcoded to known contentSize, so the arrow shows up when you initially scroll, otherwise set really large
#define DEVICE_HEIGHT 1680

@interface PullRefreshTableViewController()

- (void)setUpLabels;
- (void)updateTheme;
@end


@implementation PullRefreshTableViewController



@synthesize textPull, textRelease, textLoading, lastUpdatedDate, refreshHeaderView, refreshHeaderBackgroundFillerView, refreshLabel, lastUpdatedLabel, refreshArrow, refreshSpinner,theme;
@synthesize loadMoreTextPull,loadMoreTextRelease,loadMoreTextLoading,lastLoadedLabel, loadMoreFooterView, loadMoreLabel, loadMoreArrow, loadMoreSpinner;


- (id)init
{
    self = [super init];
    if (self) {
        [self setUpLabels];
    }
    enablePullToRefresh = TRUE;
    enablePullToLoadMore = TRUE;
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setUpLabels];
    }
    enablePullToRefresh = TRUE;
    enablePullToLoadMore = TRUE;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpLabels];
    }
    enablePullToRefresh = TRUE;
    enablePullToLoadMore = TRUE;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUpLabels];
    }
    enablePullToRefresh = TRUE;
    enablePullToLoadMore = TRUE;
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pullToRefresh:(BOOL) pullRefresh pullToLoadMore:(BOOL) pullLoad{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUpLabels];
    }
    enablePullToRefresh = pullRefresh;
    enablePullToLoadMore = pullLoad;
    return self;
}
- (void)setUpLabels
{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
    loadMoreTextPull = [[NSString alloc] initWithString:@"Pull up to load more..."];
    loadMoreTextRelease = [[NSString alloc] initWithString:@"Release to load more..."];
    loadMoreTextLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (enablePullToRefresh) {
        isLoading = NO;
        [self addPullToRefreshHeader];
    }
    if(enablePullToLoadMore){
        loadMoreIsLoading = NO;
        [self addPullToLoadMoreFooter];
    }
}

-(CGFloat) lowestContentOffset{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height) 
        return self.tableView.contentSize.height - self.tableView.frame.size.height;
    else
        return 0.0;
}

- (BOOL)belowContent:(UIScrollView*)scrollView {
    int offset = scrollView.contentSize.height - scrollView.frame.size.height;
    return ( ( scrollView.contentOffset.y > 0 ) && ( ( offset < 0 ) || ( scrollView.contentOffset.y > offset ) ) );
}

- (void)addPullToRefreshHeader {
   
    
    refreshHeaderBackgroundFillerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_FILLER_HEIGHT, 320, REFRESH_HEADER_FILLER_HEIGHT)];
    refreshHeaderBackgroundFillerView.backgroundColor = [UIColor clearColor];
    

    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, REFRESH_HEADER_FILLER_HEIGHT - REFRESH_HEADER_HEIGHT, self.tableView.frame.size.width, REFRESH_HEADER_HEIGHT)];


    refreshHeaderView.backgroundColor = [UIColor clearColor];

    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 3, self.tableView.frame.size.width, (REFRESH_HEADER_HEIGHT / 2) - 3)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (REFRESH_HEADER_HEIGHT / 2) - 3, self.tableView.frame.size.width, (REFRESH_HEADER_HEIGHT / 2) - 3)];
    lastUpdatedLabel.backgroundColor = [UIColor clearColor];
    lastUpdatedLabel.font = [UIFont boldSystemFontOfSize:12.0];
    lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
    lastUpdatedLabel.text = [self lastUpdatedString];

    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    (REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [self updateTheme];

    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:lastUpdatedLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [refreshHeaderBackgroundFillerView addSubview:refreshHeaderView];
    [self.tableView addSubview:refreshHeaderBackgroundFillerView];
}

- (void)addPullToLoadMoreFooter {
    loadMoreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height+ [self lowestContentOffset], self.tableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    loadMoreFooterView.backgroundColor = [UIColor clearColor];
    
    loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 8, self.tableView.frame.size.width, (REFRESH_HEADER_HEIGHT / 2) - 3)];
    loadMoreLabel.backgroundColor = [UIColor clearColor];
    loadMoreLabel.font = [UIFont boldSystemFontOfSize:12.0];
    loadMoreLabel.textAlignment = UITextAlignmentCenter;
    
    
    loadMoreArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    loadMoreArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    ( REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);
    
    [loadMoreArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);

    loadMoreSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadMoreSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    loadMoreSpinner.hidesWhenStopped = YES;
    
    [loadMoreFooterView setHidden:YES];
    
    [loadMoreFooterView addSubview:loadMoreLabel];
    [loadMoreFooterView addSubview:loadMoreArrow];
    [loadMoreFooterView addSubview:loadMoreSpinner];
    [self.tableView addSubview:loadMoreFooterView];
}
#pragma mark - updates to information

//Function to update the location of where the pullToLoadMore lives.
- (void) updateLoadMoreFrame:(UIScrollView *)scrollView {
    //self.tableView.frame.size.height+lowestContentOffset will always be the lowest possible location
    loadMoreFooterView.frame = CGRectMake(0, self.tableView.frame.size.height+[self lowestContentOffset], self.tableView.frame.size.width, REFRESH_HEADER_HEIGHT);
}

- (NSString *)lastUpdatedString
{    
    NSString *dateString = nil;
    if (!lastUpdatedDate) {
        dateString = @"Never updated";
    }
    else {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        dateString = [dateFormatter stringFromDate:lastUpdatedDate];
    }
    
    return [NSString stringWithFormat:@"Last Updated: %@",dateString];
}

-(void) reloadData{
    [self.tableView reloadData];
}

#pragma mark - themes
- (void)setTheme:(PullRefreshTableViewControllerTheme)aTheme
{
    theme = aTheme;
    [self updateTheme];
}

- (void)updateTheme
{
    if (PullRefreshTableViewControllerThemeEgo == theme) {
        refreshHeaderBackgroundFillerView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        refreshLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
        lastUpdatedLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
    }
    else {
        refreshHeaderBackgroundFillerView.backgroundColor = [UIColor clearColor];
        refreshLabel.textColor = [UIColor blackColor];
        lastUpdatedLabel.textColor = [UIColor blackColor];
    }
}
#pragma mark - scrolling detection
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    
    lastUpdatedLabel.text = [self lastUpdatedString];
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(enablePullToRefresh){
        if (isLoading) {
            // Update the content inset, good for section headers
            if (scrollView.contentOffset.y > 0){
                    self.tableView.contentInset = UIEdgeInsetsZero;
            }else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT){
                
                self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);

            }
        } else if (isDragging && scrollView.contentOffset.y < 0) {

            // Update the arrow direction and label
            [UIView beginAnimations:nil context:NULL];
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            
            } else { // User is scrolling somewhere within the header
                
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);

            }
            [UIView commitAnimations];
        }
    }
    if (enablePullToLoadMore) {
        if (loadMoreIsLoading) {
            if(scrollView.contentOffset.y < [self lowestContentOffset]){

                self.tableView.contentInset = UIEdgeInsetsZero;
            
            }else if( scrollView.contentOffset.y <= (REFRESH_HEADER_HEIGHT+ [self lowestContentOffset])){
               
                //Checking for data not entirely loading the table

                //if (lowestContentOffset == 0) {
                    //This should be a negative number, but not working. something about tables having infinite table entries if dont fit
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, ([self lowestContentOffset] + scrollView.frame.size.height), 0);
                    
                //} else {
                    
                //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, (scrollView.contentOffset.y - scrollView.frame.size.height), 0);
                
                //}

            }
        }else if( isDragging && [self belowContent:scrollView] ){

            if(!updatedLoadMoreFrame){
                [self updateLoadMoreFrame:scrollView];
                updatedLoadMoreFrame = TRUE;
                [loadMoreFooterView setHidden:NO];
            }
            [UIView beginAnimations:nil context:NULL];
            if (scrollView.contentOffset.y > (REFRESH_HEADER_HEIGHT + [self lowestContentOffset])) {
                //User is scrolling below the footer load more cell
                loadMoreLabel.text = self.loadMoreTextRelease;

                [loadMoreArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);

            }else{
                //User is in the footer load more cell
                loadMoreLabel.text = self.loadMoreTextPull;
                
                [loadMoreArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            }
            [UIView commitAnimations];
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (enablePullToLoadMore && !loadMoreIsLoading){        
        //If top is loading, need to check for the bottom
        isDragging = NO;
        
        if (scrollView.contentOffset.y >= (REFRESH_HEADER_HEIGHT+[self lowestContentOffset])) 
            [self startLoadingFooter];

        //Do this to stop the position of load more frame because otherwise constant checks
        updatedLoadMoreFrame = FALSE;
    }

    if(enablePullToRefresh && !isLoading){
        isDragging = NO;
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) 
            // Released above the header
            [self startLoading];        
    }
}

- (void)startLoading {
    isLoading = YES;

    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];

    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    lastUpdatedLabel.text = [self lastUpdatedString];

    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

#pragma mark - loadMore start/stop loading

- (void)startLoadingFooter {
    loadMoreIsLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [self lowestContentOffset] + REFRESH_HEADER_HEIGHT, 0);
    loadMoreLabel.text = self.loadMoreTextLoading;
    loadMoreArrow.hidden = YES;
    [loadMoreSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self moreLoaded];
}

- (void)stopLoadingFooter {
    loadMoreIsLoading = NO;
    
    lastUpdatedLabel.text = [self lastUpdatedString];
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingFooterComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [loadMoreArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingFooterComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    loadMoreLabel.text = self.loadMoreTextPull;
    loadMoreArrow.hidden = NO;
    [loadMoreSpinner stopAnimating];
    [loadMoreFooterView setHidden:YES];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    // Don't forget to update the lastUpdatedDate ivar in this method.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

-(void) moreLoaded{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoadingFooter at the end.
    [self performSelector:@selector(stopLoadingFooter) withObject:nil afterDelay:2.0];    
}

- (void)dealloc {
    [refreshHeaderView release];
    [refreshHeaderBackgroundFillerView release];
    [refreshLabel release];
    [lastUpdatedDate release];
    [lastUpdatedLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];

    [loadMoreFooterView release];
    [loadMoreLabel release];
    [loadMoreArrow release];
    [loadMoreSpinner release];
    [loadMoreTextPull release];
    [loadMoreTextRelease release];
    [loadMoreTextLoading release];
    
    [super dealloc];
}


@end
