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

#import "CredentialBase.h"


@implementation CredentialBase


/**
 * Returns the authentication class type 
 */
-(id) getCredentialType
{
	return nil;
}

/**
 * Store HTTP Proxy
 */
-(void) setProxy:(HttpProxy*) aProxy;
{

}

/**
 * Retrive HTTP headers
 */
- (NSDictionary*) getSignedHeaders:(NSString*)aRequestUrl
{
	return nil;
}

/**
 * Retrive flag if trust server even if certificate issue. 
 * Currently only implemented by WindowsCredential 
 */
- (BOOL) getTrustServer
{
   return NO;
}

@end
