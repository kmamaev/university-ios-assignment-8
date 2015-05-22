#import "LoginVC.h"
#import "GITHUBAPIController.h"
#import "LoginController.h"
#import "AlertUtils.h"
#import "AFHTTPRequestOperation.h"


@interface LoginVC ()
@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) GITHUBAPIController *controller;
@end


@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
}

- (IBAction)loginButtonDidTap:(UIButton *)sender
{
    [self showActivityModalView];
    NSString *username = self.loginTextField.text;
    NSString *password = self.passwordTextField.text;
    typeof(self) __weak wself = self;
    LoginController *loginController = [LoginController sharedInstance];
    [loginController loginWithUsername:username password:password
        success:^{
            NSLog(@"Login succeded.");
            [self hideActivityModalView];
            [wself.delegate loginVCDelegateDidFinishLoginWithUsername:username];
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self hideActivityModalView];
            if (operation.response.statusCode == 401) { // unauthorized
                showInfoAlert(@"Login Failed", @"Username or password is incorrect.", self);
            }
            else {
                NSLog(@"Error: %@", error.localizedDescription);
                showInfoAlert(@"Login Failed", error.localizedDescription, self);
            }
        }];
}

- (IBAction)cancelButtonDidTap:(UIButton *)sender
{
    [self.delegate loginVCDelegateDidFinishLoginWithUsername:nil];
}

@end
