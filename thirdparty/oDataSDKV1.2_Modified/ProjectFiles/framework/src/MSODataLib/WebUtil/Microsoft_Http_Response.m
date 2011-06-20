
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

#import "Microsoft_Http_Response.h"


@implementation Microsoft_Http_Response

@synthesize m_version;
@synthesize m_code;
@synthesize m_message;
@synthesize m_headers;
@synthesize m_body;

-(void)dealloc
{
	[m_version release];
	m_version = nil;
    [m_message release];
	m_message = nil;
    [m_headers release];
	m_headers = nil;
    [m_body release];
	m_body = nil;
	[super dealloc];
}

-(id)initWithCode:(NSInteger)code responseheaders:(NSMutableDictionary  *)headers responseBody:(NSString *)body responseVersion:(NSString *)version responseMessage:(NSString *)message
{
	if(self = [super init])
	{
		[self setCode:code];
		[self setHeaders:headers];
		[self setBody:body];
		[self setVersion:version];
		[self setMessage:message];
	}
	return self;
}

+ (Microsoft_Http_Response *) fromString:(NSString *)response_str
{
	NSInteger code    = [self extractCode:response_str];
	NSMutableDictionary *headers = [self extractHeaders:response_str];
	NSString *body    = [self extractBody:response_str];
	NSString *version = [self extractVersion:response_str];
	NSString *message = [self extractMessage:response_str];
	
	Microsoft_Http_Response *response = [[Microsoft_Http_Response alloc] initWithCode:code responseheaders:headers responseBody:body responseVersion:version responseMessage:message];
	return [response autorelease];
}

+ (NSInteger)extractCode:(NSString *)response_str
{	
	NSInteger code = 0;
	NSArray *httpElements = [response_str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|^HTTP/[\\d\\.x]+ (\\d+)|"]];
	if([httpElements count] > 1)
	{
		NSString *codestr = [httpElements objectAtIndex:1];
		code = [codestr intValue];
	}
	else
	{
		code = -1; 
	}
	return code;
}

+ (NSMutableDictionary *)extractHeaders:(NSString *)response_str
{
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	NSArray *parts = nil;
	
	parts = [response_str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|(?:\\r?\\n){2}|m"]];
	
	if([parts count] == 0)
		return headers;
	
	NSString *linesStr = [parts objectAtIndex:0];
	NSArray *lines = [linesStr componentsSeparatedByString:@"\\n"];
	
	for(int i=0;i<[lines count];i++)
	{
		NSString *line = [lines objectAtIndex:i];
		if([line isEqualToString:@""])
			break;
		
		NSArray *m = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|^([\\w-]+):\\s+(.+)|"]];
		
		if([m count]>2)
		{
			NSString *hName = [m objectAtIndex:1];
			NSString *hValue = [m objectAtIndex:2];
			if(hName != nil && hValue != nil)
				[headers setObject:hValue forKey:hName];
		} 
	}
	return [headers autorelease];
}

+ (NSString *)extractBody:(NSString *)response_str
{
	NSString *body = nil;
	NSArray *httpElements = [response_str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|(?:\r?\n){2}|m"]];
	if([httpElements count] > 1)
	{
		body = [httpElements objectAtIndex:1];
	}
	return body;
}

+ (NSString *)extractVersion:(NSString *)response_str
{
	NSString *version = nil;
	NSArray *elements = [response_str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|^HTTP/([\\d\\.x]+) \\d+|"]];
	if([elements count] > 1)
	{
		version = [elements objectAtIndex:1];
	}
	return version;
}

+ (NSString *)extractMessage:(NSString *)response_str
{	
	NSString *message = nil;
	NSArray *elements = [response_str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|^HTTP/[\\d\\.x]+ \\d+ ([^\\r\\n]+)|"]];
	if([elements count] > 1)
	{
		message = [elements objectAtIndex:1];
	}
	return message;
}

@end
