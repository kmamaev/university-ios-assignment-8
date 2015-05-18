#import "Mapper.h"


@implementation Mapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mappingSchemes = [NSDictionary dictionary];
    }
    return self;
}

- (void)addMappingScheme:(NSDictionary *)mappingScheme forClass:(Class)classObj
{
    NSMutableDictionary *mutableMappingSchemes = [NSMutableDictionary dictionary];
    mutableMappingSchemes = [self.mappingSchemes mutableCopy];
    mutableMappingSchemes[NSStringFromClass(classObj)] = mappingScheme;
    self.mappingSchemes = mutableMappingSchemes;
}

- (NSObject *)generateObjectOfClass:(Class)classObj byDictionary:(NSDictionary *)dictionary
{
    // TODO: handle absenting of the class key in the mapping schemes
    
    NSDictionary *mappingScheme = self.mappingSchemes[NSStringFromClass(classObj)];
    
    NSObject *object = [[classObj alloc] init];
    
    for (NSString *key in mappingScheme.allKeys) {
        // TODO: check if the dictionary actually contains the key
        id value = dictionary[mappingScheme[key]];
        [object setValue:value forKey:key];
    }

    return object;
}

- (NSArray *)generateObjectsOfClass:(Class)classObj byDictionaries:(NSArray *)dictionaries
{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        NSObject *object = [self generateObjectOfClass:classObj byDictionary:dictionary];
        [objects addObject:object];
    }
    return objects;
}

@end
