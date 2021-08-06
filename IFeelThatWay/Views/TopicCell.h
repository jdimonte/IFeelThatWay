//
//  TopicCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *topicCategory;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) IBOutlet UIImageView *topicImage;


@end

NS_ASSUME_NONNULL_END
