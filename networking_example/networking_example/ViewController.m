#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import "RepositoriesListVC.h"
#import "Repository.h"


static NSString *const kRepositoryName = @"name";
static NSString *const kRepositoryFullName = @"full_name";
static NSString *const kRepositoryCommitsCount = @"commits_count";


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) UIView *grayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.grayView.center;
    [self.grayView addSubview:self.activityIndicator];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textField.text.length > 0) {
        [self getRepositoriesAndShow];
    }
    return NO;
}

- (IBAction)buttonTapped:(UIButton *)sender
{
    if (self.textField.text.length > 0) {
        [self getRepositoriesAndShow];
    }
}

- (void)showImage
{
    NSString *userName = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller
        getAvatarForUser:userName
        success:^(NSURL *imageURL) {
            [wself.imageView setImageWithURL:imageURL];
        }
        failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

- (void)getRepositoriesAndShow
{
    [self showActivityModalView];
    
    NSString *userName = self.textField.text;
    
    [self.textField resignFirstResponder];
    
    typeof(self) __weak wself = self;
    
    [self.controller
        getRepositoriesForUser:userName
        success:^(NSArray *dictionaries) {
            NSArray *repositories = [wself generateRepositoriesArrayFromDictionaries:dictionaries];
            [wself addCommitsCountToRepositories:(NSArray *)repositories
                success:^(NSArray *repositories) {
                    typeof(wself) __strong sself = wself;
                    RepositoriesListVC *repositoriesListVC = [[RepositoriesListVC alloc]
                        initWithRepositories:repositories];
                    [sself.navigationController pushViewController:repositoriesListVC animated:YES];
                    [sself hideActivityModalView];
                } failure:^(NSArray *errors) {
                    for (NSError *error in errors) {
                        NSLog(@"Error: %@", error);
                    }
                    typeof(wself) __strong sself = wself;
                    [sself hideActivityModalView];
                    [sself showNetworkErrorAlert:errors.firstObject];
                }];
        }
        failure:^(NSError *error) {
            typeof(wself) __strong sself = wself;
            NSLog(@"Error: %@", error);
            [sself hideActivityModalView];
            [sself showNetworkErrorAlert:error];
        }];
}

- (void)showActivityModalView
{
    [self.view addSubview:self.grayView];
    [self.activityIndicator startAnimating];
}

- (void)hideActivityModalView
{
    [self.grayView removeFromSuperview];
    [self.activityIndicator stopAnimating];
}

- (NSArray *)generateRepositoriesArrayFromDictionaries:(NSArray *)dictionaries
{
    NSMutableArray *repositories = [NSMutableArray array];
    for (NSDictionary *dict in dictionaries) {
        Repository *repository = [[Repository alloc] init];
        repository.name = dict[kRepositoryName];
        repository.fullName = dict[kRepositoryFullName];
        [repositories addObject:repository];
    }
    return repositories;
}

- (void)addCommitsCountToRepositories:(NSArray *)repositories
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSArray *))failure
{
    NSMutableArray *__block errors = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (Repository *repository in repositories) {
        dispatch_group_enter(group);
        [self.controller
            getCommitsCountForRepositoryWithFullName:repository.fullName
            success:^(NSNumber *commitsCount) {
                NSLog(@"%@ commits count: %@", repository.name, commitsCount);
                repository.commitsCount = [commitsCount integerValue];
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                @synchronized (errors) {
                    [errors addObject:error];
                }
                dispatch_group_leave(group);
            }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"All tasks completed.");
        if (errors.count > 0) {
            if (!failure) {
                return;
            }
            failure(errors);
        }
        else {
            if (!success) {
                return;
            }
            success(repositories);
        }
    });
}

- (void)showNetworkErrorAlert:(NSError *)error
{
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Unable to receive data"
        message:error.localizedDescription
        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeAlert = [UIAlertAction
        actionWithTitle:@"Close"
        style:UIAlertActionStyleDefault
        handler:nil];
    [alert addAction:closeAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
