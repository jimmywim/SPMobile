//
//  RemoteQuery.h
//  SPMobile
//
//  Created by James Love on 15/05/2013.
//
//

/*
Copyright (C) 2013 James Love

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do 
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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