//
//  SavedViewController.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SavedViewControllerDelegate

 - (void)loadQueryComments;

@end

@interface SavedViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
