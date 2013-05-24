//
//  DelegateProtocol.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#ifndef SPRocket_DelegateProtocol_h
#define SPRocket_DelegateProtocol_h

@class SPClientCallbackDelegate;

@protocol   SPDelegate <NSObject>
@optional
- (void)authentication: (SPClientCallbackDelegate *)didAuthenticate;
- (void)authentication: (SPClientCallbackDelegate *)didFailWithError: (NSError *)error;

-(void)RemoteQuery:(id)RemoteQuery didCompleteQuery: (NSString *)result;
-(void)RemoteQuery:(id)RemoteQuery didCompleteQueryWithRequestId: (NSString *)result requestId:(NSString *)requestId;
-(void)RemoteQuery:(id)RemoteQuery didCompleteWithFailure: (NSError *)error;
-(void)RemoteQuery:(id)RemoteQuery didCompleteWithAuthFailure: (NSError *)error;
@end



#endif
