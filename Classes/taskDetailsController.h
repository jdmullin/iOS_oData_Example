//
//  taskDetailsController.h
//  oDataDemo1
//
//  Created by Jeremy Mullin on 5/31/11.
//  Copyright 2011 Sybase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tasksData.h"
#import "DateDetailsController.h"

@protocol TaskDetailsDelegate;

@interface TaskDetailsController : UIViewController <UITextFieldDelegate, DateDetailsDelegate> {
    
    IBOutlet UITableView *taskDetailsTable;
    UIDatePicker *taskDatePicker;
    tasks_Model_Entities_Tasks *task;
    NSIndexPath *taskIndexPath;
    id <TaskDetailsDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *taskDatePicker;
@property (nonatomic, retain) tasks_Model_Entities_Tasks *task;
@property (nonatomic, retain) NSIndexPath *taskIndexPath;
@property (nonatomic, assign) id <TaskDetailsDelegate> delegate;

- (void)save;
- (void)cancel;

@end


@protocol TaskDetailsDelegate <NSObject>
- (void)didAddTask:(tasks_Model_Entities_Tasks*)task;
- (void)didUpdateTask:(tasks_Model_Entities_Tasks*)task atIndexPath:(NSIndexPath*)indexPath;
@end
