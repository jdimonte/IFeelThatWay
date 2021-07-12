//
//  Poll.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Poll : PFObject

@property (nonatomic, strong) NSString *pollID;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSNumber *agreesCount;
@property (nonatomic, strong) NSMutableArray *agreesArray;
@property (nonatomic, strong) NSMutableArray *savesArray;
@property (nonatomic, strong) NSString *firstAnswer;
@property (nonatomic, strong) NSString *secondAnswer;
@property (nonatomic, strong) NSString *thirdAnswer;
@property (nonatomic, strong) NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableArray *secondArray;
@property (nonatomic, strong) NSMutableArray *thirdArray;
@property (nonatomic, strong) NSNumber *firstCount;
@property (nonatomic, strong) NSNumber *secondCount;
@property (nonatomic, strong) NSNumber *thirdCount;
@property (nonatomic, strong) NSDate *createdAt;

@end

NS_ASSUME_NONNULL_END
