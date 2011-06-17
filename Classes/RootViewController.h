//
//  RootViewController.h
//  oDataDemo1
//
//  Created by Jeremy Mullin on 5/12/11.
//  Copyright 2011 Sybase. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullRefreshTableViewController.h"
#import "taskDetailsController.h"
#import "tasksData.h"

@interface RootViewController : PullRefreshTableViewController <TaskDetailsDelegate> {
    NSMutableArray *_tasksArray;
    NSString *errorString;
    NSOperationQueue *_jobQueue;
    tasks_Model_Entities_Tasks *taskUpdating;
}

@property (nonatomic, retain) NSString *errorString;

- (void)addItem;

@end
