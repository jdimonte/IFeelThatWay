//
//  FollowingPromptCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowingPromptCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topic;
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UIButton *handRaiseButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIImageView *featuredProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *featuredComment;

@end

NS_ASSUME_NONNULL_END
