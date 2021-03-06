//
//  Poll.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Poll : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSNumber *agreesCount;
@property (nonatomic, strong) NSMutableArray *agreesArray;
@property (nonatomic, strong) NSMutableArray *savesArray;
@property (nonatomic, strong) NSString *firstAnswer;
@property (nonatomic, strong) NSString *secondAnswer;
@property (nonatomic, strong) NSString *thirdAnswer;
@property (nonatomic, strong) NSString *fourthAnswer;
@property (nonatomic, strong) NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableArray *secondArray;
@property (nonatomic, strong) NSMutableArray *thirdArray;
@property (nonatomic, strong) NSMutableArray *fourthArray;
@property (nonatomic, strong) NSNumber *firstCount;
@property (nonatomic, strong) NSNumber *secondCount;
@property (nonatomic, strong) NSNumber *thirdCount;
@property (nonatomic, strong) NSNumber *fourthCount;
@property (nonatomic, strong) NSDate *createdAt;
@property bool hasComments;
@property (nonatomic, strong) NSNumber *firstPlace;
@property (nonatomic, strong) NSNumber *secondPlace;
@property (nonatomic, strong) NSNumber *thirdPlace;
@property (nonatomic, strong) NSNumber *fourthPlace;
@property bool multipleSelection;
@property bool oneIsSelected;
@property bool twoIsSelected;
@property bool threeIsSelected;
@property bool fourIsSelected;
@property (nonatomic, strong) NSNumber *numberOfOptions;

@end

NS_ASSUME_NONNULL_END
