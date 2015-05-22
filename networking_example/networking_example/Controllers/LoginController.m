#import "LoginController.h"
#include "GITHUBAPIController.h"
#import <AFHTTPRequestOperation.h>


@interface LoginController ()
@property (nonatomic, strong) GITHUBAPIController *githubAPIController;
@end


@implementation LoginController

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
            sself.token = response[@"token"];
            sself.username = username;
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
    [self.githubAPIController invalidateCredantials];
}

@end
