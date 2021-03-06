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
/**
* Defines default Data Service URL for this proxy class
*/
#define DEFAULT_SERVICE_URL @""


#define DataServiceVersion @"2.0"

#import "ODataObject.h"
#import "ObjectContext.h"
#import "DataServiceQuery.h"
#import "ODataGUID.h"
#import "ODataBool.h"
#import  "mProperties.h"


/**
 * @interface:Tasks
 * @Type:EntityType
 
 * @key:id* 
 */
@interface tasks_Model_Entities_Tasks : ODataObject
{
	
	/**
	* @Type:EntityProperty
	* NotNullable
	* @EdmType:Edm.Int32
	*/
	NSNumber *m_id;
	
	/**
	* @Type:EntityProperty
	* NotNullable
	* @EdmType:Edm.Decimal
	*/
	NSDecimalNumber *m_rowversion;
	
	/**
	* @Type:EntityProperty
	* @EdmType:Edm.String
	* @MaxLength:50
	* @FixedLength:true
	*/
	NSString *m_name;
	
	/**
	* @Type:EntityProperty
	* @EdmType:Edm.DateTime
	*/
	NSDate *m_started;
	
	/**
	* @Type:EntityProperty
	* @EdmType:Edm.DateTime
	*/
	NSDate *m_finished;
	
}

@property ( nonatomic , retain , getter=getid , setter=setid )NSNumber *m_id;
@property ( nonatomic , retain , getter=getrowversion , setter=setrowversion )NSDecimalNumber *m_rowversion;
@property ( nonatomic , retain , getter=getname , setter=setname ) NSString *m_name;
@property ( nonatomic , retain , getter=getstarted , setter=setstarted )NSDate *m_started;
@property ( nonatomic , retain , getter=getfinished , setter=setfinished )NSDate *m_finished;

+ (id) CreateTasksWithid:(NSNumber *)aid rowversion:(NSDecimalNumber *)arowversion;
- (id) init;
- (id) initWithUri:(NSString*)anUri;
@end

/**
 * @interface:Task_resources
 * @Type:EntityType
 * 
 */
@interface tasks_Model_Entities_Task_resources : ODataObject
{
	
	/**
	* @Type:EntityProperty
	* @EdmType:Edm.Int32
	*/
	NSNumber *m_task_id;
	
	/**
	* @Type:EntityProperty
	* @EdmType:Edm.Int32
	*/
	NSNumber *m_resource_id;
	
}

@property ( nonatomic , retain , getter=gettask_id , setter=settask_id )NSNumber *m_task_id;
@property ( nonatomic , retain , getter=getresource_id , setter=setresource_id )NSNumber *m_resource_id;

+ (id) CreateTask_resources;
- (id) init;
- (id) initWithUri:(NSString*)anUri;
@end

/**
 * @interface:Resources
 * @Type:EntityType
 
 * @key:id* 
 */
@interface tasks_Model_Entities_Resources : ODataObject
{
	
	/**
	* @Type:EntityProperty
	* NotNullable
	* @EdmType:Edm.Int32
	*/
	NSNumber *m_id;
	
	/**
	* @Type:EntityProperty
	* @EdmType:Edm.String
	* @MaxLength:50
	* @FixedLength:true
	*/
	NSString *m_name;
	
	/**
	* @Type:EntityProperty
	* @EdmType:Edm.String
	* @MaxLength:50
	* @FixedLength:true
	*/
	NSString *m_role;
	
}

@property ( nonatomic , retain , getter=getid , setter=setid )NSNumber *m_id;
@property ( nonatomic , retain , getter=getname , setter=setname ) NSString *m_name;
@property ( nonatomic , retain , getter=getrole , setter=setrole ) NSString *m_role;

+ (id) CreateResourcesWithid:(NSNumber *)aid;
- (id) init;
- (id) initWithUri:(NSString*)anUri;
@end

/**
 * Container interface tasksData, Namespace: tasks.Model.Entities
 */
@interface tasksData : ObjectContext
{
	 NSString *m_OData_etag;
	 DataServiceQuery *m_Tasks;
	 DataServiceQuery *m_Task_resources;
	 DataServiceQuery *m_Resources;
	
}

@property ( nonatomic , retain , getter=getEtag , setter=setEtag )NSString *m_OData_etag;
@property ( nonatomic , retain , getter=getTasks , setter=setTasks ) DataServiceQuery *m_Tasks;
@property ( nonatomic , retain , getter=getTask_resources , setter=setTask_resources ) DataServiceQuery *m_Task_resources;
@property ( nonatomic , retain , getter=getResources , setter=setResources ) DataServiceQuery *m_Resources;

- (id) init;
- (id) initWithUri:(NSString*)anUri credential:(id)acredential;
- (id) tasks;
- (id) task_resources;
- (id) resources;
- (void) addToTasks:(id)anObject;
- (void) addToTask_resources:(id)anObject;
- (void) addToResources:(id)anObject;

@end
