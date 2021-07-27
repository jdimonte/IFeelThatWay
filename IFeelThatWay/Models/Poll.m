//
//  Poll.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "Poll.h"

@implementation Poll

@dynamic objectId;
@dynamic topic;
@dynamic question;
//@dynamic agreesCount;
//@dynamic agreesArray;
//@dynamic firstAnswer;
//@dynamic secondAnswer;
//@dynamic thirdAnswer;
//@dynamic fourthAnswer;
//@dynamic firstArray;
//@dynamic secondArray;
//@dynamic thirdArray;
//@dynamic fourthArray;
//@dynamic firstCount;
//@dynamic secondCount;
//@dynamic thirdCount;
//@dynamic fourthCount;
//@dynamic savesArray;
@dynamic createdAt;
@dynamic hasComments;
//@dynamic firstPlace;
//@dynamic secondPlace;
//@dynamic thirdPlace;
//@dynamic fourthPlace;
@dynamic multipleSelection;
//@dynamic oneIsSelected;
//@dynamic twoIsSelected;
//@dynamic threeIsSelected;
//@dynamic fourIsSelected;
@dynamic numberOfOptions;
@dynamic answers;
@dynamic arrayOfUsers;
@dynamic places;
@dynamic selected;

+ (nonnull NSString *)parseClassName {
    return @"Poll";
}

@end
