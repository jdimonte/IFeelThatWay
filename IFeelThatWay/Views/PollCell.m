//
//  PollCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/20/21.
//

#import "PollCell.h"
#import "User.h"

@implementation PollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)optionOneTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"firstArray"];
        self.firstView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}
- (IBAction)optionTwoTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"secondArray"];
        self.secondView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}

- (IBAction)optionThreeTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"thirdArray"];
        self.thirdView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}

- (IBAction)optionFourTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"fourthArray"];
        self.fourthView.backgroundColor = [UIColor lightGrayColor];
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
    }
}

- (void) updatePercents{
    unsigned long optionOneCount = (unsigned long)self.poll.firstArray.count;
    unsigned long optionTwoCount = (unsigned long)self.poll.secondArray.count;
    unsigned long optionThreeCount = (unsigned long)self.poll.thirdArray.count;
    unsigned long optionFourCount = (unsigned long)self.poll.fourthArray.count;
    unsigned long total = optionOneCount + optionTwoCount + optionThreeCount + optionFourCount;
    if(total != 0){
        self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
        self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
        self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
        self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
    }
    
    self.optionOnePercent.textColor = [UIColor blackColor];
    self.optionTwoPercent.textColor = [UIColor blackColor];
    self.optionThreePercent.textColor = [UIColor blackColor];
    self.optionFourPercent.textColor = [UIColor blackColor];
}

@end
