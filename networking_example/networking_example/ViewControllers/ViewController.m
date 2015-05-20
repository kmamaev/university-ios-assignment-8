#import "ViewController.h"
#import "GITHUBAPIController.h"
#import <UIImageView+AFNetworking.h>
#import "RepositoriesListVC.h"
#import "Mapper.h"
#import "MapperInitializer.h"
#import "Repository.h"
#import "Person.h"


static NSString *const kRepositoryCommitsCount = @"commits_count";


@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) GITHUBAPIController *controller;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) UIView *grayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) Mapper *mapper;
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
    
    // Initialize mapper with mapping schemes
    self.mapper = [[Mapper alloc] init];
    [MapperInitializer initializeMappingSchemesForMapper:self.mapper];
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

- (IBAction)userSearchButtonDidTap:(UIButton *)sender
{
    [self showActivityModalView];

    typeof(self) __weak wself = self;
    [self.controller searchUsersByString:self.userNameField.text success:^(NSDictionary *searchResult) {
            typeof(wself) __strong sself = wself;
            NSArray *usersDictionaries = searchResult[@"items"];
            NSArray *users = [sself.mapper generateObjectsOfClass:[Person class]
                byDictionaries:usersDictionaries];
            // TODO: implement openning of UsersVC
            [sself hideActivityModalView];
        } failure:^(NSError *error) {
            typeof(wself) __strong sself = wself;
            NSLog(@"Error: %@", error);
            [sself hideActivityModalView];
            [sself showNetworkErrorAlert:error];
        }];
}


@end
