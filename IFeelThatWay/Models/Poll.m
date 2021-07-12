//
//  Poll.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "Poll.h"

@implementation Poll

@dynamic pollID;
@dynamic topic;
@dynamic question;
@dynamic agreesCount;
@dynamic agreesArray;
@dynamic firstAnswer;
@dynamic secondAnswer;
@dynamic thirdAnswer;
@dynamic firstArray;
@dynamic secondArray;
@dynamic thirdArray;
@dynamic firstCount;
@dynamic secondCount;
@dynamic thirdCount;
@dynamic savesArray;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Poll";
}

@end
