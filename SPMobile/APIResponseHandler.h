//
//  APIResponseHandler.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import <Foundation/Foundation.h>

@interface APIResponseHandler : NSObject
@property (nonatomic, strong) NSObject *targetObject;
@property (nonatomic, strong) NSMutableData *responseData;
@property NSInteger responseCode;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection	 *)connection;

@end
