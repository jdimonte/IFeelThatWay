//
//  PromptCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Prompt.h"

NS_ASSUME_NONNULL_BEGIN

@interface PromptCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UIButton *handRaise;
@property (strong, nonatomic) IBOutlet UIButton *comment;
@property (strong, nonatomic) IBOutlet UIButton *save;
@property (strong, nonatomic) IBOutlet UILabel *featuredComment;
@property (strong, nonatomic) IBOutlet UIImageView *featuredProfilePic;
@property (strong, nonatomic) Prompt *promptCell;

@end

NS_ASSUME_NONNULL_END
