#import "GITHUBAPIController.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const kBaseAPIURL = @"https://api.github.com";
static NSString *const appTokenDescription = @"iOS application";


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
        GET:[self authorizedRequestStringByString:requestString]
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
        GET:[self authorizedRequestStringByString:requestString]
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
        GET:[self authorizedRequestStringByString:requestString]
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
        GET:[self authorizedRequestStringByString:requestString]
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

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *requestString = @"/authorizations";
    
    NSString *uniqueAppTokenDescription = [appTokenDescription
        stringByAppendingString:[NSUUID UUID].UUIDString];
    
    NSDictionary *requestParameter = @{@"note": uniqueAppTokenDescription};
    
    [self.requestManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username
        password:password];
    
    [self.requestManager
        POST:requestString
        parameters:requestParameter
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self invalidateCredantials];
            if (!success) {
                return;
            }
            success(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self invalidateCredantials];
            if (!failure) {
                return;
            }
            failure(operation, error);
        }];
}

- (void)invalidateCredantials
{
    [self.requestManager.requestSerializer clearAuthorizationHeader];
}

#pragma mark - Auxiliaries

- (NSString *)authorizedRequestStringByString:(NSString *)requesString
{
    if (self.token) {
        return [NSString stringWithFormat:@"%@?access_token=%@", requesString, self.token];
    }
    else {
        return requesString;
    }
}

@end
