//
//  ReplyCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import "ReplyCell.h"
#import "User.h"

@implementation ReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handRaiseButtonTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(![self.replyCell[@"agreesArray"] containsObject: user.objectId]){
        [self.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
        [self.replyCell addUniqueObject:user.objectId forKey:@"agreesArray"];
        
    }
    else{
        [self.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
        [self.replyCell removeObject:user.objectId forKey:@"agreesArray"];
    }
    self.replyCell.agreesCount = [NSNumber numberWithInt:self.replyCell.agreesArray.count];
    [self.replyCell saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    self.agreesCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.replyCell.agreesArray.count];
}

- (IBAction)saveButtonTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(![self.replyCell[@"savesArray"] containsObject: user.objectId]){
        [self.saveButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
        [self.replyCell addUniqueObject:user.objectId forKey:@"savesArray"];
    }
    else{
        [self.saveButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
        [self.replyCell removeObject:user.objectId forKey:@"savesArray"];
    }
    [self.replyCell saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
