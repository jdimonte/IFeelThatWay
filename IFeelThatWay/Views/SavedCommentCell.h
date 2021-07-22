//
//  SavedCommentCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/15/21.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "SavedViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SavedCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) Comment *comment;
@property (strong, nonatomic) IBOutlet UIView *bulletPoint;
@property (nonatomic, weak) id <SavedViewControllerDelegate> savedViewController;

@end

NS_ASSUME_NONNULL_END
