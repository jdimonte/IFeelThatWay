//
//  Reply.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "Reply.h"

@implementation Reply

@dynamic replyID;
@dynamic user;
@dynamic comment;
@dynamic text;
@dynamic agreesCount;
@dynamic agreesArray;
@dynamic savesArray;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Reply";
}

@end
