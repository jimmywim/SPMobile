//
//  RequestDigest.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import <Foundation/Foundation.h>

@interface RequestDigest : NSObject
@property (nonatomic, retain) NSString *formDigest;
@property (nonatomic, retain) NSString *siteUrl;
@property (nonatomic, retain) NSDate *digestExpiry;

+(RequestDigest *)sharedRequestDigest;
+(NSString *)getFormDigest;

+(void)ValidateRequestDigest;
@end
