//
//  Prompt.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Prompt : PFObject

@property (nonatomic, strong) NSString *promptID;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSNumber *agreesCount;
@property (nonatomic, strong) NSMutableArray *agreesArray;
@property (nonatomic, strong) NSMutableArray *savesArray;
@property (nonatomic, strong) NSDate *createdAt;

@end

NS_ASSUME_NONNULL_END