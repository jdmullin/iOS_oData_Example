//
//  DateDetailsController.h
//  oDataDemo1
//
//  Created by Jeremy Mullin on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCustomSwitch.h"

@protocol DateDetailsDelegate;

@interface DateDetailsController : UIViewController <PCCustomSwitchDelegate> {
    NSString *dateName;
    NSDate   *dateValue;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UITableView *headerTableView;
    PCCustomSwitch *customSwitch;
    id <DateDetailsDelegate> delegate;
}

// unresolved jmu - should "retain" be "assign"?
@property (nonatomic, retain) NSString *dateName;
@property (nonatomic, retain) NSDate *dateValue;
@property (nonatomic, retain) PCCustomSwitch *customSwitch;
@property (nonatomic, assign) id <DateDetailsDelegate> delegate;

@end

@protocol DateDetailsDelegate <NSObject>
- (void)didCloseWithDate:(NSDate*)date whosNameIs:(NSString*)name;
@end
