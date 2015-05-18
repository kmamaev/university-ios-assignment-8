#import <Foundation/Foundation.h>


@interface Mapper : NSObject

@property (strong, nonatomic) NSDictionary *mappingSchemes;

- (void)addMappingScheme:(NSDictionary *)mappingScheme forClass:(Class)classObj;
- (NSObject *)generateObjectOfClass:(Class)classObj byDictionary:(NSDictionary *)dictionary;
- (NSArray *)generateObjectsOfClass:(Class)classObj byDictionaries:(NSArray *)dictionaries;

@end
