//
//  PullRefreshTableViewController.h
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

#import <UIKit/UIKit.h>

typedef enum {
    PullRefreshTableViewControllerThemeDefault,
    PullRefreshTableViewControllerThemeEgo
} PullRefreshTableViewControllerTheme;

@interface PullRefreshTableViewController : UITableViewController {

    BOOL isDragging;
    BOOL isLoading;

    BOOL loadMoreIsLoading;
    BOOL updatedLoadMoreFrame;    

    @private
        BOOL enablePullToRefresh;
        BOOL enablePullToLoadMore;

}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UIView *refreshHeaderBackgroundFillerView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UILabel *lastUpdatedLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, retain) NSDate *lastUpdatedDate;
@property (nonatomic) PullRefreshTableViewControllerTheme theme;


@property (nonatomic, retain) UIView *loadMoreFooterView;
@property (nonatomic, retain) UILabel *loadMoreLabel;
@property (nonatomic, retain) UILabel *lastLoadedLabel;
@property (nonatomic, retain) UIImageView *loadMoreArrow;
@property (nonatomic, retain) UIActivityIndicatorView *loadMoreSpinner;
@property (nonatomic, copy) NSString *loadMoreTextPull;
@property (nonatomic, copy) NSString *loadMoreTextRelease;
@property (nonatomic, copy) NSString *loadMoreTextLoading;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pullToRefresh:(BOOL) pullRefresh pullToLoadMore:(BOOL) pullLoad;

- (NSString *)lastUpdatedString;

- (void)addPullToRefreshHeader;
- (void)addPullToLoadMoreFooter;

- (void)startLoading;
- (void)stopLoading;

- (void)startLoadingFooter;
- (void)stopLoadingFooter;


- (void)refresh;
- (void) moreLoaded;

-(void) reloadData;

@end
