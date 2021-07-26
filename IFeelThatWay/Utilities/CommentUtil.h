//
//  CommentUtil.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/24/21.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Comment.h"
#import "CommentCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentUtil : NSObject

+ (void)designComment:(User*)user: (CommentCell*)commentCell: (Comment*)comment;

+ (void)reportMessage:(Comment*)comment: (UIViewController*)currentViewController;

@end

NS_ASSUME_NONNULL_END
