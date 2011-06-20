
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

#import "HTTPHandler.h"
#import <Security/Security.h>

@implementation HTTPHandler

@synthesize http_response,http_error,http_status_code,http_response_headers,user_name,password;

/**
 * Perform a HTTP request and store response 
 *
 * @param NSString user name required for HTTP request
 * @param NSString password required for HTTP request
 * @param NSMutableDictionary collections of HTTP request headers
 * @param NSData HTTP request body
 * @param NSString HTTP method 
 * @return NULL
 */
-(void) performHTTPRequest:(NSString *)url username:(NSString *)usr password:(NSString *)pwd headers:(NSMutableDictionary *)dict httpbody:(NSData *)body httpmethod:(NSString *)method certTrust:(BOOL)trust
{
	NSMutableDictionary *requestHeaders=dict;

	done = NO;
	[self setUsername:usr]; 
	[self setPassword:pwd];
	trustServer = trust;
	http_response = [[NSMutableData alloc]init];
	http_status_code = 0;
	http_response_headers = [[NSMutableDictionary alloc] init];
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];

	if(dict != nil)
	{
		id key, value;
		NSArray *keys = [dict allKeys];
		int count = [keys count];
		for (int i = 0; i < count; i++)
		{
			key = [keys objectAtIndex: i];
			value = [requestHeaders objectForKey: key];
			[theRequest setValue:value forHTTPHeaderField:key];
		}
		
	}
	if(body != nil)
		[theRequest setHTTPBody:body];
	
	if(method != nil)
		[theRequest setHTTPMethod:method];
	
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	do {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	} while (!done);
	
	[theConnection release];
}

/*
 * Delegate function for handling HTTP response
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse * httpResponse;
	    
    httpResponse = (NSHTTPURLResponse *) response;
    http_status_code = (ssize_t) httpResponse.statusCode;   
	NSDictionary *dict = [httpResponse allHeaderFields];
	if(dict != nil)
	{
		id key, value;
		NSArray *keys = [dict allKeys];
		int count = [keys count];
		for (int i = 0; i < count; i++)
		{
			key = [keys objectAtIndex: i];
			value = [dict objectForKey: key];
			NSLog(@"%@ == %@ ",key,value);
			[http_response_headers setValue:value forKey:key];
		}
		
	}
}

/*
 * Delegate functions for handling HTTP response
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{	
	NSLog(@"odatagen data =  %@ ",[[[NSString alloc] initWithData:http_response encoding:NSUTF8StringEncoding] autorelease]);
	done = YES;
}

/*  
 * Delegate function for handling HTTP server trust 
 */
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
   return ( ( [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] ) ||
           ( [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] ) );
} 

/*
 * Delegate function for handling HTTP authentication
 */
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{	
	NSLog(@"authentication required");
	NSHTTPURLResponse * httpResponse;
	
    httpResponse = (NSHTTPURLResponse *) [challenge failureResponse];
	
	//NSLog(@"previous failure count=%d",[challenge previousFailureCount]);
   
   if ( [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] )
	{
		SecTrustResultType trustResult;
		OSStatus ret = SecTrustEvaluate( [challenge.protectionSpace serverTrust], &trustResult );
		if ( ret != errSecSuccess )
		{
			// throw an exception here or just log and cancel? 
			NSLog( @"server trust check failed with error %d", ret );
         @throw [NSException exceptionWithName:@"Security Error" reason:@"Server trust check failed." userInfo:nil];
			//[[challenge sender] cancelAuthenticationChallenge:challenge]; 		
		}

      // If we are trusting the server, continue even if kSecTrustResultRecoverableTrustFailure,
      // which means there was a certificate error.
		if ( ( ( trustResult == kSecTrustResultRecoverableTrustFailure ) && trustServer ) ||
           ( ( trustResult == kSecTrustResultConfirm ) && trustServer ) ||
			  ( trustResult == kSecTrustResultProceed ) ||
           ( trustResult == kSecTrustResultUnspecified ) )
		{
		   [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
		}
		else
		{
			// Not actively handling any of the other trust constants as the rest are failures, so cancel
			// See http://developer.apple.com/library/ios/#documentation/Security/Reference/certifkeytrustservices/Reference/reference.html%23//apple_ref/c/tdef/SecTrustResultType 
         NSLog( @"server trust failure with trustResult: %d", trustResult );
			[[challenge sender] cancelAuthenticationChallenge:challenge]; 		
		}				
	}		
	else if ([challenge previousFailureCount] == 0)
	{
		[[challenge sender] useCredential:[NSURLCredential credentialWithUser:user_name password:password persistence:NSURLCredentialPersistenceForSession] forAuthenticationChallenge:challenge];
	} 
	else 
	{
		NSLog(@"Authentication failed for Username=%@, Password=%@",user_name,password);
		[[challenge sender] cancelAuthenticationChallenge:challenge]; 		
	}
}
/*
 * Delegate function for handling HTTP connection
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

/*
 * Delegate functions for handling HTTP response error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    http_error = [error retain];
	done = YES;
	@throw [NSException exceptionWithName:@"Connection error" reason:[NSString stringWithFormat:@"%@ Error Code:%d",[error localizedDescription],[error code]] userInfo:nil];
}

/*
 * Delegate function for handling HTTP data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the downloaded chunk of data.
    [http_response appendData:[data copy]];
}

- (void)dealloc 
{
	[user_name release];
	user_name=nil;
	[password release];
	password=nil;
	[http_response release];
	http_response=nil;
	[http_error release];
	http_error=nil;
	[http_response_headers release];
	http_response_headers=nil;
    [super dealloc];
}

@end
