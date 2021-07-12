//
//  Comment.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "Comment.h"

@implementation Comment

@dynamic commentID;
@dynamic user;
@dynamic post;
@dynamic text;
@dynamic agreesCount;
@dynamic agreesArray;
@dynamic savesArray;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Comment";
}

@end
