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
    self.submitButton.layer.cornerRadius = 0.2 * self.submitButton.bounds.size.width;
    
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
    
    User *user = [PFUser currentUser];
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        self.state = FIRSTTIME;
    } else{
        self.state = NOTFIRSTTIME;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)submitTapped:(id)sender {
    if(self.oneIsSelected || self.twoIsSelected || self.threeIsSelected || self.fourIsSelected){
        [self reorderViews];

        [self addUserToArrays];
        
        [self decorateViews];
        
        [self updatePercents];
        
        [self resetOptions];
    }
}

- (void) reorderViews {
    if(self.state != FIRSTTIME){
        NSNumber *placeOne = self.poll[@"firstPlace"];
        NSNumber *placeTwo = self.poll[@"secondPlace"];
        NSNumber *placeThree = self.poll[@"thirdPlace"];
        NSNumber *placeFour = self.poll[@"fourthPlace"];
        self.optionOneChange = 60*([placeOne intValue]-1);
        self.optionTwoChange = 60*([placeTwo intValue]-1) - 60;
        self.optionThreeChange = 60*([placeThree intValue]-1) - 120;
        self.optionFourChange = 60*([placeFour intValue]-1) - 180;
    }
    if(self.state == NOTFIRSTTIME){
        self.first = self.poll[@"firstPlace"];
        self.second = self.poll[@"secondPlace"];
        self.third = self.poll[@"thirdPlace"];
        self.fourth = self.poll[@"fourthPlace"];
    }
}

- (void) addUserToArrays {
    User *user = [PFUser currentUser];
    NSArray *optionArrays = [[NSArray alloc] initWithObjects:@"firstArray",@"secondArray",@"thirdArray",@"fourthArray",nil];
    NSArray *optionSelected = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:self.oneIsSelected],[NSNumber numberWithBool:self.twoIsSelected],[NSNumber numberWithBool:self.threeIsSelected],[NSNumber numberWithBool:self.fourIsSelected],nil];
    for(int i = 0; i < [self.poll[@"numberOfOptions"] intValue]; i++) {
        if([self.poll[optionArrays[i]] containsObject:user.objectId]){
            if([optionSelected[i] intValue] == 0){
                [self.poll removeObject:user.objectId forKey:optionArrays[i]];
            }
        } else{
            if([optionSelected[i] intValue] == 1){
                [self.poll addUniqueObject:user.objectId forKey:optionArrays[i]];
            }
        }
    }
    
    [self.poll saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) decorateViews {
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
    
    if(self.state == NOTFIRSTTIME || self.state == POSTCHANGE){
        if(self.oneIsSelected){
            [self decoratingOption:self.first];
        }
        if(self.twoIsSelected){
            [self decoratingOption:self.second];
        }
        if(self.threeIsSelected){
            [self decoratingOption:self.third];
        }
        if(self.fourIsSelected){
            [self decoratingOption:self.fourth];
        }
    }
    else{
        if(self.oneIsSelected){
            [self decoratingOption:@1];
        }
        if(self.twoIsSelected){
            [self decoratingOption:@2];
        }
        if(self.threeIsSelected){
            [self decoratingOption:@3];
        }
        if(self.fourIsSelected){
            [self decoratingOption:@4];
        }
    }
}

- (void) resetOptions {
    self.oneIsSelected = false;
    self.twoIsSelected = false;
    self.threeIsSelected = false;
    self.fourIsSelected = false;
    self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
    self.secondView.layer.borderColor = [UIColor clearColor].CGColor;
    self.thirdView.layer.borderColor = [UIColor clearColor].CGColor;
    self.fourthView.layer.borderColor = [UIColor clearColor].CGColor;
    
    if(self.state == FIRSTTIME){
        self.state = POSTANIMATION;
    }
    if(self.state == NOTFIRSTTIME){
        self.state = POSTCHANGE;
    }
}

- (IBAction)optionOneTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        self.state = FIRSTTIME;
    }
    else {
        if(self.state == FIRSTTIME){
            self.state = NOTFIRSTTIME;
        }
    }
    self.color = false;
    if(self.state == NOTFIRSTTIME){
        NSArray *places = [[NSArray alloc] initWithObjects:self.poll[@"firstPlace"],self.poll[@"secondPlace"],self.poll[@"thirdPlace"],self.poll[@"fourthPlace"],nil];
        [self selectingOption:places:@1];
    }
    else{
        if(self.state == POSTCHANGE){
            NSArray *places = [[NSArray alloc] initWithObjects:self.first,self.second,self.third,self.fourth,nil];
            [self selectingOption:places:@1];
        }
        else{
            self.oneIsSelected = !self.oneIsSelected;
            if(self.oneIsSelected){
                self.color = true;
                if(!self.poll.multipleSelection){
                    self.twoIsSelected = false;
                    self.threeIsSelected = false;
                    self.fourIsSelected = false;
                }
            }
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
        self.firstView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}
- (IBAction)optionTwoTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        self.state = FIRSTTIME;
    }
    else {
        if(self.state == FIRSTTIME){
            self.state = NOTFIRSTTIME;
        }
    }
    self.color = false;
    if(self.state == NOTFIRSTTIME){
        NSArray *places = [[NSArray alloc] initWithObjects:self.poll[@"firstPlace"],self.poll[@"secondPlace"],self.poll[@"thirdPlace"],self.poll[@"fourthPlace"],nil];
        [self selectingOption:places:@2];
    }
    else{
        if(self.state == POSTCHANGE){
            NSArray *places = [[NSArray alloc] initWithObjects:self.first,self.second,self.third,self.fourth,nil];
            [self selectingOption:places:@2];
        }
        else{
            self.twoIsSelected = !self.twoIsSelected;
            if(self.twoIsSelected){
                self.color = true;
                if(!self.poll.multipleSelection){
                    self.fourIsSelected = false;
                    self.threeIsSelected = false;
                    self.oneIsSelected = false;
                }
            }
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
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        self.state = FIRSTTIME;
    }
    else {
        if(self.state == FIRSTTIME){
            self.state = NOTFIRSTTIME;
        }
    }
    self.color = false;
    if(self.state == NOTFIRSTTIME){
        NSArray *places = [[NSArray alloc] initWithObjects:self.poll[@"firstPlace"],self.poll[@"secondPlace"],self.poll[@"thirdPlace"],self.poll[@"fourthPlace"],nil];
        [self selectingOption:places:@3];
    }
    else{
        if(self.state == POSTCHANGE){
            NSArray *places = [[NSArray alloc] initWithObjects:self.first,self.second,self.third,self.fourth,nil];
            [self selectingOption:places:@3];
        }
        else{
            self.threeIsSelected = !self.threeIsSelected;
            if(self.threeIsSelected){
                self.color = true;
                if(!self.poll.multipleSelection){
                    self.twoIsSelected = false;
                    self.fourIsSelected = false;
                    self.oneIsSelected = false;
                }
            }
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
    if(!([self.poll[@"firstArray"] containsObject:user.objectId] || [self.poll[@"secondArray"] containsObject:user.objectId] || [self.poll[@"thirdArray"] containsObject:user.objectId] || [self.poll[@"fourthArray"] containsObject:user.objectId])){
        self.state = FIRSTTIME;
    }
    else {
        if(self.state == FIRSTTIME){
            self.state = NOTFIRSTTIME;
        }
    }
    self.color = false;
    if(self.state == NOTFIRSTTIME){
        NSArray *places = [[NSArray alloc] initWithObjects:self.poll[@"firstPlace"],self.poll[@"secondPlace"],self.poll[@"thirdPlace"],self.poll[@"fourthPlace"],nil];
        [self selectingOption:places:@4];
    }
    else{
        if(self.state == POSTCHANGE){
            NSArray *places = [[NSArray alloc] initWithObjects:self.first,self.second,self.third,self.fourth,nil];
            [self selectingOption:places:@4];
        }
        else{
            self.fourIsSelected = !self.fourIsSelected;
            if(self.fourIsSelected){
                self.color = true;
                if(!self.poll.multipleSelection){
                    self.twoIsSelected = false;
                    self.threeIsSelected = false;
                    self.oneIsSelected = false;
                }
            }
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

- (void) selectingOption:(NSArray *)places:(NSNumber *)location {
    if([places[0] isEqual: location]){
        self.oneIsSelected = !self.oneIsSelected;
        if(self.oneIsSelected){
            self.color = true;
            if(!self.poll.multipleSelection){
                self.twoIsSelected = false;
                self.threeIsSelected = false;
                self.fourIsSelected = false;
            }
        }
    } else if ([places[1] isEqual: location]){
        self.twoIsSelected = !self.twoIsSelected;
        if(self.twoIsSelected){
            self.color = true;
            if(!self.poll.multipleSelection){
                self.oneIsSelected = false;
                self.threeIsSelected = false;
                self.fourIsSelected = false;
            }
        }
    } else if([places[2] isEqual: location]){
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

- (void) decoratingOption:(NSNumber *)location {
    for(int i = 1; i < [self.poll[@"numberOfOptions"] intValue]+1; i++){
        if([location isEqual: [NSNumber numberWithInt:i]]){
            [self decorateLocation:([NSNumber numberWithInt:i])];
        }
    }
}

- (void) decorateLocation:(NSNumber*)i {
    if([i isEqual: @1]){
        self.optionOnePercent.textColor = [UIColor whiteColor];
        self.firstView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionOne setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if([i isEqual: @2]){
        self.optionTwoPercent.textColor = [UIColor whiteColor];
        self.secondView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionTwo setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if([i isEqual: @3]){
        self.optionThreePercent.textColor = [UIColor whiteColor];
        self.thirdView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionThree setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        self.optionFourPercent.textColor = [UIColor whiteColor];
        self.fourthView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:143.0/255.0 blue:152.0/255.0 alpha:1.0];
        [self.optionFour setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void) showOptionPercent:(NSNumber *)location:(unsigned long)count:(unsigned long)total {
    if([location isEqual:@1]){
        self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(count*100)/total];
    } else if([location isEqual:@2]){
        self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(count*100)/total];
    } else if([location isEqual:@3]){
        self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(count*100)/total];
    } else{
        self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(count*100)/total];
    }
}

- (void) updatePercents{
    unsigned long optionOneCount = (unsigned long)self.poll.firstArray.count;
    unsigned long optionTwoCount = (unsigned long)self.poll.secondArray.count;
    unsigned long optionThreeCount = (unsigned long)self.poll.thirdArray.count;
    unsigned long optionFourCount = (unsigned long)self.poll.fourthArray.count;
    
    unsigned long total = optionOneCount + optionTwoCount + optionThreeCount + optionFourCount;
    if(total != 0){
        if(self.state == NOTFIRSTTIME || self.state == POSTCHANGE){
            [self showOptionPercent:self.first :optionOneCount :total];
            [self showOptionPercent:self.second :optionTwoCount :total];
            [self showOptionPercent:self.third :optionThreeCount :total];
            [self showOptionPercent:self.fourth :optionFourCount :total];
        }
        else{
            self.optionOnePercent.text = [NSString stringWithFormat:@"%lu%%",(optionOneCount*100)/total];
            self.optionTwoPercent.text = [NSString stringWithFormat:@"%lu%%",(optionTwoCount*100)/total];
            self.optionThreePercent.text = [NSString stringWithFormat:@"%lu%%",(optionThreeCount*100)/total];
            self.optionFourPercent.text = [NSString stringWithFormat:@"%lu%%",(optionFourCount*100)/total];
        }
    }
    
    NSMutableArray *optionArrays = [[NSMutableArray alloc] initWithObjects:@(self.poll.firstArray.count),@(self.poll.secondArray.count),@(self.poll.thirdArray.count),@(self.poll.fourthArray.count),nil];
    NSMutableArray *currentPlaces = [[NSMutableArray alloc] init];
    NSMutableArray *updatedPlaces = [[NSMutableArray alloc] initWithObjects:@(1),@(2),@(3),@(4),nil];
    NSMutableArray *changes = [[NSMutableArray alloc] init];
    for(int i = 0; i < [self.poll[@"numberOfOptions"] intValue]; i++){
        int maxIndex = i;
        int changeDiff = 0;
        for(int j = 0; j < [self.poll[@"numberOfOptions"] intValue]; j++){
            if([optionArrays[j] intValue] > [optionArrays[maxIndex] intValue]){
                maxIndex = j;
            }
        }
        changeDiff = (maxIndex-i)*60;
        [currentPlaces addObject:@(maxIndex)];
        [changes addObject:@(changeDiff)];
        [optionArrays replaceObjectAtIndex:maxIndex withObject:@(-1)];
    }
    for(int i = 0; i < [self.poll[@"numberOfOptions"] intValue]; i++){
        NSLog(@"%@", [currentPlaces objectAtIndex:i]);
        if([[currentPlaces objectAtIndex:i] intValue] == 0){
            [updatedPlaces replaceObjectAtIndex:0 withObject:@(i+1)];
            self.optionOneChange += [changes[i] intValue];
        }
        else if([[currentPlaces objectAtIndex:i] intValue] == 1){
            [updatedPlaces replaceObjectAtIndex:1 withObject:@(i+1)];
            self.optionTwoChange += [changes[i] intValue];
        }
        else if([[currentPlaces objectAtIndex:i] intValue] == 2){
            [updatedPlaces replaceObjectAtIndex:2 withObject:@(i+1)];
            self.optionThreeChange += [changes[i] intValue];
        }
        else{
            [updatedPlaces replaceObjectAtIndex:3 withObject:@(i+1)];
            self.optionFourChange += [changes[i] intValue];
        }
    }
    [self updatePlaces:[updatedPlaces[0] intValue]:[updatedPlaces[1] intValue]:[updatedPlaces[2] intValue]:[updatedPlaces[3] intValue]];

    [self animateOptions];
}

- (void) animateOptions {
    if(self.state == NOTFIRSTTIME || self.state == POSTCHANGE){
        int oneTemp = self.optionOneChange;
        int twoTemp = self.optionTwoChange;
        int threeTemp = self.optionThreeChange;
        int fourTemp = self.optionFourChange;
        [self swapChanges:self.first:oneTemp];
        [self swapChanges:self.second:twoTemp];
        [self swapChanges:self.third:threeTemp];
        [self swapChanges:self.fourth:fourTemp];
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

- (void) swapChanges:(NSNumber *)location:(int)change{
    if([location isEqual:@1]){
        self.optionOneChange = change;
    }
    if([location isEqual:@2]){
        self.optionTwoChange = change;
    }
    if([location isEqual:@3]){
        self.optionThreeChange = change;
    }
    if([location isEqual:@4]){
        self.optionFourChange = change;
    }
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
