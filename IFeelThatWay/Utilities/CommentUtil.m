//
//  CommentUtil.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/24/21.
//

#import "CommentUtil.h"
#import "Report.h"
#import <SCLAlertView.h>

@implementation CommentUtil

+ (void)designComment:(User*)user: (CommentCell*)commentCell: (Comment*)comment{
    commentCell.commentCell = comment;
    commentCell.text.text = comment[@"text"];
    commentCell.agreesCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)commentCell.commentCell.agreesArray.count];
    
    UIImage * colorPicture = [UIImage imageNamed:comment[@"user"][@"profilePicture"]];
    [commentCell.profilePic setImage:colorPicture];
    commentCell.profilePic.layer.cornerRadius =  commentCell.profilePic.frame.size.width / 2;
    commentCell.profilePic.clipsToBounds = true;
    
    if([comment[@"agreesArray"] containsObject: user.objectId]){
        [commentCell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised.fill"] forState:UIControlStateNormal];
    }
    else{
        [commentCell.handRaiseButton setImage:[UIImage systemImageNamed:@"hand.raised"] forState:UIControlStateNormal];
    }
    if([comment[@"savesArray"] containsObject: user.objectId]){
        [commentCell.saveButton setImage:[UIImage systemImageNamed:@"bookmark.fill"] forState:UIControlStateNormal];
    }
    else{
        [commentCell.saveButton setImage:[UIImage systemImageNamed:@"bookmark"] forState:UIControlStateNormal];
    }
}

+ (void)reportMessage:(Comment*)comment: (UIViewController*)currentViewController{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert addButton:@"Report" actionBlock:^(void) {
        Report *report = [Report new];
        report.message = comment.text;
        report.messageAuthor = comment[@"user"];
        report.commentId = comment;
        [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }];
    
    [alert showSuccess:currentViewController title:@"Would you like to report this message?" subTitle:comment.text closeButtonTitle:@"Cancel" duration:0.0f];
}

+ (void)reportReply:(Reply*)reply: (UIViewController*)currentViewController{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert addButton:@"Report" actionBlock:^(void) {
        Report *report = [Report new];
        report.message = reply.text;
        report.messageAuthor = reply[@"user"];
        report.replyId = reply;
        [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }];
    
    [alert showSuccess:currentViewController title:@"Would you like to report this message?" subTitle:reply.text closeButtonTitle:@"Cancel" duration:0.0f];
}

@end
