//
//  ProfilePictureCell.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePictureCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) NSArray *colorsArray;
@property int index;
@property (strong, nonatomic) IBOutlet UIImageView *displayedPicture;

@end

NS_ASSUME_NONNULL_END
