//
//  SavedCommentCell.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/15/21.
//

#import "SavedCommentCell.h"

@implementation SavedCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.contentView addGestureRecognizer:swipeLeft];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)shareTapped:(id)sender {
    [self shareBackgroundAndStickerImage];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        User *user = [PFUser currentUser];
        [self.comment removeObject:user.objectId forKey:@"savesArray"];
        [self.comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.savedViewController loadQueryComments];
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

- (void)shareBackgroundAndStickerImage {
    UIImage *img = [self drawText:self.text.text
                                         inImage:[UIImage imageNamed:@"stickerBackgroundImage"]
                                         atPoint:CGPointMake(0, 0)];
    [self backgroundImage:UIImagePNGRepresentation([UIImage imageNamed:@"backgroundImage"])
           stickerImage:UIImagePNGRepresentation(img)];
}

- (UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    UIFont *font = [UIFont fontWithName:@"Courier" size:300];
    NSDictionary *attributes = @{ NSFontAttributeName: font};
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)backgroundImage:(NSData *)backgroundImage
           stickerImage:(NSData *)stickerImage {
    NSURL *urlScheme = [NSURL URLWithString:@"instagram-stories://share?source_application=com.my.app"];
    if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {
        NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundImage" : backgroundImage,
                                     @"com.instagram.sharedSticker.stickerImage" : stickerImage}];
        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];
        [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
    }
}

@end
