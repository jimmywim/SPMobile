//
//  Utilities.m
//  HelloWorld
//
//  Created by James Love on 10/05/2013.
//
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end
