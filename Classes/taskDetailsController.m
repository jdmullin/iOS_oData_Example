//
//  taskDetailsController.m
//  oDataDemo1
//
//  Created by Jeremy Mullin on 5/31/11.
//  Copyright 2011 Sybase. All rights reserved.
//

#import "TaskDetailsController.h"
#import "DateDetailsController.h"

@implementation TaskDetailsController
@synthesize taskDatePicker, task, taskIndexPath;
@synthesize delegate;

////////////////////////////////////////////////////////////////////////
// initWithNibName
////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


////////////////////////////////////////////////////////////////////////
// dealloc
////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [taskDatePicker release];
    [task release];
    [taskIndexPath release];
    [taskDetailsTable release];
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////
// didReceiveMemoryWarning
////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Date Details Delegate

////////////////////////////////////////////////////////////////////////
// Callback when date details view closes
////////////////////////////////////////////////////////////////////////
- (void)didCloseWithDate:(NSDate*)date whosNameIs:(NSString*)name {
    if ( name == @"Started" ) {
        [self.task setstarted:date];
    }
    else {
        [self.task setfinished:date];
    }
    
    // refresh table
    [taskDetailsTable reloadData];
}


#pragma mark - TextField Delegate

////////////////////////////////////////////////////////////////////////
// callback to hide the keyboard when the user hits "done"
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
	return NO;
}


#pragma mark - View lifecycle

////////////////////////////////////////////////////////////////////////
// viewDidLoad
////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Task Details";
    
    // Add save button to nav bar
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    
    // Add cancel button to nav bar
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];        
}


////////////////////////////////////////////////////////////////////////
// viewDidUnload
////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [self setTaskDatePicker:nil];
    [self setTask:nil];
    [self setTaskIndexPath:nil];
    [taskDetailsTable release];
    taskDetailsTable = nil;
    [super viewDidUnload];
}


////////////////////////////////////////////////////////////////////////
// viewWillAppear
////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    UITableViewCell *cell = [taskDetailsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *textView = (UITextField*)([cell.contentView.subviews objectAtIndex:0]);
    if ( textView.text == nil )
        [textView becomeFirstResponder];
}


////////////////////////////////////////////////////////////////////////
// shouldAutorotateToInterfaceOrientation
////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Save and cancel button event handlers

////////////////////////////////////////////////////////////////////////
// Grab text field from the table cell and save the task name
////////////////////////////////////////////////////////////////////////
- (void)saveTaskName {
    UITableViewCell *cell = [taskDetailsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *textView = (UITextField*)([cell.contentView.subviews objectAtIndex:0]);
    [self.task setname:textView.text];    
}


////////////////////////////////////////////////////////////////////////
// event for save button touched
////////////////////////////////////////////////////////////////////////
- (void)save {            
    // save name
    [self saveTaskName];
     
    // delegate is resonsible for saving tasks and closing this view
    if ( self.taskIndexPath == nil )
        [delegate didAddTask:self.task];    
    else
        [delegate didUpdateTask:self.task atIndexPath:self.taskIndexPath];         
}


////////////////////////////////////////////////////////////////////////
// event for cancel button touched
////////////////////////////////////////////////////////////////////////
- (void)cancel {
    [delegate didAddTask:nil];
}

#pragma mark -
#pragma mark Table view data source

////////////////////////////////////////////////////////////////////////
// Customize the number of sections in the table view.
////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


////////////////////////////////////////////////////////////////////////
// Customize the number of rows in the table view.
////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( section == 0 )
        return 1;
    else
        return 2;
}


////////////////////////////////////////////////////////////////////////
// Customize the appearance of table view cells.
////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        if ( [indexPath section] == 0 ) {
            // Embed text field in this cell
            UITextField *textView = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 220, 31)];
            textView.font = [UIFont fontWithName:@"Helvetica" size:17];           
            textView.delegate = self;
            [cell.contentView addSubview:textView];
            [textView release];
            
            // This cell houses our switcher, and shouldn't be highlighted when touched
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
	// Configure the cell.
    if ( [indexPath section] == 0 ) {
        UITextField *textView = (UITextField*)([cell.contentView.subviews objectAtIndex:0]);
        textView.text = [task getname];
    }
    else {
        NSDate *theDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];        
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        if ( [indexPath row] == 0 ) {
            cell.textLabel.text = @"Started";
            theDate = [self.task getstarted];            
        }
        else {
            cell.textLabel.text = @"Finished";
            theDate = [self.task getfinished];
        }
        
        cell.detailTextLabel.text = ( theDate == nil ) ? @"" : [dateFormatter stringFromDate:theDate];                        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [dateFormatter release];        
    }           
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

////////////////////////////////////////////////////////////////////////
// row in table selected, push date details view
////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    if ( [indexPath section] == 1 ) {
        // If user modified the task name we need to save it before switch views or the modifications
        // will be lost when the table reloads the cell data.
        [self saveTaskName];
        
        DateDetailsController *detailViewController = [[DateDetailsController alloc] initWithNibName:@"DateDetailsController" bundle:nil];
        detailViewController.dateName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        detailViewController.dateValue = ( [indexPath row] == 0 ) ? [self.task getstarted] : [self.task getfinished];
        detailViewController.delegate = self;
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}


@end
