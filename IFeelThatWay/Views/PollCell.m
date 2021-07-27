//
//  PollCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/20/21.
//

#import "PollCell.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>

@implementation PollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.firstView.layer.cornerRadius = 0.05 * self.firstView.bounds.size.width;
    self.secondView.layer.cornerRadius = 0.05 * self.secondView.bounds.size.width;
    self.thirdView.layer.cornerRadius = 0.05 * self.thirdView.bounds.size.width;
    self.fourthView.layer.cornerRadius = 0.05 * self.fourthView.bounds.size.width;
    
    self.firstView.layer.borderWidth = 3.0f;
    self.secondView.layer.borderWidth = 3.0f;
    self.thirdView.layer.borderWidth = 3.0f;
    self.fourthView.layer.borderWidth = 3.0f;
    self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
    self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
    self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
    self.fourthView.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.oneIsSelected = false;
    self.twoIsSelected = false;
    self.threeIsSelected = false;
    self.fourIsSelected = false;
    
    self.optionOneChange = 0;
    self.optionTwoChange = 0;
    self.optionThreeChange = 0;
    self.optionFourChange = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitTapped:(id)sender {
    if(self.oneIsSelected || self.twoIsSelected || self.threeIsSelected || self.fourIsSelected){
        //remove user from arrays & add user to arrays
        User *user = [PFUser currentUser];

        if([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId]){
            NSNumber *placeOne = self.poll[@"firstPlace"];
            NSNumber *placeTwo = self.poll[@"secondPlace"];
            NSNumber *placeThree = self.poll[@"thirdPlace"];
            NSNumber *placeFour = self.poll[@"fourthPlace"];
            self.optionOneChange = 60*([placeOne intValue]-1);
            self.optionTwoChange = 60*([placeTwo intValue]-1) - 60;
            self.optionThreeChange = 60*([placeThree intValue]-1) - 120;
            self.optionFourChange = 60*([placeFour intValue]-1) - 180;
        }
        
        if([self.poll[@"firstArray"] containsObject:user.objectId]){
            if(!self.oneIsSelected){
                [self.poll removeObject:user.objectId forKey:@"firstArray"];
            }
        } else{
            if(self.oneIsSelected){
                [self.poll addUniqueObject:user.objectId forKey:@"firstArray"];
                self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        if([self.poll[@"secondArray"] containsObject:user.objectId]){
            if(!self.twoIsSelected){
                [self.poll removeObject:user.objectId forKey:@"secondArray"];
            }
        } else{
            if(self.twoIsSelected){
                [self.poll addUniqueObject:user.objectId forKey:@"secondArray"];
                self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        if([self.poll[@"thirdArray"] containsObject:user.objectId]){
            if(!self.threeIsSelected){
                [self.poll removeObject:user.objectId forKey:@"thirdArray"];
            }
        } else{
            if(self.threeIsSelected){
                [self.poll addUniqueObject:user.objectId forKey:@"thirdArray"];
                self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        if([self.poll[@"fourthArray"] containsObject:user.objectId]){
            if(!self.fourIsSelected){
                [self.poll removeObject:user.objectId forKey:@"fourthArray"];
            }
        } else{
            if(self.fourIsSelected){
                [self.poll addUniqueObject:user.objectId forKey:@"fourthArray"];
                self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
                [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        
        [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        [self updatePercents];
        
        if(self.oneIsSelected){
            self.optionOnePercent.textColor = [UIColor whiteColor];
            self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
            [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        }
        if(self.twoIsSelected){
            self.optionTwoPercent.textColor = [UIColor whiteColor];
            self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
            [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        }
        if(self.threeIsSelected){
            self.optionThreePercent.textColor = [UIColor whiteColor];
            self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
            [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        }
        if(self.fourIsSelected){
            self.optionFourPercent.textColor = [UIColor whiteColor];
            self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
            [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        self.oneIsSelected = false;
        self.twoIsSelected = false;
        self.threeIsSelected = false;
        self.fourIsSelected = false;
        self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
        self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
        self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
        self.fourthView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (IBAction)optionOneTapped:(id)sender {
    User *user = [PFUser currentUser];
    self.color = false;
    if([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId]){
        //check if out of order
        [self selectingOption:@1];
    }
    else{
        self.oneIsSelected = !self.oneIsSelected;
        if(self.oneIsSelected){
            self.color = true;
        }
    }
    if(self.color){
        self.firstView.layer.borderColor = [UIColor greenColor].CGColor;
        if(!self.poll.multipleSelection){
            self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
            self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
            self.fourthView.layer.borderColor = [UIColor clearColor].CGColor;
        }
    } else{
        self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}
- (IBAction)optionTwoTapped:(id)sender {
    User *user = [PFUser currentUser];
    self.color = false;
    if([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId]){
        //check if out of order
        [self selectingOption:@2];
    }
    else{
        self.twoIsSelected = !self.twoIsSelected;
        if(self.twoIsSelected){
            self.color = true;
        }
    }
    if(self.color){
        self.secondView.layer.borderColor = [UIColor greenColor].CGColor;
        if(!self.poll.multipleSelection){
            self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
            self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
            self.fourthView.layer.borderColor = [UIColor clearColor].CGColor;
        }
    } else{
        self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (IBAction)optionThreeTapped:(id)sender {
    User *user = [PFUser currentUser];
    self.color = false;
    if([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId]){
        //check if out of order
        [self selectingOption:@3];
    }
    else{
        self.threeIsSelected = !self.threeIsSelected;
        if(self.threeIsSelected){
            self.color = true;
        }
    }
    if(self.color){
        self.thirdView.layer.borderColor = [UIColor greenColor].CGColor;
        if(!self.poll.multipleSelection){
            self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
            self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
            self.fourthView.layer.borderColor = [UIColor clearColor].CGColor;
        }
    } else{
        self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (IBAction)optionFourTapped:(id)sender {
    User *user = [PFUser currentUser];
    self.color = false;
    if([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId]){
        //check if out of order
        [self selectingOption:@4];
    }
    else{
        self.fourIsSelected = !self.fourIsSelected;
        if(self.fourIsSelected){
            self.color = true;
        }
    }
    if(self.color){
        self.fourthView.layer.borderColor = [UIColor greenColor].CGColor;
        if(!self.poll.multipleSelection){
            self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
            self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
            self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
        }
    } else{
        self.fourthView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void) selectingOption:(NSNumber *)location {
    if([self.poll[@"firstPlace"] isEqual: location]){
        self.oneIsSelected = !self.oneIsSelected;
        if(self.oneIsSelected){
            self.color = true;
            if(!self.poll.multipleSelection){
                self.twoIsSelected = false;
                self.threeIsSelected = false;
                self.fourIsSelected = false;
            }
        }
    } else if ([self.poll[@"secondPlace"] isEqual: location]){
        self.twoIsSelected = !self.twoIsSelected;
        if(self.twoIsSelected){
            self.color = true;
            if(!self.poll.multipleSelection){
                self.oneIsSelected = false;
                self.threeIsSelected = false;
                self.fourIsSelected = false;
            }
        }
    } else if([self.poll[@"thirdPlace"] isEqual: location]){
        self.threeIsSelected = !self.threeIsSelected;
        if(self.threeIsSelected){
            self.color = true;
            if(!self.poll.multipleSelection){
                self.oneIsSelected = false;
                self.twoIsSelected = false;
                self.fourIsSelected = false;
            }
        }
    } else {
        self.fourIsSelected = !self.fourIsSelected;
        if(self.fourIsSelected){
            self.color = true;
            if(!self.poll.multipleSelection){
                self.oneIsSelected = false;
                self.threeIsSelected = false;
                self.twoIsSelected = false;
            }
        }
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
    
    self.firstView.backgroundColor = [UIColor whiteColor];
    self.secondView.backgroundColor = [UIColor whiteColor];
    self.thirdView.backgroundColor = [UIColor whiteColor];
    self.fourthView.backgroundColor = [UIColor whiteColor];
    [self.optionOne setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [self.optionTwo setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [self.optionThree setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [self.optionFour setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    self.optionOnePercent.textColor = [UIColor blackColor];
    self.optionTwoPercent.textColor = [UIColor blackColor];
    self.optionThreePercent.textColor = [UIColor blackColor];
    self.optionFourPercent.textColor = [UIColor blackColor];

    unsigned long firstPlace = MAX(optionOneCount,MAX(optionTwoCount,MAX(optionThreeCount,optionFourCount)));
    if(optionOneCount == firstPlace){
        self.optionOneChange += 0;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionThreeCount,optionFourCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange += 0;
            if(optionThreeCount > optionFourCount){
                self.optionThreeChange += 0;
                self.optionFourChange += 0;
                [self updatePlaces:1:2:3:4];
            } else {
                self.optionThreeChange += -60;
                self.optionFourChange += 60;
                [self updatePlaces:1:2:4:3];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange += 60;
            if(optionTwoCount > optionFourCount){
                self.optionTwoChange += -60;
                self.optionFourChange += 0;
                [self updatePlaces:1:3:2:4];
            } else {
                self.optionTwoChange += -120;
                self.optionFourChange += 60;
                [self updatePlaces:1:4:2:3];
            }
        } else {
            self.optionFourChange += 120;
            if(optionThreeCount > optionTwoCount){
                self.optionThreeChange += 0;
                self.optionTwoChange += -120;
                [self updatePlaces:1:4:3:2];
            } else {
                self.optionThreeChange += -60;
                self.optionTwoChange += -60;
                [self updatePlaces:1:3:4:2];
            }
        }
    }
    else if(optionTwoCount == firstPlace){
        self.optionTwoChange += 60;
        unsigned long secondPlace = MAX(optionOneCount,MAX(optionThreeCount,optionFourCount));
        if(secondPlace == optionOneCount){
            self.optionOneChange += -60;
            if(optionThreeCount > optionFourCount){
                self.optionThreeChange += 0;
                self.optionFourChange += 0;
                [self updatePlaces:2:1:3:4];
            } else {
                self.optionThreeChange += -60;
                self.optionFourChange += 60;
                [self updatePlaces:2:1:4:3];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange += 60;
            if(optionOneCount > optionFourCount){
                self.optionOneChange += -120;
                self.optionFourChange += 0;
                [self updatePlaces:3:1:2:4];
            } else {
                self.optionOneChange += -180;
                self.optionFourChange += 60;
                [self updatePlaces:4:1:2:3];
            }
        } else {
            self.optionFourChange += 120;
            if(optionThreeCount > optionOneCount){
                self.optionThreeChange += 0;
                self.optionOneChange += -180;
                [self updatePlaces:4:1:3:2];
            } else {
                self.optionThreeChange += -60;
                self.optionOneChange += -120;
                [self updatePlaces:3:1:4:2];
            }
        }
    }
    else if(optionThreeCount == firstPlace){
        self.optionThreeChange += 120;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionOneCount,optionFourCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange += 0;
            if(optionOneCount > optionFourCount){
                self.optionOneChange += -120;
                self.optionFourChange += 0;
                [self updatePlaces:3:2:1:4];
            } else {
                self.optionOneChange += -180;
                self.optionFourChange += 60;
                [self updatePlaces:4:2:1:3];
            }
        } else if(secondPlace == optionOneCount){
            self.optionOneChange += -60;
            if(optionTwoCount > optionFourCount){
                self.optionTwoChange += -60;
                self.optionFourChange += 0;
                [self updatePlaces:2:3:1:3];
            } else {
                self.optionTwoChange += -120;
                self.optionFourChange += 60;
                [self updatePlaces:2:4:1:3];
            }
        } else {
            self.optionFourChange += 120;
            if(optionOneCount > optionTwoCount){
                self.optionOneChange += -120;
                self.optionTwoChange += -120;
                [self updatePlaces:3:4:1:2];
            } else {
                self.optionOneChange += -180;
                self.optionTwoChange += -60;
                [self updatePlaces:4:3:1:2];
            }
        }
    }
    else{
        self.optionFourChange += 180;
        unsigned long secondPlace = MAX(optionTwoCount,MAX(optionThreeCount,optionOneCount));
        if(secondPlace == optionTwoCount){
            self.optionTwoChange += 0;
            if(optionThreeCount > optionOneCount){
                self.optionThreeChange += 0;
                self.optionOneChange += -180;
                [self updatePlaces:4:2:3:1];
            } else {
                self.optionThreeChange += -60;
                self.optionOneChange += -120;
                [self updatePlaces:3:2:4:1];
            }
        } else if(secondPlace == optionThreeCount){
            self.optionThreeChange += 60;
            if(optionOneCount > optionTwoCount){
                self.optionOneChange += -120;
                self.optionTwoChange += -120;
                [self updatePlaces:3:4:2:1];
            } else {
                self.optionOneChange += -180;
                self.optionTwoChange += -60;
                [self updatePlaces:4:3:2:1];
            }
        } else {
            self.optionOneChange += -60;
            if(optionThreeCount > optionTwoCount){
                self.optionThreeChange += 0;
                self.optionTwoChange += -120;
                [self updatePlaces:2:4:3:1];
            } else {
                self.optionThreeChange += -60;
                self.optionTwoChange += -60;
                [self updatePlaces:2:3:4:1];
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

- (void) updatePlaces:(unsigned long)oneLocation:(unsigned long)twoLocation:(unsigned long)threeLocation:(unsigned long)fourLocation{
    self.poll.firstPlace = @(oneLocation);
    self.poll.secondPlace = @(twoLocation);
    self.poll.thirdPlace = @(threeLocation);
    self.poll.fourthPlace = @(fourLocation);
    [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
