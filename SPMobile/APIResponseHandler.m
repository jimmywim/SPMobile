//
//  APIResponseHandler.m
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import "APIResponseHandler.h"
#import "RemoteQuery.h"

@implementation APIResponseHandler
@synthesize responseData = _responseData;
@synthesize targetObject;
@synthesize responseCode;

-(id) init
{
    if (self = [super init])
    {
        _responseData = [NSMutableData alloc];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    //NSLog(@"Response Status: %d", [resp statusCode]);
    self.responseCode = [resp statusCode];
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"String sent from server %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    [_responseData appendData:data];
    //[(SPRESTQuery *)targetObject returnValue:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection	 *)connection
{
    //NSString *responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@", responseString);
    // For some really f*cking odd reason, this clears the response.
    [(RemoteQuery *)targetObject returnValue:_responseData statusCode:self.responseCode];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection didFailWithError (connection %p) (code %d) %@ %@ %@",
          connection,
          [error code],
          [error localizedDescription],
          [error localizedFailureReason],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [(RemoteQuery *)targetObject returnedBadError:error];
}
@end
