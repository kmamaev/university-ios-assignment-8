#import "Mapper.h"
#import <objc/runtime.h>


static NSString *const defaultDateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";


@implementation Mapper
// TODO: implement error handling

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
    return [self convertValue:dictionary toType:classObj];
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

- (NSObject *)convertValue:(NSObject *)value toType:(Class)classObj
{
    NSDictionary *mappingScheme = self.mappingSchemes[NSStringFromClass(classObj)];
    if (mappingScheme) {
        assert([value isKindOfClass:[NSDictionary class]]);
        return [self convertDictionary:(NSDictionary *)value toType:classObj
            withMappingScheme:mappingScheme];
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
        NSLog(@"Invalid class object: %@", NSStringFromClass(classObj));
        assert(false);
        return nil;
    }
}

- (NSObject *)convertDictionary:(NSDictionary *)dictionary toType:(Class)classObj
    withMappingScheme:(NSDictionary *)mappingScheme
{
    NSObject *object = [[classObj alloc] init];
    
    for (NSString *key in mappingScheme.allKeys) {
        NSString *value = dictionary[mappingScheme[key]];
        assert(value);
        
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
            [object setValue:[self convertValue:value toType:typeClass] forKey:key];
        }
        else {
            NSLog(@"Error: Unrecognized property type: %@", typeAttribute);
            assert(false);
        }
    }
    
    return object;
}

@end
