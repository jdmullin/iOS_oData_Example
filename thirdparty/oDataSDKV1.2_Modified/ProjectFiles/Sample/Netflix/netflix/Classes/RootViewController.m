
/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "RootViewController.h"
#import "WindowsCredential.h"
#import "ACSCredential.h"
#import "ACSUtil.h"
#import "DetailsViewController.h"
#import "ODataSampleAppAppDelegate.h"
#import "NetflixCatalog.h"
#import "AzureTableCredential.h"
#import "Tables.h"
//#import "DemoService.h"
#import "ODataServiceException.h"
#import "ODataXMlParser.h"

@implementation Table23Aug1
@synthesize m_Name,m_Age,m_Address;

-(id) initWithUri:(NSString *)aUri
{
	self=[super initWithUri:aUri];
	return self;
}
@end

@implementation RootViewController

@synthesize resultArray;


//method to perform service operation for retrieving Movies
//method to perform service operation for retrieving Movies
-(void) functionImport
{
	NetflixCatalog *proxy=[[NetflixCatalog alloc]initWithUri:@"http://odata.netflix.com/Catalog/" credential:nil];
	resultArray =[proxy Seasons];
	int noOfSeasons=[resultArray count];
	for(int i=0;i<noOfSeasons;i++)
	{
		NSLog(@"seasons %d = %@",i+1,[[resultArray objectAtIndex:i] getName]);
	}
	[proxy release];
}

- (void) onAfterReceive:(HttpResponse*)response
{
	NSLog(@"on after receive");
	NSLog(@"http response = %@",[response getHttpMessage]);
}

//method to retrieve all titles
-(void) retrieveTitles
{
	
	NetflixCatalog *proxy=[[NetflixCatalog alloc]initWithUri:@"http://odata.netflix.com/Catalog/" credential:nil];
	DataServiceQuery *query = [proxy titles];
	[query top:50];
	QueryOperationResponse *response = [query execute];
	resultArray =[[response getResult] retain];
	NSLog(@"resultarray...%d",[resultArray count]);
	
	[proxy release];
}


-(void) demoLoadProperty
{
	NetflixCatalog *proxy=[[NetflixCatalog alloc]initWithUri:@"http://odata.netflix.com/Catalog/" credential:nil];
	DataServiceQuery *query=[proxy people];
	[query top:1];
	QueryOperationResponse *response=[query execute];
	//Genre *aGenre
	NetflixCatalog_Model_Person *p=[[response getResult] objectAtIndex:0];
	NSArray *titlesArr=[p getTitlesActedIn];
	NSLog(@"before::%@\n retaincount=%d",titlesArr,[titlesArr retainCount]);
	
	[proxy loadProperty:p propertyName:@"TitlesActedIn" dataServiceQueryContinuation:nil];
	titlesArr=[p getTitlesActedIn];
	NSLog(@"after::%@\n retaincount=%d",titlesArr,[titlesArr retainCount]);	
	
	//[p getTitlesActedIn];
	[proxy loadProperty:p propertyName:@"TitlesActedIn" dataServiceQueryContinuation:nil];
	titlesArr=[p getTitlesActedIn];
	NSLog(@"after same query::%@\n retaincount=%d",titlesArr,[titlesArr retainCount]);	
	
	[proxy release];
}
-(void) loadProperty
{
	NetflixCatalog *proxy=[[NetflixCatalog alloc]initWithUri:@"http://odata.netflix.com/Catalog/" credential:nil];
	DataServiceQuery *query = [proxy genres];
	[query top:1];
	QueryOperationResponse *genreResponse,*titleRespose;
	DataServiceQueryContinuation* nextToken=nil;
	
	genreResponse = [query execute];
	while(genreResponse)
	{
		NSArray* genreArray = [genreResponse getResult];
		int count = [genreArray count];
		
		for(NSUInteger index = 0;index < count ; ++index)
		{
			NSLog(@"%d:%@",index,[[genreArray objectAtIndex:index] getName]);
			do
			{
				titleRespose=[proxy loadProperty:[genreArray objectAtIndex:index] propertyName:@"Titles" dataServiceQueryContinuation:nextToken];
				nextToken=[titleRespose getContinuation:nil];
			}while(nextToken!=nil);
		}
		nextToken=[genreResponse getContinuation:nil];
		if([nextToken getNextLinkUri])
			genreResponse=[proxy executeDSQueryContinuation:nextToken];
		else
			genreResponse=nil;
	}	
	[proxy release];
}


#pragma mark viewDidLoad method
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	@try 
	{
		[self retrieveTitles];
				
	}
	@catch (DataServiceRequestException * e) 
	{
		NSLog(@"exception = %@, %@, %@",[e name],[e reason],[[e getResponse] getError]);
	}	
	@catch (ODataServiceException * e) 
	{
		NSLog(@"exception = %@, %@, %@",[e name],[e reason],[e getDetailedError]);
	
	}	
	@catch (NSException * e) 
	{
		NSLog(@"exception = %@, %@",[e name],[e reason]);
	}	
}

- (void)viewDidUnload {
	[resultArray release];
	resultArray = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[[self navigationController] setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"didReceiveMemoryWarning........");
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if([resultArray count] > 0 )
	{
		NetflixCatalog_Model_Title *t = [resultArray objectAtIndex:indexPath.row];
		cell.textLabel.text = [t getShortName];
		
	}
	return cell;
}


// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NetflixCatalog_Model_Title *t = [resultArray objectAtIndex:indexPath.row];
	DetailsViewController *details = [[DetailsViewController alloc] initWithStyle:UITableViewStylePlain];
	details.items = t;
	[[self navigationController] pushViewController:details animated:YES];
	[details release];
}


- (void)dealloc {
    [super dealloc];
}

- (void)onBeforeSend:(HttpRequest *)request {
}


@end

