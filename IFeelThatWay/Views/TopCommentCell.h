//
//  TopCommentCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UIButton *raiseHandButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) Comment *commentCell;
@property (strong, nonatomic) IBOutlet UILabel *agreesCount;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UILabel *rank;

@end

NS_ASSUME_NONNULL_END
