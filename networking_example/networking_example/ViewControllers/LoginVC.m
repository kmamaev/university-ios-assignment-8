#import "LoginVC.h"
#import "GITHUBAPIController.h"


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
    NSString *username = self.loginTextField.text;
    NSString *password = self.passwordTextField.text;
    [self.controller loginWithUsername:username password:password success:^(NSDictionary *response) {
            NSLog(@"response = %@", response);
            // TODO: implement this
        } failure:^(NSError *error) {
            NSLog(@"error = %@", error.localizedDescription);
            // TODO: implement this
        }];
}

@end
