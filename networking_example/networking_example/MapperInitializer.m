#import "MapperInitializer.h"
#import "Mapper.h"
#import "Repository.h"


static Mapper *staticMapper;
static NSString *const kRepositoryName = @"name";
static NSString *const kRepositoryFullName = @"full_name";
static NSString *const kRepositoryDescription = @"description";
static NSString *const kRepositoryPrivacy = @"private";
static NSString *const kRepositoryUrl = @"html_url";
static NSString *const kRepositoryCloneUrl = @"clone_url";
static NSString *const kRepositoryForksCount = @"forks_count";
static NSString *const kRepositoryCreationDate = @"created_at";
static NSString *const kRepositoryLastCommitDate = @"pushed_at";


@implementation MapperInitializer

+ (void)initializeMappingSchemesForMapper:(Mapper *)mapper
{
    staticMapper = mapper;
    [self initializeRepositoryMappingScheme];
}

+ (void)initializeRepositoryMappingScheme
{
    NSDictionary *repositoryScheme = @{
            NSStringFromSelector(@selector(name)): kRepositoryName,
            NSStringFromSelector(@selector(fullName)): kRepositoryFullName,
            // TODO: owner
            NSStringFromSelector(@selector(repositoryDescription)): kRepositoryDescription,
            NSStringFromSelector(@selector(isPrivate)): kRepositoryPrivacy,
            NSStringFromSelector(@selector(repositoryUrl)): kRepositoryUrl,
            NSStringFromSelector(@selector(cloneUrl)): kRepositoryCloneUrl,
            NSStringFromSelector(@selector(forksCount)): kRepositoryForksCount,
            NSStringFromSelector(@selector(creationDate)): kRepositoryCreationDate,
            NSStringFromSelector(@selector(lastCommitDate)): kRepositoryLastCommitDate
        };
    [staticMapper addMappingScheme:repositoryScheme forClass:[Repository class]];
}

@end
