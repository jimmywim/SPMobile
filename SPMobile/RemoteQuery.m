//
//  RemoteQuery.m
//  SPMobile
//
//  Created by James Love on 15/05/2013.
//
//

#import <Foundation/Foundation.h>
#import "RemoteQuery.h"
#import "SMXMLDocument.h"
#import "RequestDigest.h"
#import "CookieStore.h"
#import "APIResponseHandler.h"

@implementation RemoteQuery

@synthesize delegate;
@synthesize queryUrl;
@synthesize fullQueryUri;
@synthesize requestId = _requestId;
@synthesize includeFormDigest;
@synthesize requestMethod;
@synthesize attachedFile;
@synthesize payload;
@synthesize soapAction;

-(id) initWithUrl:(NSString *)url
{
    if (self = [super init])
    {
        queryUrl = url;
        fullQueryUri = [NSURL URLWithString:[queryUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        includeFormDigest = YES;
        requestMethod = @"GET";
    }
    
    return self;
}

-(id)initWithUrlRequestId:(NSString *)url id:(NSString *)requestId
{
    if (self = [self initWithUrl:url])
    {
        _requestId = requestId;
    }
    
    return self;
}

-(void)executeQuery
{
    NSMutableURLRequest *apiRequest = [[NSMutableURLRequest alloc] initWithURL:fullQueryUri];
    [apiRequest setValue:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"  forHTTPHeaderField:@"User-Agent"];
    //[apiRequest setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //[apiRequest setValue:@"ISO-8859-1,utf-8;q=0.7,*;q=0.3" forHTTPHeaderField:@"Accept-Charset"];
    [apiRequest setValue:requestMethod forHTTPHeaderField:@"METHOD"];
    [apiRequest setHTTPMethod:requestMethod];
    
    // Include Request Digest, if asked
    if (includeFormDigest)
    {
        [RequestDigest ValidateRequestDigest];
        [apiRequest setValue:[[RequestDigest sharedRequestDigest] formDigest] forHTTPHeaderField:@"X-RequestDigest"];
    }
    
    // Attach authorisation cookies
    NSMutableArray *cookiesArray = [CookieStore getSharedAuthCookies:fullQueryUri];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookiesArray];
    [apiRequest setAllHTTPHeaderFields:headers];
    
    // Attach a payload, if defined
    if ([attachedFile length] > 0)
        [apiRequest setHTTPBody:attachedFile];
    
    if([payload length] > 0)
        [apiRequest setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    
    if([soapAction length] > 0)
    {
        [apiRequest setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
        [apiRequest setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    
    APIResponseHandler *apiHandler = [[APIResponseHandler alloc] init];
    apiHandler.targetObject = self;
    
    (void)[[NSURLConnection alloc] initWithRequest:apiRequest delegate:apiHandler];
}

-(void) returnValue:(NSData *)returnedData statusCode:(NSInteger) statusCode
{
    // Load the returned string into XML and pass it to this instance's delegate for the
    // client app to consume
    NSString* returnedString = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
    //NSLog(@"Returned Data:%@", returnedString);
    //NSError *error;
    
    //SMXMLDocument *document = [SMXMLDocument documentWithData:returnedData error:&error];
    
    if(statusCode == 401)
    {
        [delegate RemoteQuery:self didCompleteWithAuthFailure:nil];
        return;
    }
    
    if ([_requestId length] == 0)
    {
        [delegate RemoteQuery:self didCompleteQuery:returnedString];
    }
    else
    {
        [delegate RemoteQuery:self didCompleteQueryWithRequestId:returnedString requestId:_requestId];
    }
}

-(void) returnedBadError:(NSError* )error
{
    [delegate RemoteQuery:self didCompleteWithFailure:error];
}
@end
