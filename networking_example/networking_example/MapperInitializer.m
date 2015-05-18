#import "MapperInitializer.h"
#import "Mapper.h"
#import "Repository.h"


static Mapper *staticMapper;
static NSString *const kRepositoryName = @"name";
static NSString *const kRepositoryFullName = @"full_name";


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
            NSStringFromSelector(@selector(fullName)): kRepositoryFullName
        };
    [staticMapper addMappingScheme:repositoryScheme forClass:[Repository class]];
}

@end
