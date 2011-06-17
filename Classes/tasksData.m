/**
*
*Copyright 2010 Microsoft Corp
*
*Licensed under the Apache License, Version 2.0 (the "License");
*you may not use this file except in compliance with the License.
*You may obtain a copy of the License at
*
*http://www.apache.org/licenses/LICENSE-2.0
*
*Unless required by applicable law or agreed to in writing, software
*distributed under the License is distributed on an "AS IS" BASIS,
*WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*See the License for the specific language governing permissions and
*limitations under the License.
*/
/**
* This code was generated by the tool 'odatagen'.
* Runtime Version:1.0
*
* Changes to this file may cause incorrect behavior and will be lost if
* the code is regenerated.
*/
#import "tasksData.h"
/**
 * @interface:Tasks
 * @key:id
 */
@implementation tasks_Model_Entities_Tasks
	@synthesize m_id;
	@synthesize m_rowversion;
	@synthesize m_name;
	@synthesize m_started;
	@synthesize m_finished;

/**
 *Method to create an instance of Tasks
 */
+ (id) CreateTasksWithid:(NSNumber *)aid rowversion:(NSDecimalNumber *)arowversion
{
	tasks_Model_Entities_Tasks *aTasks = [[tasks_Model_Entities_Tasks alloc]init];
	
	aTasks.m_id = aid;

	
	aTasks.m_rowversion = arowversion;

	return aTasks;
}
/**
 * Initialising object for Tasks
 */
- (id) init
{
	self=[self initWithUri:nil];
	return self;
}

- (id) initWithUri:(NSString*)anUri 
{
	if(self=[super initWithUri:anUri])
	{
		[self setBaseURI:anUri];
		m_OData_hasStream.booleanvalue=NO;
		mProperties *obj;
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.Int32" MaxLength:@"" MinLength:@"" FixedLength:NO Nullable:NO Unicode:NO ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_id"];
		[obj release];
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.Decimal" MaxLength:@"" MinLength:@"" FixedLength:NO Nullable:NO Unicode:NO ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_rowversion"];
		[obj release];
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.String" MaxLength:@"50" MinLength:@"" FixedLength:YES Nullable:NO Unicode:YES ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_name"];
		[obj release];
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.DateTime" MaxLength:@"" MinLength:@"" FixedLength:NO Nullable:NO Unicode:NO ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_started"];
		[obj release];
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.DateTime" MaxLength:@"" MinLength:@"" FixedLength:NO Nullable:NO Unicode:NO ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_finished"];
		[obj release];
		

		NSMutableArray *anEntityKey=[[NSMutableArray alloc]init];
		[anEntityKey addObject:@"id"];
		[m_OData_entityKey setObject:anEntityKey forKey:@"Tasks"];
		[anEntityKey release];
	}
	return self;
}

-(NSMutableArray *)getSyndicateArray
{
	NSMutableArray *syndicateArray=[[NSMutableArray alloc]init];
	
	return [syndicateArray autorelease];
}
-(tasks_Model_Entities_Tasks *)getDeepCopy
{
	tasks_Model_Entities_Tasks *obj=[[tasks_Model_Entities_Tasks alloc]initWithUri:[self getBaseURI]];
	[obj setid:[self getid]];
	[obj setrowversion:[self getrowversion]];
	[obj setname:[self getname]];
	[obj setstarted:[self getstarted]];
	[obj setfinished:[self getfinished]];

	return [obj autorelease];
}
- (void) dealloc
{
	[m_id release];
	m_id = nil;
	[m_rowversion release];
	m_rowversion = nil;
	[m_name release];
	m_name = nil;
	[m_started release];
	m_started = nil;
	[m_finished release];
	m_finished = nil;
	
	[super dealloc];
}

@end
/**
 * @interface:Task_resources
 */
@implementation tasks_Model_Entities_Task_resources
	@synthesize m_task_id;
	@synthesize m_resource_id;

/**
 *Method to create an instance of Task_resources
 */
+ (id) CreateTask_resources
{
	tasks_Model_Entities_Task_resources *aTask_resources = [[tasks_Model_Entities_Task_resources alloc]init];
	return aTask_resources;
}
/**
 * Initialising object for Task_resources
 */
- (id) init
{
	self=[self initWithUri:nil];
	return self;
}

- (id) initWithUri:(NSString*)anUri 
{
	if(self=[super initWithUri:anUri])
	{
		[self setBaseURI:anUri];
		m_OData_hasStream.booleanvalue=NO;
		mProperties *obj;
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.Int32" MaxLength:@"" MinLength:@"" FixedLength:NO Nullable:NO Unicode:NO ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_task_id"];
		[obj release];
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.Int32" MaxLength:@"" MinLength:@"" FixedLength:NO Nullable:NO Unicode:NO ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_resource_id"];
		[obj release];
		

		NSMutableArray *anEntityKey=[[NSMutableArray alloc]init];
		[m_OData_entityKey setObject:anEntityKey forKey:@"Task_resources"];
		[anEntityKey release];
	}
	return self;
}

-(NSMutableArray *)getSyndicateArray
{
	NSMutableArray *syndicateArray=[[NSMutableArray alloc]init];
	
	return [syndicateArray autorelease];
}
-(tasks_Model_Entities_Task_resources *)getDeepCopy
{
	tasks_Model_Entities_Task_resources *obj=[[tasks_Model_Entities_Task_resources alloc]initWithUri:[self getBaseURI]];
	[obj settask_id:[self gettask_id]];
	[obj setresource_id:[self getresource_id]];

	return [obj autorelease];
}
- (void) dealloc
{
	[m_task_id release];
	m_task_id = nil;
	[m_resource_id release];
	m_resource_id = nil;
	
	[super dealloc];
}

@end
/**
 * @interface:Resources
 * @key:id
 */
@implementation tasks_Model_Entities_Resources
	@synthesize m_id;
	@synthesize m_name;
	@synthesize m_role;

/**
 *Method to create an instance of Resources
 */
+ (id) CreateResourcesWithid:(NSNumber *)aid
{
	tasks_Model_Entities_Resources *aResources = [[tasks_Model_Entities_Resources alloc]init];
	
	aResources.m_id = aid;

	return aResources;
}
/**
 * Initialising object for Resources
 */
- (id) init
{
	self=[self initWithUri:nil];
	return self;
}

- (id) initWithUri:(NSString*)anUri 
{
	if(self=[super initWithUri:anUri])
	{
		[self setBaseURI:anUri];
		m_OData_hasStream.booleanvalue=NO;
		mProperties *obj;
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.Int32" MaxLength:@"" MinLength:@"" FixedLength:NO Nullable:NO Unicode:NO ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_id"];
		[obj release];
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.String" MaxLength:@"50" MinLength:@"" FixedLength:YES Nullable:NO Unicode:YES ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_name"];
		[obj release];
		
		obj=[[mProperties alloc]initWithEdmType:@"Edm.String" MaxLength:@"50" MinLength:@"" FixedLength:YES Nullable:NO Unicode:YES ConcurrencyMode:@"" FC_TargetPath:@"" FC_KeepInContent:YES FC_SourcePath:@"" FC_ContentKind:@"" FC_NsPrefix:@"" FC_NsUri:@""];
		[m_OData_propertiesMap setObject:obj forKey:@"m_role"];
		[obj release];
		

		NSMutableArray *anEntityKey=[[NSMutableArray alloc]init];
		[anEntityKey addObject:@"id"];
		[m_OData_entityKey setObject:anEntityKey forKey:@"Resources"];
		[anEntityKey release];
	}
	return self;
}

-(NSMutableArray *)getSyndicateArray
{
	NSMutableArray *syndicateArray=[[NSMutableArray alloc]init];
	
	return [syndicateArray autorelease];
}
-(tasks_Model_Entities_Resources *)getDeepCopy
{
	tasks_Model_Entities_Resources *obj=[[tasks_Model_Entities_Resources alloc]initWithUri:[self getBaseURI]];
	[obj setid:[self getid]];
	[obj setname:[self getname]];
	[obj setrole:[self getrole]];

	return [obj autorelease];
}
- (void) dealloc
{
	[m_id release];
	m_id = nil;
	[m_name release];
	m_name = nil;
	[m_role release];
	m_role = nil;
	
	[super dealloc];
}

@end

 
/**
 * Container interface tasksData, Namespace: tasks.Model.Entities
 */
@implementation tasksData 

	@synthesize m_OData_etag;

	@synthesize m_Tasks;
	@synthesize m_Task_resources;
	@synthesize m_Resources;
/**
 * The initializer for tasksData accepting service URI
 */
- (id) init
{
	NSString* tmpuri =[[NSString alloc]initWithString:DEFAULT_SERVICE_URL];
	self=[self initWithUri:tmpuri credential:nil];
	[tmpuri release];
	return self;
}

- (id) initWithUri:(NSString*)anUri credential:(id)acredential
{
	NSString* tmpuri=nil;
	if([anUri length]==0)
	{
	 	tmpuri = DEFAULT_SERVICE_URL;
	}
	else
	{
		tmpuri =[NSString stringWithString:anUri];
	}
	if(![tmpuri hasSuffix:@"/"])
	{
		tmpuri=[tmpuri stringByAppendingString:@"/"];
	}

	if(self=[super initWithUri:tmpuri credentials:acredential dataServiceVersion:DataServiceVersion])
	{
		[super setServiceNamespace:@"tasks.Model.Entities"];

		NSMutableArray* tempEntities=[[NSMutableArray alloc]init];
		
		[tempEntities addObject:@"Tasks"];
		[tempEntities addObject:@"Task_resources"];
		[tempEntities addObject:@"Resources"];

		if([tempEntities count] > 0 )
		{
			[super setEntitiesWithArray:tempEntities];
		}
		[tempEntities release];

		NSMutableArray* tempEntitiySetKey=[[NSMutableArray alloc]init];
		
		[tempEntitiySetKey addObject:@"tasks"];
		[tempEntitiySetKey addObject:@"task_resources"];
		[tempEntitiySetKey addObject:@"resources"];

		NSMutableArray* tempEntitiyTypeobj=[[NSMutableArray alloc]init];
		
		[tempEntitiyTypeobj addObject:@"Tasks"];
		[tempEntitiyTypeobj addObject:@"Task_resources"];
		[tempEntitiyTypeobj addObject:@"Resources"];

		if( ( [tempEntitiySetKey count] > 0 ) && ( [tempEntitiyTypeobj count] > 0 ) )
		{
			[super setEntitySet2TypeWithObject:tempEntitiyTypeobj forKey:tempEntitiySetKey];

		}

		[tempEntitiySetKey release];
		[ tempEntitiyTypeobj release];

		NSMutableArray* tempEntitiyTypeKey=[[NSMutableArray alloc]init];
		
		[tempEntitiyTypeKey addObject:@"tasks"];
		[tempEntitiyTypeKey addObject:@"task_resources"];
		[tempEntitiyTypeKey addObject:@"resources"];
		NSMutableArray* tempEntitySetObj=[[NSMutableArray alloc]init];
		
		[tempEntitySetObj addObject:@"Tasks"];
		[tempEntitySetObj addObject:@"Task_resources"];
		[tempEntitySetObj addObject:@"Resources"];

		if( ( [tempEntitiyTypeKey count] > 0 ) && ( [tempEntitySetObj count] > 0 ) )
		{
			[super setEntityType2SetWithObject:tempEntitySetObj forKey:tempEntitiyTypeKey];

		}
    	[tempEntitiyTypeKey release];
		[tempEntitySetObj release];

		NSMutableArray* foreignKeys=[[NSMutableArray alloc]init];		

		NSMutableArray *arrOfDictionaries=[[NSMutableArray alloc]initWithCapacity:[foreignKeys count]];
		if( ( [foreignKeys count] > 0 ) && ( [arrOfDictionaries count] > 0 ) )
		{
			[super setAssociationforObjects:arrOfDictionaries forKeys:foreignKeys];
		}
		[foreignKeys release];
		[arrOfDictionaries release];

		m_Tasks = [[DataServiceQuery alloc]initWithUri:@"Tasks" objectContext: self];
		m_Task_resources = [[DataServiceQuery alloc]initWithUri:@"Task_resources" objectContext: self];
		m_Resources = [[DataServiceQuery alloc]initWithUri:@"Resources" objectContext: self];
		
	}
	return self;
}


/**
 * Method returns DataServiceQuery reference for
 * the entityset Tasks
 */
- (id) tasks
{
	[self.m_Tasks clearAllOptions];
	return self.m_Tasks;
}

/**
 * Method returns DataServiceQuery reference for
 * the entityset Task_resources
 */
- (id) task_resources
{
	[self.m_Task_resources clearAllOptions];
	return self.m_Task_resources;
}

/**
 * Method returns DataServiceQuery reference for
 * the entityset Resources
 */
- (id) resources
{
	[self.m_Resources clearAllOptions];
	return self.m_Resources;
}

/**
 * Methods for adding object to the entityset/collection
 */

- (void) addToTasks:(id)anObject
{
	[super addObject:@"Tasks" object:anObject];
}

- (void) addToTask_resources:(id)anObject
{
	[super addObject:@"Task_resources" object:anObject];
}

- (void) addToResources:(id)anObject
{
	[super addObject:@"Resources" object:anObject];
}

- (void) dealloc
{
	[ m_OData_etag release];
	m_OData_etag = nil;
	
	[m_Tasks release];
	m_Tasks = nil;
	[m_Task_resources release];
	m_Task_resources = nil;
	[m_Resources release];
	m_Resources = nil;

	[super dealloc];
}

@end