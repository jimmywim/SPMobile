//
//  Authentication.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import <Foundation/Foundation.h>
#import "ReplyDelegate.h"
#import "DelegateProtocol.h"

@class SPAuthentication;
//@protocol   SPAuthenticationDelegate <NSObject>
//@optional
//- (void)authentication: (SPAuthentication *)didAuthenticate;
//- (void)authentication: (SPAuthentication *)didFailWithError: (NSError *)error;
//@end

@interface Authentication : NSObject
{
    id<SPDelegate> authDelegate;
}
@property (nonatomic, retain) NSMutableData *tokenResponse;
@property (nonatomic, retain) id <SPDelegate> authdelegate;
@property (nonatomic, readonly) ReplyDelegate *wsReply;
@property (nonatomic, retain) NSString *soapTemplate;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *siteUrl;

-(id)initWithUsernamePasswordSite: (NSString *)uname password:(NSString *)pword site:(NSString *)site;
-(void) authenticate;
-(NSString *)hasError;

@end