#import "GITHUBAPIController.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const kBaseAPIURL = @"https://api.github.com";


@interface GITHUBAPIController ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestManager;
@end


@implementation GITHUBAPIController

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:kBaseAPIURL];
        self.requestManager = [[AFHTTPRequestOperationManager alloc]
            initWithBaseURL:apiURL];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

+ (instancetype)sharedController
{
    static GITHUBAPIController *_instance = nil;
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }

    return _instance;
}

#pragma mark - Inner requests

- (void)getInfoForUser:(NSString *)userName
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = [NSString
        stringWithFormat:@"users/%@", userName];
    
    [self.requestManager
        GET:requestString
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (!success) {
                return;
            }
            success(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (!failure) {
                return;
            }
            failure(error);
        }];
    
}

- (void)getCommitsForRepositoryWithFullName:(NSString *)repositoryFullName
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = [NSString stringWithFormat:@"repos/%@/commits", repositoryFullName];
    
    [self.requestManager
        GET:requestString
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (!success) {
                return;
            }
            success(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (!failure) {
                return;
            }
            failure(error);
        }];
}

#pragma mark - Public methods

- (void)getAvatarForUser:(NSString *)userName
    success:(void (^)(NSURL *))success
    failure:(void (^)(NSError *))failure
{
    [self getInfoForUser:userName
        success:^(NSDictionary *userInfo) {
            if (!success) {
                return;
            }
            NSString *avatarURLString = userInfo[@"avatar_url"];
            NSURL *avatarURL = [NSURL URLWithString:avatarURLString];
            success(avatarURL);
        }
        failure:^(NSError *error) {
            if (!failure) {
                return;
            }
            failure(error);
        }];
}

- (void)getRepositoriesForUser:(NSString *)userName
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = [NSString stringWithFormat:@"users/%@/repos", userName];
    
    [self.requestManager
        GET:requestString
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (!success) {
                return;
            }
            success(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (!failure) {
                return;
            }
            failure(error);
        }];
}

- (void)getCommitsCountForRepositoryWithFullName:(NSString *)repositoryFullName
    success:(void (^)(NSNumber *))success
    failure:(void (^)(NSError *))failure
{
    [self getCommitsForRepositoryWithFullName:repositoryFullName
        success:^(NSArray *commits) {
            if (!success) {
                return;
            }
            success(@(commits.count));
        }
        failure:^(NSError *error) {
            if (!failure) {
                return;
            }
            if (error.code == -1011) {
                success(@(0));
            }
            else {
                failure(error);
            }
        }];
}

- (void)searchUsersByString:(NSString *)searchString success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure
{
    NSString *requestString = @"/search/users";
    NSDictionary *searchParameter = @{@"q": searchString};
    
    [self.requestManager
        GET:requestString
        parameters:searchParameter
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (!success) {
                return;
            }
            success(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (!failure) {
                return;
            }
            failure(error);
        }];
}

@end
