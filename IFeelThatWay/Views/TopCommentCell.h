//
//  TopCommentCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UIButton *raiseHandButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@end

NS_ASSUME_NONNULL_END
