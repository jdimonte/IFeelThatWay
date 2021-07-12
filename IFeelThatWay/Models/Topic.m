//
//  Topic.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "Topic.h"

@implementation Topic

@dynamic topicID;
@dynamic category;
@dynamic followersArray;
@dynamic topicImage;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Topic";
}

@end
