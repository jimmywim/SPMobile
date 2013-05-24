//
//  CookieStore.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import <Foundation/Foundation.h>

@interface CookieStore : NSObject
@property (nonatomic, retain) NSString *fedAuth;
@property (nonatomic, retain) NSString *rtFa;
@property (nonatomic, retain) NSString *siteUrl;

+(CookieStore *)sharedAuthCookie;
+(NSMutableArray *)getSharedAuthCookies:(NSURL *)apiUri;
@end
