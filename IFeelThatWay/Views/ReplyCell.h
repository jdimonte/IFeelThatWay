//
//  ReplyCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "Reply.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReplyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UIButton *handRaiseButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) Comment *replyCell;
@property (strong, nonatomic) IBOutlet UILabel *agreesCount;

@end

NS_ASSUME_NONNULL_END
