#import "MapperInitializer.h"
#import "Mapper.h"
#import "Repository.h"
#import "Person.h"


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

static NSString *const kPersonName = @"login";
static NSString *const kPersonId = @"id";
static NSString *const kPersonUrl = @"url";
static NSString *const kPersonReposUrl = @"repos_url";
static NSString *const kPersonAvatarUrl = @"avatar_url";
static NSString *const kPersonType = @"type";


@implementation MapperInitializer

+ (void)initializeMappingSchemesForMapper:(Mapper *)mapper
{
    staticMapper = mapper;
    [self initializeRepositoryMappingScheme];
    [self initializePersonMappingScheme];
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

+ (void)initializePersonMappingScheme
{
    NSDictionary *personScheme = @{
            NSStringFromSelector(@selector(name)): kPersonName,
            NSStringFromSelector(@selector(personId)): kPersonId,
            NSStringFromSelector(@selector(url)): kPersonUrl,
            NSStringFromSelector(@selector(reposUrl)): kPersonReposUrl,
            NSStringFromSelector(@selector(avatarUrl)): kPersonAvatarUrl,
            NSStringFromSelector(@selector(type)): kPersonType
        };
    [staticMapper addMappingScheme:personScheme forClass:[Person class]];
}

@end
