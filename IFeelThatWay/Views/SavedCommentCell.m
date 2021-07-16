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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)shareTapped:(id)sender {
    [self shareBackgroundAndStickerImage];
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

    // Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    // Set text alignment
    paragraphStyle.alignment = NSTextAlignmentRight;

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

    // Verify app can open custom URL scheme. If able,
    // assign assets to pasteboard, open scheme.
    NSURL *urlScheme = [NSURL URLWithString:@"instagram-stories://share?source_application=com.my.app"];
    if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {

        // Assign background and sticker image assets to pasteboard
        NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundImage" : backgroundImage,
                                     @"com.instagram.sharedSticker.stickerImage" : stickerImage}];
        NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
        // This call is iOS 10+, can use 'setItems' depending on what versions you support
        [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];

        [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
    } else {
        // Handle older app versions or app not installed case
    }
}

@end
