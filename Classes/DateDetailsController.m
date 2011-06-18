//
//  DateDetailsController.m
//  oDataDemo1
//
//  Created by Jeremy Mullin on 6/14/11.
//  Copyright 2011 Sybase. All rights reserved.
//

#import "DateDetailsController.h"


@implementation DateDetailsController

@synthesize dateName, dateValue, customSwitch, delegate;

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
    [dateName release];
    [dateValue release];
    [datePicker release];
    [headerTableView release];
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


#pragma mark - Custom Switch Delegate

////////////////////////////////////////////////////////////////////////
// callback when our yes/no switch is touched
////////////////////////////////////////////////////////////////////////
- (void) valueChanged:(BOOL)value {
    [datePicker setEnabled:value];
}


#pragma mark - View lifecycle

////////////////////////////////////////////////////////////////////////
// viewDidLoad
////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.        
}


////////////////////////////////////////////////////////////////////////
// viewDidUnload
////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [datePicker release];
    datePicker = nil;
    [self setCustomSwitch:nil];
    [headerTableView release];
    headerTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


////////////////////////////////////////////////////////////////////////
// viewWillAppear
////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    self.title = dateName;   
    // snug our datepicker right below the tableView
    datePicker.frame = CGRectMake( 0, headerTableView.frame.size.height, datePicker.frame.size.width, datePicker.frame.size.height );
}


////////////////////////////////////////////////////////////////////////
// viewWillDisappear
////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    // delegate is responsible for doing something with the date
    [delegate didCloseWithDate: ( [self.customSwitch isOn] ) ? datePicker.date : nil whosNameIs:self.title];
}


////////////////////////////////////////////////////////////////////////
// shouldAutorotateToInterfaceOrientation
////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return 1;
}


////////////////////////////////////////////////////////////////////////
// Customize the appearance of table view cells.
////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        // This cell houses our switcher, and shouldn't be highlighted when touched
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Add custom switch with yes/no instead of on/off, got this implementation from:
        // https://github.com/pcrawfor/PCCustomSwitch
        self.customSwitch = [[PCCustomSwitch alloc] initWithFrame:CGRectMake(0, 0, 94, 27)];
        self.customSwitch.userInteractionEnabled = YES;
        self.customSwitch.delegate = self;
        [self.customSwitch setLeftLabelText: @"YES"];
        [self.customSwitch setRightLabelText: @" NO"];        
        cell.accessoryView = self.customSwitch;
    }
    
	// Configure the cell.
    cell.textLabel.text = dateName;
                
    [self.customSwitch setOn:NO];                    
    [datePicker setEnabled:NO];
    
    if ( dateValue != nil ) {
        [datePicker setDate:dateValue];
        [self.customSwitch setOn:YES];
        [datePicker setEnabled:YES];
    }
    
    return cell;
}

@end
