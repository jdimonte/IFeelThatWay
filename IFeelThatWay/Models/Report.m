//
//  Report.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/22/21.
//

#import "Report.h"

@implementation Report

@dynamic objectId;
@dynamic message;
@dynamic messageAuthor;
@dynamic commentId;
@dynamic replyId;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"Report";
}

@end
