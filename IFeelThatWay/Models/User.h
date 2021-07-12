//
//  User.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) PFFileObject *profilePicture;

@end

NS_ASSUME_NONNULL_END
