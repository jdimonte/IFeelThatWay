//
//  Request.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import "Request.h"

@implementation Request

@dynamic objectId;
@dynamic request;
@dynamic type;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Request";
}

@end
