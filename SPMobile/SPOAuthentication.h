//
//  SPOAuthentication.h
//  SPRocket
//
//  Created by James Love on 15/05/2013.
//
//

#import "Authentication.h"

@interface SPOAuthentication : Authentication

-(void)tokensReady: (int)cookieCount;
@end
