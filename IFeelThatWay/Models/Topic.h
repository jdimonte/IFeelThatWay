//
//  Topic.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Topic : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSMutableArray *followersArray;
@property (nonatomic, strong) PFFileObject *topicImage;
@property (nonatomic, strong) NSDate *createdAt;

@end

NS_ASSUME_NONNULL_END
