#import <Foundation/Foundation.h>


@interface RepositoriesHelper : NSObject

+ (void)addCommitsCountToRepositories:(NSArray *)repositories
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSArray *))failure;

@end
