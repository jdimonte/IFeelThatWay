//
//  PollCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/20/21.
//

#import <UIKit/UIKit.h>
#import "Poll.h"

NS_ASSUME_NONNULL_BEGIN

@interface PollCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *question;
@property (strong, nonatomic) IBOutlet UIButton *optionOne;
@property (strong, nonatomic) IBOutlet UIButton *optionTwo;
@property (strong, nonatomic) IBOutlet UIButton *optionThree;
@property (strong, nonatomic) IBOutlet UIButton *optionFour;
@property (strong, nonatomic) IBOutlet UILabel *optionOnePercent;
@property (strong, nonatomic) IBOutlet UILabel *optionTwoPercent;
@property (strong, nonatomic) IBOutlet UILabel *optionThreePercent;
@property (strong, nonatomic) IBOutlet UILabel *optionFourPercent;
@property (strong, nonatomic) IBOutlet UIButton *handRaise;
@property (strong, nonatomic) IBOutlet UIButton *comment;
@property (strong, nonatomic) IBOutlet UIButton *save;
@property (strong, nonatomic) IBOutlet UIImageView *featuredProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *featuredComment;
@property (strong, nonatomic) Poll *poll;
@property (strong, nonatomic) IBOutlet UIView *firstView;
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIView *thirdView;
@property (strong, nonatomic) IBOutlet UIView *fourthView;

@end

NS_ASSUME_NONNULL_END
