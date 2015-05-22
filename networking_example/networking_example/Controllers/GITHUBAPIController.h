#import <Foundation/Foundation.h>


@class AFHTTPRequestOperation;


@interface GITHUBAPIController : NSObject
+ (instancetype)sharedController;

- (void)getAvatarForUser:(NSString *)userName
    success:(void(^)(NSURL *))success
    failure:(void(^)(NSError *))failure;

- (void)getRepositoriesForUser:(NSString *)userName
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSError *))failure;

- (void)getCommitsCountForRepositoryWithFullName:(NSString *)repositoryFullName
    success:(void (^)(NSNumber *))success
    failure:(void (^)(NSError *))failure;

- (void)searchUsersByString:(NSString *)searchString success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
