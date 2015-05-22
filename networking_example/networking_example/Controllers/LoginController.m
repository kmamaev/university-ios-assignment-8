#import "LoginController.h"
#include "GITHUBAPIController.h"
#import <AFHTTPRequestOperation.h>


static NSString *const kUsername = @"username";
static NSString *const kToken = @"token";


@interface LoginController ()
@property (nonatomic, strong) GITHUBAPIController *githubAPIController;
@end


@implementation LoginController

@synthesize username = _username, token = _token;

#pragma mark - Initializations and instansiations

- (instancetype)init
{
    self = [super init];
    if (self) {
        _githubAPIController = [GITHUBAPIController sharedController];
    }
    return self;
}

+ (LoginController *)sharedInstance
{
    static LoginController *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[LoginController alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Getters and setters

- (void)setUsername:(NSString *)username
{
    _username = [username copy];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_username forKey:kUsername];
    [userDefaults synchronize];
}

- (NSString *)username
{
    if (!_username) {
        _username = [[NSUserDefaults standardUserDefaults] stringForKey:kUsername];
    }
    return [_username copy];
}

- (void)setToken:(NSString *)token
{
    _token = [token copy];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_token forKey:kToken];
    [userDefaults synchronize];
}

- (NSString *)token
{
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] stringForKey:kToken];
    }
    return [_token copy];
}

#pragma mark - Actions

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
    success:(void (^)())success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    typeof(self) __weak wself = self;
    [self.githubAPIController loginWithUsername:username password:password
        success:^(NSDictionary *response) {
            typeof(wself) __strong sself = wself;
            NSLog(@"response = %@", response);
            sself.username = username;
            sself.token = response[@"token"];
            sself.githubAPIController.token = sself.token;
            if (!success) {
                return;
            }
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (!failure) {
                return;
            }
            failure(operation, error);
        }];
}

- (void)logout
{
    self.username = nil;
    self.token = nil;
    self.githubAPIController.token = nil;
    [self.githubAPIController invalidateCredantials];
}

- (void)setUpToken
{
    self.githubAPIController.token = self.token;
}

@end
