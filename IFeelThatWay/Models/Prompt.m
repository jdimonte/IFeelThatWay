//
//  Prompt.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "Prompt.h"

@implementation Prompt

@dynamic objectId;
@dynamic topic;
@dynamic question;
@dynamic agreesCount;
@dynamic agreesArray;
@dynamic savesArray;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Prompt";
}


@end
