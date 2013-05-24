//
//  CookieStore.m
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import "CookieStore.h"

@implementation CookieStore

@synthesize fedAuth;
@synthesize rtFa;
@synthesize siteUrl;

static CookieStore *SharedAuthCookie;

+ (CookieStore *)sharedAuthCookie
{
    @synchronized([CookieStore class])
	{
		if (!SharedAuthCookie)
			(void)[[self alloc] init];
        
		return SharedAuthCookie;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([CookieStore class])
	{
		NSAssert(SharedAuthCookie == nil, @"Attempted to allocate a second instance of a singleton.");
		SharedAuthCookie = [super alloc];
		return SharedAuthCookie;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

+(NSMutableArray *)getSharedAuthCookies:(NSURL *)apiUri
{
    NSDictionary *fedAuthCookie = [NSDictionary dictionaryWithObjectsAndKeys:
                                   apiUri, NSHTTPCookieOriginURL,
                                   @"FedAuth", NSHTTPCookieName,
                                   @"/", NSHTTPCookiePath,
                                   [[CookieStore sharedAuthCookie] fedAuth] , NSHTTPCookieValue,
                                   nil];
    
    NSDictionary *rtFaCookie = [NSDictionary dictionaryWithObjectsAndKeys:
                                apiUri, NSHTTPCookieOriginURL,
                                @"rtFa", NSHTTPCookieName,
                                @"/", NSHTTPCookiePath,
                                [[CookieStore sharedAuthCookie] rtFa] , NSHTTPCookieValue,
                                nil];
    
    
    NSHTTPCookie *fedAuthCookieObj = [NSHTTPCookie cookieWithProperties:fedAuthCookie];
    NSHTTPCookie *rtFaCookieObj = [NSHTTPCookie cookieWithProperties:rtFaCookie];
    
    NSMutableArray *cookiesArray = [NSMutableArray arrayWithObjects: fedAuthCookieObj, nil];
    
    if(rtFaCookieObj != nil)
        [cookiesArray addObject:rtFaCookieObj];
    
    return cookiesArray;
}
@end
