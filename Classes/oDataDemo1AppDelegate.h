//
//  oDataDemo1AppDelegate.h
//  oDataDemo1
//
//  Created by Jeremy Mullin on 5/12/11.
//  Copyright 2011 Jeremy Mullin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "tasksData.h"

@interface oDataDemo1AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    tasksData *proxy;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) tasksData *proxy;

@end

