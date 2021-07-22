//
//  Report.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/22/21.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Comment.h"
#import "Reply.h"

NS_ASSUME_NONNULL_BEGIN

@interface Report : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) User *messageAuthor;
@property (nonatomic, strong) Comment *commentId;
@property (nonatomic, strong) Reply *replyId;
@property (nonatomic, strong) NSDate *createdAt;

@end

NS_ASSUME_NONNULL_END
