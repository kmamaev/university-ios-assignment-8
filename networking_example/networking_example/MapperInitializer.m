#import "MapperInitializer.h"
#import "Mapper.h"
#import "Repository.h"
#import "User.h"


static Mapper *staticMapper;

static NSString *const kRepositoryName = @"name";
static NSString *const kRepositoryFullName = @"full_name";
static NSString *const kRepositoryOwner = @"owner";
static NSString *const kRepositoryDescription = @"description";
static NSString *const kRepositoryPrivacy = @"private";
static NSString *const kRepositoryUrl = @"html_url";
static NSString *const kRepositoryCloneUrl = @"clone_url";
static NSString *const kRepositoryForksCount = @"forks_count";
static NSString *const kRepositoryCreationDate = @"created_at";
static NSString *const kRepositoryLastCommitDate = @"pushed_at";

static NSString *const kUserName = @"login";
static NSString *const kUserId = @"id";
static NSString *const kUserUrl = @"url";
static NSString *const kUserReposUrl = @"repos_url";
static NSString *const kUserAvatarUrl = @"avatar_url";
static NSString *const kUserType = @"type";


@implementation MapperInitializer

+ (void)initializeMappingSchemesForMapper:(Mapper *)mapper
{
    staticMapper = mapper;
    [self initializeRepositoryMappingScheme];
    [self initializeUserMappingScheme];
}

+ (void)initializeRepositoryMappingScheme
{
    NSDictionary *repositoryScheme = @{
            NSStringFromSelector(@selector(name)): kRepositoryName,
            NSStringFromSelector(@selector(fullName)): kRepositoryFullName,
            NSStringFromSelector(@selector(owner)): kRepositoryOwner,
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

+ (void)initializeUserMappingScheme
{
    NSDictionary *UserScheme = @{
            NSStringFromSelector(@selector(name)): kUserName,
            NSStringFromSelector(@selector(userId)): kUserId,
            NSStringFromSelector(@selector(url)): kUserUrl,
            NSStringFromSelector(@selector(reposUrl)): kUserReposUrl,
            NSStringFromSelector(@selector(avatarUrl)): kUserAvatarUrl,
            NSStringFromSelector(@selector(type)): kUserType
        };
    [staticMapper addMappingScheme:UserScheme forClass:[User class]];
}

@end
