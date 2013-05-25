//
//  SPOAuthentication.m
//  SPMobile
//
//  Created by James Love on 15/05/2013.
//
//

#import "SPOAuthentication.h"
#import "Utilities.h"
#import "SMXMLDocument.h"
#import "ReplyDelegate.h"
#import "RequestDigest.h"

@implementation SPOAuthentication

@synthesize tokenResponse;
@synthesize authdelegate = _tokenDelegate;
@synthesize username;
@synthesize password;
@synthesize siteUrl;
@synthesize soapTemplate;
@synthesize wsReply;

-(id) init
{
    if (self = [super init])
    {
    }
    
    return self;
}

-(id) initWithUsernamePasswordSite: (NSString *)uname password:(NSString *)pword site:(NSString *)site
{
    if (self = [self init])
    {
        soapTemplate =  @"<?xml version=\"1.0\" encoding=\"utf-8\"?><s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:u=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\"><s:Header><a:Action s:mustUnderstand=\"1\">http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action><a:MessageID>urn:uuid:%@</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">https://login.microsoftonline.com/extSTS.srf</a:To><o:Security s:mustUnderstand=\"1\" xmlns:o=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\"><u:Timestamp u:Id=\"_0\"><u:Created>%@</u:Created><u:Expires>%@</u:Expires></u:Timestamp><o:UsernameToken u:Id=\"uuid-%@-1\"><o:Username>%@</o:Username><o:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">%@</o:Password></o:UsernameToken></o:Security></s:Header><s:Body><t:RequestSecurityToken xmlns:t=\"http://schemas.xmlsoap.org/ws/2005/02/trust\"><wsp:AppliesTo xmlns:wsp=\"http://schemas.xmlsoap.org/ws/2004/09/policy\"><a:EndpointReference><a:Address>%@/_forms/default.aspx?wa=wsignin1.0</a:Address></a:EndpointReference></wsp:AppliesTo><t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType><t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType><t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType></t:RequestSecurityToken></s:Body></s:Envelope>";
        
        username = uname;
        password = pword;
        siteUrl = site;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        
        NSDate *timeNow = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDate *timeExpiry = [NSDate dateWithTimeIntervalSinceNow:300];
        
        NSString *msgId = [[Utilities GetUUID] lowercaseString];
        NSString *usernameTokenId = [[Utilities GetUUID] lowercaseString];
        
        soapTemplate = [NSString stringWithFormat:soapTemplate, msgId, [dateFormatter stringFromDate:timeNow], [dateFormatter stringFromDate:timeExpiry], usernameTokenId, username, password, siteUrl];
    }
    
    return self;
}

-(void) authenticate
{
    NSURL *stsUrl = [NSURL URLWithString:@"https://login.microsoftonline.com/extSTS.srf"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:stsUrl];
    [theRequest setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"  forHTTPHeaderField:@"User-Agent"];
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setHTTPBody:[soapTemplate dataUsingEncoding:NSUTF8StringEncoding]];
    
    (void)[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    tokenResponse = [NSMutableData alloc];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"TokenResponse Received");
    [tokenResponse setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(newStr);
    
    NSLog(@"Token Data Received");
    [tokenResponse appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection	 *)connection
{
    // Uncomment for debug
    NSString *xmlData = [[NSString alloc] initWithBytes:[tokenResponse mutableBytes] length:[tokenResponse length] encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@", xmlData);
    
//    if([tokenResponse length] == 0)
//    {
//        NSLog(@"Response was blank :(");
//        return;
//    }
    
    NSError *error;
    SMXMLDocument *document = [SMXMLDocument documentWithData:tokenResponse error:&error];
    
    SMXMLElement *bodyElement = [document.root childNamed:@"Body"];
    SMXMLElement *tokenResponseElement = [bodyElement childNamed:@"RequestSecurityTokenResponse"];

    SMXMLElement *requestedTokenElement = [tokenResponseElement childNamed:@"RequestedSecurityToken"];
    NSString *securityToken = [requestedTokenElement valueWithPath:@"BinarySecurityToken"];

    
    if([securityToken length] == 0 || [securityToken length] == 0)
    {
        NSLog(@"Security token or Expirey is empty :(");
        return;
    }
    
    //NSLog(@"Got the security token, sending it to the site...");
    
    
    // Lets get dem cookies
    // om nom nom nom
    //NSMutableString *loginUrl = [[NSMutableString alloc] initWithString: siteUrl];
    NSURL *authServer = [NSURL URLWithString:siteUrl];
    NSMutableString *authServerUrl = [NSMutableString stringWithString:authServer.scheme];
    [authServerUrl appendString:@"://"];
    [authServerUrl appendString:authServer.host];
    
    NSMutableString *loginUrl = [[NSMutableString alloc] initWithString: authServerUrl];
    [loginUrl appendString:@"/_forms/default.aspx?wa=wsignin1.0"];
    
    
    NSURL *wReplyUrl = [NSURL URLWithString:loginUrl];
    NSMutableURLRequest *secondRequest = [[NSMutableURLRequest alloc] initWithURL:wReplyUrl];
    [secondRequest setHTTPMethod:@"POST"];
    [secondRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [secondRequest setValue:@"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"  forHTTPHeaderField:@"User-Agent"];
    [secondRequest setHTTPBody:[securityToken dataUsingEncoding:NSUTF8StringEncoding]];
    
    //using custom delegate
    wsReply = [ReplyDelegate alloc];
    wsReply.initiatingObject = self;
    wsReply.siteUrl = siteUrl;
    
    (void)[[NSURLConnection alloc] initWithRequest:secondRequest delegate:wsReply];
}

-(void)tokensReady: (int)cookieCount
{
    // Now that cookies have been set, let's initialize the RequestDigest before returning back to the caller:
    RequestDigest *digest = [RequestDigest sharedRequestDigest];
    digest.siteUrl = self.siteUrl;
    [RequestDigest ValidateRequestDigest];
    
    [_tokenDelegate authentication:(id)self];
}

-(NSString *)hasError
{
    if ([wsReply.errorMsg length] > 0)
    {
        return wsReply.errorMsg;
    }
    
    return @"";
}
@end
