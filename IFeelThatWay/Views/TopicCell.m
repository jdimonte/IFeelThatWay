//
//  TopicCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "TopicCell.h"
#import "User.h"
#import <Parse/Parse.h>

@implementation TopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followTapped:(id)sender {
    if([self.followButton.currentImage isEqual:[UIImage systemImageNamed:@"checkmark.square"]]){
        [self.followButton setImage:[UIImage systemImageNamed:@"checkmark.square.fill"] forState:UIControlStateNormal];
    }
    else{
        [self.followButton setImage:[UIImage systemImageNamed:@"checkmark.square"] forState:UIControlStateNormal];
    }
}

@end
