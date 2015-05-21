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
    // TODO: implement this
}

@end
