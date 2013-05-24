//
//  ReplyDelegate.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import <Foundation/Foundation.h>

@interface ReplyDelegate : NSObject
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSObject *initiatingObject;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) NSString *siteUrl;
@end
