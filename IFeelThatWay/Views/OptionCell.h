//
//  OptionCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/26/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *optionNumber;
@property (strong, nonatomic) IBOutlet UITextView *optionInput;

@end

NS_ASSUME_NONNULL_END
