//
//  TopicCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *topicImage;
@property (strong, nonatomic) IBOutlet UILabel *topicCategory;

@end

NS_ASSUME_NONNULL_END
