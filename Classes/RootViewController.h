//
//  RootViewController.h
//  oDataDemo1
//
//  Created by Jeremy Mullin on 5/12/11.
//  Copyright 2011 Jeremy Mullin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullRefreshTableViewController.h"
#import "taskDetailsController.h"
#import "tasksData.h"

@interface RootViewController : PullRefreshTableViewController <TaskDetailsDelegate> {
    NSMutableArray *_tasksArray;
    NSString *errorString;
    NSOperationQueue *_jobQueue;
    NSDateFormatter *dateFormatter;
    DataServiceQueryContinuation *_nextPageToken;
}

@property (nonatomic, retain) NSString *errorString;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (void)addItem;

@end
