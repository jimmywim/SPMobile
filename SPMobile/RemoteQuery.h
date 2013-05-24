//
//  RemoteQuery.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import <Foundation/Foundation.h>
#import "DelegateProtocol.h"

//@protocol RemoteQueryDelegate <NSObject>
//@optional
//-(void)RemoteQuery:(id)RemoteQuery didCompleteQuery: (NSString *)result;
//-(void)RemoteQuery:(id)RemoteQuery didCompleteQueryWithRequestId: (NSString *)result requestId:(NSString *)requestId;
//-(void)RemoteQuery:(id)RemoteQuery didCompleteWithFailure: (NSError *)error;
//-(void)RemoteQuery:(id)RemoteQuery didCompleteWithAuthFailure: (NSError *)error;
//@end

@interface RemoteQuery : NSObject

@property (nonatomic, weak) id <SPDelegate> delegate;
@property (nonatomic, retain) NSString *queryUrl;
@property (nonatomic, retain) NSURL *fullQueryUri;
@property (nonatomic, retain) NSString *requestId;
@property (nonatomic, retain) NSString *requestMethod;
@property (nonatomic, retain) NSData *attachedFile;
@property (nonatomic, retain) NSString *payload;
@property (nonatomic, retain) NSString *soapAction;

@property BOOL includeFormDigest;

-(id)initWithUrl:(NSString *)url;
-(id)initWithUrlRequestId:(NSString *)url id:(NSString *)requestId;
-(void)executeQuery;
-(void) returnValue:(NSData *)returnedData statusCode:(NSInteger) statusCode;
-(void) returnedBadError:(NSError* )error;

@end