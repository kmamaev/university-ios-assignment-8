#import "Mapper.h"
#import <objc/runtime.h>


static NSString *const defaultDateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
static NSString *const errorDomain = @"MapperDomain";
static NSInteger const errorCode = 1;


@implementation Mapper

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mappingSchemes = [NSDictionary dictionary];
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = defaultDateFormat;
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
    return [self generateObjectOfClass:classObj byDictionary:dictionary withError:nil];
}

- (NSArray *)generateObjectsOfClass:(Class)classObj byDictionaries:(NSArray *)dictionaries
{
    return [self generateObjectsOfClass:classObj byDictionaries:dictionaries withError:nil];
}

- (NSObject *)generateObjectOfClass:(Class)classObj byDictionary:(NSDictionary *)dictionary
    withError:(NSError *__autoreleasing *)error
{
    return [self convertValue:dictionary toType:classObj withError:error];
}

- (NSArray *)generateObjectsOfClass:(Class)classObj byDictionaries:(NSArray *)dictionaries
    withError:(NSError *__autoreleasing *)error
{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in dictionaries) {
        NSObject *object = [self generateObjectOfClass:classObj byDictionary:dictionary];
        [objects addObject:object];
    }
    return objects;
}

- (NSObject *)convertValue:(NSObject *)value toType:(Class)classObj
    withError:(NSError *__autoreleasing *)error
{
    NSDictionary *mappingScheme = self.mappingSchemes[NSStringFromClass(classObj)];
    if (mappingScheme) {
        if (![value isKindOfClass:[NSDictionary class]]) {
            NSString *errorMessage = [NSString stringWithFormat:
                @"Error: Expected 'NSDictionary' class but received '%@'", NSStringFromClass([value class])];
            NSLog(@"%@", errorMessage);
            if (error) {
                NSDictionary *const userInfo = @{NSLocalizedDescriptionKey: errorMessage};
                *error = [[NSError alloc] initWithDomain:errorDomain code:errorCode userInfo:userInfo];
            }
            return nil;
        }
        return [self convertDictionary:(NSDictionary *)value toType:classObj
            withMappingScheme:mappingScheme error:error];
    }
    else if (classObj == [NSString class]) {
        return (NSString *)value;
    }
    else if (classObj == [NSDate class]) {
        return [self.dateFormatter dateFromString:(NSString *)value];
    }
    else if (classObj == [NSURL class]) {
        return [NSURL URLWithString:(NSString *)value];
    }
    else if (classObj == [NSNumber class]) {
        return (NSNumber *)value;
    }
    else {
        NSString *errorMessage = [NSString stringWithFormat:@"Error: Invalid class object '%@'",
            NSStringFromClass(classObj)];
        NSLog(@"%@", errorMessage);
        if (error) {
            NSDictionary *const userInfo = @{NSLocalizedDescriptionKey: errorMessage};
            *error = [[NSError alloc] initWithDomain:errorDomain code:errorCode userInfo:userInfo];
        }
        return nil;
    }
}

- (NSObject *)convertDictionary:(NSDictionary *)dictionary toType:(Class)classObj
    withMappingScheme:(NSDictionary *)mappingScheme error:(NSError *__autoreleasing *)error
{
    NSObject *object = [[classObj alloc] init];
    
    for (NSString *key in mappingScheme.allKeys) {
        NSString *value = dictionary[mappingScheme[key]];
        
        if (!value) {
            NSString *errorMessage = [NSString stringWithFormat:
                @"Error: Value for key '%@' is not presented in the passed dictionary", key];
            NSLog(@"%@", errorMessage);
            if (error) {
                NSDictionary *const userInfo = @{NSLocalizedDescriptionKey: errorMessage};
                *error = [[NSError alloc] initWithDomain:errorDomain code:errorCode userInfo:userInfo];
            }
            return nil;
        }
        
        objc_property_t property = class_getProperty(classObj, [key UTF8String]);
        char const *propertyAttrs = property_getAttributes(property);
        NSString *propertyString = [NSString stringWithUTF8String:propertyAttrs];
        NSArray *attributes = [propertyString componentsSeparatedByString:@","];
        NSString *typeAttribute = [attributes objectAtIndex:0];
        NSString *propertyType = [typeAttribute substringFromIndex:1];
        const char *rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            [object setValue:@(value.floatValue) forKey:key];
        }
        else if (strcmp(rawPropertyType, @encode(NSInteger)) == 0) {
            [object setValue:@(value.integerValue) forKey:key];
        }
        else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
            [object setValue:@(value.boolValue) forKey:key];
        }
        else if ([typeAttribute hasPrefix:@"T@"]) {
            NSString *typeClassName = [typeAttribute substringWithRange:
                NSMakeRange(3, typeAttribute.length - 4)];
            Class typeClass = NSClassFromString(typeClassName);
            [object setValue:[self convertValue:value toType:typeClass withError:error] forKey:key];
        }
        else {
            NSString *errorMessage = [NSString stringWithFormat:
                @"Error: Unrecognized property type '%@'", typeAttribute];
            NSLog(@"%@", errorMessage);
            if (error) {
                NSDictionary *const userInfo = @{NSLocalizedDescriptionKey: errorMessage};
                *error = [[NSError alloc] initWithDomain:errorDomain code:errorCode userInfo:userInfo];
            }
            return nil;
        }
    }
    
    return object;
}

@end
