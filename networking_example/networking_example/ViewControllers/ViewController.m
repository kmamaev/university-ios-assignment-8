#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import "RepositoriesListVC.h"
#import "Mapper.h"
#import "MapperInitializer.h"
#import "Repository.h"
#import "User.h"
#import "UsersVC.h"
#import "LoginVC.h"
#import "RepositoriesHelper.h"
#import "UIViewController+ActivityModalView.h"
#import "AlertUtils.h"


static NSString *const defaultUserNameText = @"not logged in";
static NSString *const loginButtonTitle = @"Log In";
static NSString *const logoutButtonTitle = @"Log Out";


@interface ViewController () <UITextFieldDelegate, LoginVCDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) Mapper *mapper;
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) LoginVC *loginVC;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
    
    // Initialize mapper with mapping schemes
    self.mapper = [[Mapper alloc] init];
    [MapperInitializer initializeMappingSchemesForMapper:self.mapper];
    
    // Initialize username's label
    self.userNameLabel.text = self.userName ? self.userName : defaultUserNameText;
    
    // Initialize "log in/log out" button
    [self updateLoginButtonTitle];
}

- (void)updateLoginButtonTitle
{
    NSString *neededLoginButtonTitle = self.userName ? logoutButtonTitle : loginButtonTitle;
    [self.loginButton setTitle:neededLoginButtonTitle forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.userNameField.text.length > 0) {
        [self getRepositoriesAndShow];
    }
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    if (self.userNameField.text.length > 0) {
        [self getRepositoriesAndShow];
    }
}

- (void)getRepositoriesAndShow
{
    [self showActivityModalView];
    
    NSString *userName = self.userNameField.text;
    
    [self.userNameField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller
        getRepositoriesForUser:userName
        success:^(NSArray *dictionaries) {
            NSArray *repositories = [wself.mapper generateObjectsOfClass:[Repository class]
                byDictionaries:dictionaries];
            [RepositoriesHelper addCommitsCountToRepositories:(NSArray *)repositories
                success:^(NSArray *repositories) {
                    typeof(wself) __strong sself = wself;
                    RepositoriesListVC *repositoriesListVC = [[RepositoriesListVC alloc]
                        initWithRepositories:repositories];
                    repositoriesListVC.mapper = self.mapper;
                    [sself.navigationController pushViewController:repositoriesListVC animated:YES];
                    [sself hideActivityModalView];
                } failure:^(NSArray *errors) {
                    for (NSError *error in errors) {
                        NSLog(@"Error: %@", error);
                    }
                    typeof(wself) __strong sself = wself;
                    [sself hideActivityModalView];
                    NSError *error = errors.firstObject;
                    showInfoAlert(@"Unable to receive data", error.localizedDescription, sself);
                }];
        }
        failure:^(NSError *error) {
            typeof(wself) __strong sself = wself;
            NSLog(@"Error: %@", error);
            [sself hideActivityModalView];
            showInfoAlert(@"Unable to receive data", error.localizedDescription, sself);
        }];
}

- (IBAction)userSearchButtonDidTap:(UIButton *)sender
{
    [self showActivityModalView];

    typeof(self) __weak wself = self;
    [self.controller searchUsersByString:self.userNameField.text success:^(NSDictionary *searchResult) {
            typeof(wself) __strong sself = wself;
            NSArray *usersDictionaries = searchResult[@"items"];
            NSArray *users = [sself.mapper generateObjectsOfClass:[User class]
                byDictionaries:usersDictionaries];
            UsersVC *usersVC = [[UsersVC alloc] initWithUsers:users];
            usersVC.mapper = self.mapper;
            [sself.navigationController pushViewController:usersVC animated:YES];
            [sself hideActivityModalView];
        } failure:^(NSError *error) {
            typeof(wself) __strong sself = wself;
            NSLog(@"Error: %@", error);
            [sself hideActivityModalView];
            showInfoAlert(@"Unable to receive data", error.localizedDescription, sself);
        }];
}

- (IBAction)loginButtonDidTap:(UIButton *)sender
{
    self.loginVC = [[LoginVC alloc] init];
    self.loginVC.delegate = self;
    [self presentViewController:self.loginVC animated:YES completion:nil];
    
    // TODO: handle log out button tapping
}

#pragma mark - LoginVCDelegate implementation

- (void)loginVCDelegateDidFinishLoginWithUsername:(NSString *)username
{
    [self.loginVC dismissViewControllerAnimated:YES completion:nil];
    self.userName = username;
    if (self.userName) {
        self.userNameLabel.text = self.userName;
    }
    [self updateLoginButtonTitle];
}

@end
