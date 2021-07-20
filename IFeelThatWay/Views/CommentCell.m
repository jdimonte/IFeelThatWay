//
//  CommentCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/13/21.
//

#import "CommentCell.h"
#import "User.h"

@implementation CommentCell

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
    if(![self.commentCell[@"agreesArray"] containsObject: user.objectId]){
        [self.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
        [self.commentCell addUniqueObject:user.objectId forKey:@"agreesArray"];
    }
    else{
        [self.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
        [self.commentCell removeObject:user.objectId forKey:@"agreesArray"];
    }
    self.commentCell.agreesCount = [NSNumber numberWithInt:self.commentCell.agreesArray.count];
    [self.commentCell saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    self.agreesCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.commentCell.agreesArray.count];
}

- (IBAction)saveButtonTapped:(id)sender {
    User *user = [PFUser currentUser];
    if(![self.commentCell[@"savesArray"] containsObject: user.objectId]){
        [self.saveButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
        [self.commentCell addUniqueObject:user.objectId forKey:@"savesArray"];
    }
    else{
        [self.saveButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
        [self.commentCell removeObject:user.objectId forKey:@"savesArray"];
    }
    [self.commentCell saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



@end
