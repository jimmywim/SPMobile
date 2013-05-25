//
//  ReplyDelegate.m
//  SPMobile
//
//  Created by James Love on 15/05/2013.
//
//

#import "ReplyDelegate.h"
#import "CookieStore.h"
#import "SMXMLDocument.h"
#import "Authentication.h"
#import "SPOAuthentication.h"

@implementation ReplyDelegate
@synthesize responseData = _responseData;
@synthesize initiatingObject;
@synthesize errorMsg;
@synthesize siteUrl;

-(id) init
{
    if (self = [super init])
    {
        _responseData = [NSMutableData alloc];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    
    //NSLog(@"%@", redirectResponse.URL);
    
    // First, we'll check for authentication errors.
    NSString* newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if([newStr rangeOfString:@"Fault"].location != NSNotFound)
    {
        NSError *error;
        NSLog(@"Error logging in");
        SMXMLDocument *responseDoc = [[SMXMLDocument alloc] initWithData:_responseData error:&error];
        
        NSString *errorText = [[[[[[responseDoc.root childNamed:@"Body"] childNamed:@"Fault"] childNamed:@"Detail"] childNamed:@"error"] childNamed:@"internalerror"] valueWithPath:@"text"];
        
        errorMsg = [NSString alloc];
        errorMsg = errorText;
        
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)redirectResponse;
    
    NSMutableString *targetSite = [NSMutableString alloc];
    targetSite = [targetSite initWithString:siteUrl];
    [targetSite appendString:@"/_forms/default.aspx?wa=wsignin1.0"];
    
    NSArray *allData = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:[NSURL URLWithString:targetSite]];
    
    
    for(NSHTTPCookie *cookie in allData)
    {
        //NSLog(@"Found cookie: %@", cookie.name);
        
        NSString *cookieName = cookie.name;
        
        if([cookieName isEqualToString:@"FedAuth"])
        {
            [[CookieStore sharedAuthCookie] setFedAuth:cookie.value];
        }
        else if ([cookieName isEqualToString:@"rtFa"])
        {
            [[CookieStore sharedAuthCookie] setRtFa:cookie.value];
        }
    }
    
    [[CookieStore sharedAuthCookie] setSiteUrl:siteUrl];
    
    return request;
}


- (void)connectionDidFinishLoading:(NSURLConnection	 *)connection
{
    // Lets see if the shared cookie handler has the cookies
    // om nom nom nom
    //
    //NSLog(@"FedAuth: %@", [[SPAuthCookies sharedSPAuthCookie] fedAuth]);
    //NSLog(@"rtFa: %@", [[SPAuthCookies sharedSPAuthCookie] rtFa]);
    
    [(SPOAuthentication *)initiatingObject tokensReady: 2];
    
}

@end
