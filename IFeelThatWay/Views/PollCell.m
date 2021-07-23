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
    
    self.firstView.layer.cornerRadius = 0.05 * self.firstView.bounds.size.width;
    self.secondView.layer.cornerRadius = 0.05 * self.secondView.bounds.size.width;
    self.thirdView.layer.cornerRadius = 0.05 * self.thirdView.bounds.size.width;
    self.fourthView.layer.cornerRadius = 0.05 * self.fourthView.bounds.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)optionOneTapped:(id)sender {
    User *user = [PFUser currentUser];
    
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        [self.poll addUniqueObject:user.objectId forKey:@"firstArray"];
        self.firstView.backgroundColor = [UIColor systemPinkColor];
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
        self.secondView.backgroundColor = [UIColor systemPinkColor];
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
        self.thirdView.backgroundColor = [UIColor systemPinkColor];
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
        self.fourthView.backgroundColor = [UIColor systemPinkColor];
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
    
    unsigned long firstPlace = MAX(optionOneCount,MAX(optionTwoCount,MAX(optionThreeCount,optionFourCount)));
    if(optionOneCount == firstPlace){
        self.optionOneChange = 0;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionThreeCount,optionFourCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange = 0;
            if(optionThreeCount > optionFourCount){
                self.optionThreeChange = 0;
                self.optionFourChange = 0;
                [self updatePlaces:1:2:3:4];
            } else {
                self.optionThreeChange = -60;
                self.optionFourChange = 60;
                [self updatePlaces:1:2:4:3];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange = 60;
            if(optionTwoCount > optionFourCount){
                self.optionTwoChange = -60;
                self.optionFourChange = 0;
                [self updatePlaces:1:3:2:4];
            } else {
                self.optionTwoChange = -120;
                self.optionFourChange = 60;
                [self updatePlaces:1:3:4:2];
            }
        } else {
            self.optionFourChange = 120;
            if(optionThreeCount > optionTwoCount){
                self.optionThreeChange = 0;
                self.optionTwoChange = -120;
                [self updatePlaces:1:4:3:2];
            } else {
                self.optionThreeChange = -60;
                self.optionTwoChange = -60;
                [self updatePlaces:1:4:2:3];
            }
        }
    }
    else if(optionTwoCount == firstPlace){
        self.optionTwoChange = 60;
        unsigned long secondPlace = MAX(optionOneCount,MAX(optionThreeCount,optionFourCount));
        if(secondPlace == optionOneCount){
            self.optionOneChange = -60;
            if(optionThreeCount > optionFourCount){
                self.optionThreeChange = 0;
                self.optionFourChange = 0;
                [self updatePlaces:2:1:3:4];
            } else {
                self.optionThreeChange = -60;
                self.optionFourChange = 60;
                [self updatePlaces:2:1:4:3];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange = 60;
            if(optionOneCount > optionFourCount){
                self.optionOneChange = -120;
                self.optionFourChange = 0;
                [self updatePlaces:2:3:1:4];
            } else {
                self.optionOneChange = -180;
                self.optionFourChange = 60;
                [self updatePlaces:2:3:4:1];
            }
        } else {
            self.optionFourChange = 120;
            if(optionThreeCount > optionOneCount){
                self.optionThreeChange = 0;
                self.optionOneChange = -180;
                [self updatePlaces:2:4:3:1];
            } else {
                self.optionThreeChange = -60;
                self.optionOneChange = -120;
                [self updatePlaces:2:4:1:3];
            }
        }
    }
    else if(optionThreeCount == firstPlace){
        self.optionThreeChange = 120;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionOneCount,optionFourCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange = 0;
            if(optionOneCount > optionFourCount){
                self.optionOneChange = -120;
                self.optionFourChange = 0;
                [self updatePlaces:3:2:1:4];
            } else {
                self.optionOneChange = -180;
                self.optionFourChange = 60;
                [self updatePlaces:3:2:4:1];
            }
        } else if(secondPlace == optionOneCount){
            self.optionOneChange = -60;
            if(optionTwoCount > optionFourCount){
                self.optionTwoChange = -60;
                self.optionFourChange = 0;
                [self updatePlaces:3:1:2:4];
            } else {
                self.optionTwoChange = -120;
                self.optionFourChange = 60;
                [self updatePlaces:3:1:4:2];
            }
        } else {
            self.optionFourChange = 120;
            if(optionOneCount > optionTwoCount){
                self.optionOneChange = -120;
                self.optionTwoChange = -120;
                [self updatePlaces:3:4:1:2];
            } else {
                self.optionOneChange = -180;
                self.optionTwoChange = -60;
                [self updatePlaces:3:4:2:1];
            }
        }
    }
    else{
        self.optionFourChange = 180;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionThreeCount,optionOneCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange = 0;
            if(optionThreeCount > optionOneCount){
                self.optionThreeChange = 0;
                self.optionOneChange = -180;
                [self updatePlaces:4:2:3:1];
            } else {
                self.optionThreeChange = -60;
                self.optionOneChange = -120;
                [self updatePlaces:4:2:1:3];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange = 60;
            if(optionOneCount > optionTwoCount){
                self.optionOneChange = -120;
                self.optionTwoChange = -120;
                [self updatePlaces:4:3:1:2];
            } else {
                self.optionOneChange = -180;
                self.optionTwoChange = -60;
                [self updatePlaces:4:3:2:1];
            }
        } else {
            self.optionOneChange = -60;
            if(optionThreeCount > optionTwoCount){
                self.optionThreeChange = 0;
                self.optionTwoChange = -120;
                [self updatePlaces:4:1:3:2];
            } else {
                self.optionThreeChange = -60;
                self.optionTwoChange = -60;
                [self updatePlaces:4:1:2:3];
            }
        }
    }
    
    [UIView animateWithDuration: 1 animations:^{
        CGRect firstFrame = self.firstView.frame;
        firstFrame.origin.y -= self.optionOneChange;
        self.firstView.frame = firstFrame;
        
        CGRect secondFrame = self.secondView.frame;
        secondFrame.origin.y -= self.optionTwoChange;
        self.secondView.frame = secondFrame;
        
        CGRect thirdFrame = self.thirdView.frame;
        thirdFrame.origin.y -= self.optionThreeChange;
        self.thirdView.frame = thirdFrame;
        
        CGRect fourthFrame = self.fourthView.frame;
        fourthFrame.origin.y -= self.optionFourChange;
        self.fourthView.frame = fourthFrame;
    }];
}

- (void) updatePlaces:(unsigned long)one:(unsigned long)two:(unsigned long)three:(unsigned long)four{
    self.poll.firstPlace = @(one);
    self.poll.secondPlace = @(two);
    self.poll.thirdPlace = @(three);
    self.poll.fourthPlace = @(four);
    [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
