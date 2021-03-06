//
//  CommentCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *handRaiseButton;
@property (strong, nonatomic) Comment *commentCell;
@property (strong, nonatomic) IBOutlet UILabel *agreesCount;

@end

NS_ASSUME_NONNULL_END
