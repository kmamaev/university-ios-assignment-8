#import "RepositoriesHelper.h"
#import "Repository.h"
#import "GITHUBAPIController.h"


@implementation RepositoriesHelper

+ (void)addCommitsCountToRepositories:(NSArray *)repositories
    success:(void (^)(NSArray *))success
    failure:(void (^)(NSArray *))failure
{
    GITHUBAPIController *githubAPIController = [GITHUBAPIController sharedController];
    NSMutableArray *__block errors = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (Repository *repository in repositories) {
        dispatch_group_enter(group);
        [githubAPIController
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

@end
