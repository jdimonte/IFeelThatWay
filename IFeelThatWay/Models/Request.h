//
//  Request.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Request : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *request;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *createdAt;

@end

NS_ASSUME_NONNULL_END
