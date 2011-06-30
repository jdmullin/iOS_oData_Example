//
//  RootViewController.m
//  oDataDemo1
//
//  Created by Jeremy Mullin on 5/12/11.
//  Copyright 2011 Jeremy Mullin. All rights reserved.
//
#import "RootViewController.h"

#import "tasksData.h"
#import "utils.h"
#import "TaskDetailsController.h"

@implementation RootViewController

@synthesize errorString, dateFormatter;

#pragma mark -
#pragma mark View lifecycle

////////////////////////////////////////////////////////////////////////
// refresh tasks async
////////////////////////////////////////////////////////////////////////
- (void)refreshTasks {
    
    void (^getTasks)(void) = ^{
        @try {            
            self.errorString = nil;
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                    
            QueryOperationResponse *response = [[utils getApp].proxy execute:@"Tasks"];
            _tasksArray = [response getResult];
            [_tasksArray retain];
            
            [pool release];
        }
        @catch (NSException *e) {
            self.errorString = [e reason];
        }
    };
    
    void (^finishedJob)(void) = ^{        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{             
            if ( self.errorString == nil )
                [self.tableView reloadData];
            else {
                UIAlertView *alert = [ [[UIAlertView alloc] initWithTitle:@"Error" message:self.errorString delegate:nil cancelButtonTitle:@"Bummer" otherButtonTitles:nil ] autorelease];
                [alert show];
            }
            [self stopLoading];
        }];        
    };
    
    NSBlockOperation *job = [NSBlockOperation blockOperationWithBlock:getTasks];
    [job setCompletionBlock:finishedJob];
    
    [_jobQueue addOperation:job];
}


////////////////////////////////////////////////////////////////////////
// Member of our parent, PullRefreshTableViewController
////////////////////////////////////////////////////////////////////////
- (void)refresh {
    [self refreshTasks];
}


////////////////////////////////////////////////////////////////////////
// viewDidLoad
////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tasks";
    
    // add Insert button to the navigation bar
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    // add edit button to the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // init job queue
    _jobQueue = [[NSOperationQueue alloc] init];
    
    // init date formatter
    self.dateFormatter = [[NSDateFormatter alloc] init];        
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    // set PullToRefresh text messages
    self.textLoading = @"Loading Tasks...";
    self.textPull = @"Pull down to refresh";
    self.textRelease = @"Release to refresh";
    
    [self startLoading];

}


////////////////////////////////////////////////////////////////////////
// copy a task's properties to another task object
////////////////////////////////////////////////////////////////////////
void copyTask( tasks_Model_Entities_Tasks *dest, tasks_Model_Entities_Tasks *src ) {
    // Create a "deep copy" with our own data even for reference types, we don't
    // want modifications of this copy to change the original.
    // not worried about values in oDate super class, user will only be
    // modifying a few properties directly exposed in our first super class,
    // tasks_Model_Entities_Tasks
    [dest setname:[[src getname] copy]];
    [dest setid:[[src getid] copy]];
    [dest setrowversion:[[src getrowversion] copy]];
    [dest setstarted:[[src getstarted] copy]];
    [dest setfinished:[[src getfinished] copy]];
}


////////////////////////////////////////////////////////////////////////
// Clone an existing task
////////////////////////////////////////////////////////////////////////
tasks_Model_Entities_Tasks* cloneTask( tasks_Model_Entities_Tasks* task ) {
    tasks_Model_Entities_Tasks *newTask = [[tasks_Model_Entities_Tasks alloc] init];
    copyTask( newTask, task );
    return newTask;
}


////////////////////////////////////////////////////////////////////////
// Push details view controller on the nav stack
////////////////////////////////////////////////////////////////////////
- (void) pushDetailsWithIndexPath: (NSIndexPath *) indexPath  {
    TaskDetailsController *detailViewController = [[TaskDetailsController alloc] initWithNibName:@"taskDetailsController" bundle:nil];
    detailViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    detailViewController.delegate = self;
    
    if ( indexPath != nil ) {
        // Use a copy of the task, not the original, in case the user makes changes and then cancels
        detailViewController.task = cloneTask( [_tasksArray objectAtIndex:[indexPath row]] );
    }
    else
        // Create an empty task for the new entry
        detailViewController.task = [[tasks_Model_Entities_Tasks alloc] init];
    
    detailViewController.taskIndexPath = indexPath;
    
    // Create new nav controller as we are putting cancel and save buttons on it in the details view
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:detailViewController];
    [self presentModalViewController:navigationController animated:YES];
    
    [navigationController release];
	[detailViewController release];
    
}


////////////////////////////////////////////////////////////////////////
// addItem
////////////////////////////////////////////////////////////////////////
- (void)addItem {
    [self pushDetailsWithIndexPath:nil];
}



#pragma mark -
#pragma mark Implementation of TaskDetailsDelegate

////////////////////////////////////////////////////////////////////////
// Callback when details view added a new task
////////////////////////////////////////////////////////////////////////
- (void)didAddTask:(tasks_Model_Entities_Tasks*)task {
    // If task is nil, user cancelled    
    if ( task != nil ) {
        // persist via oData service call
        [[utils getApp].proxy addObject:@"Tasks" object:task];
        [[utils getApp].proxy saveChanges];
    
        // save in our tasks array
        [_tasksArray addObject:task];
    
        // update the tableView datasource
        [self.tableView reloadData];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


////////////////////////////////////////////////////////////////////////
// Callback when details view updated a task
////////////////////////////////////////////////////////////////////////
- (void)didUpdateTask:(tasks_Model_Entities_Tasks*)task atIndexPath:(NSIndexPath*)indexPath {
    // If task is nil, user cancelled
    if ( task != nil ) {
        tasks_Model_Entities_Tasks *taskUpdating = [_tasksArray objectAtIndex:[indexPath row]];
        // we passed the details view a cloned task, copy task data into the original task
        // we saved a reference to before pushing the details view
        copyTask( taskUpdating, task );
        
        // persist via oData service call
        [[utils getApp].proxy updateObject:taskUpdating];
        [[utils getApp].proxy saveChanges];
    
        // update the tableView datasource
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Table view data source

////////////////////////////////////////////////////////////////////////
// Customize the number of sections in the table view.
////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


////////////////////////////////////////////////////////////////////////
// Customize the number of rows in the table view.
////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tasksArray count];
}


////////////////////////////////////////////////////////////////////////
// Customize the appearance of table view cells.
////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    tasks_Model_Entities_Tasks *task = [_tasksArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [task getname];    
    NSString *dateString = [task getstarted] ? [dateFormatter stringFromDate:[task getstarted]] : @"Not Yet";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Started: %@", dateString];

    return cell;
}


////////////////////////////////////////////////////////////////////////
// Override to support editing the table view.
////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete from remote database
        [[utils getApp].proxy deleteObject:[_tasksArray objectAtIndex:[indexPath row]]];
        [[utils getApp].proxy saveChanges];
        
        // delete from _tasksArray
        [_tasksArray removeObjectAtIndex:[indexPath row]];                           
                        
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];            
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}


#pragma mark -
#pragma mark Table view delegate

////////////////////////////////////////////////////////////////////////
// didSelectRowAtIndexPath
////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    [self pushDetailsWithIndexPath:indexPath];	      
}


#pragma mark -
#pragma mark Memory management

////////////////////////////////////////////////////////////////////////
// didReceiveMemoryWarning
////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


////////////////////////////////////////////////////////////////////////
// viewDidUnload
////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    _jobQueue = nil;
    dateFormatter = nil;
}


////////////////////////////////////////////////////////////////////////
// dealloc
////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [super dealloc];        
    [_tasksArray release];
    [errorString release];
    [_jobQueue release];
    [dateFormatter release];
}


@end

