//
//  ProfileViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import <GoogleSignIn.h>
#import "ProfilePictureCell.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet User *user;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *colorsArray;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.user = [PFUser currentUser];
    NSString *colorSelected = self.user[@"profilePicture"];
    if(!colorSelected){
        colorSelected = @"red";
    }
    UIImage * colorPicture = [UIImage imageNamed:colorSelected];
    [self.profilePicture setImage:colorPicture];
    
    self.colorsArray = [[NSArray alloc] initWithObjects:@"red",@"pink",@"orange",@"yellow",@"green", @"lightblue",@"blue",@"purple", nil];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)logoutTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    
    [GIDSignIn.sharedInstance signOut];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProfilePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePictureCell" forIndexPath:indexPath];
    
    cell.colorsArray = self.colorsArray;
    cell.index = indexPath.row;
    cell.displayedPicture = self.profilePicture;
    UIImage * colorPicture = [UIImage imageNamed:self.colorsArray[indexPath.row]];
    [cell.profilePicture setImage:colorPicture];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
