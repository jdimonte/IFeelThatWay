//
//  Comment.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Prompt.h"
#import "Poll.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Prompt *post;
@property (nonatomic, strong) Poll *poll;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSNumber *agreesCount;
@property (nonatomic, strong) NSMutableArray *agreesArray;
@property (nonatomic, strong) NSMutableArray *savesArray;
@property (nonatomic, strong) NSDate *createdAt;

@end

NS_ASSUME_NONNULL_END
