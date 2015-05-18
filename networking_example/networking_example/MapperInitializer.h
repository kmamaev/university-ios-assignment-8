#import <Foundation/Foundation.h>


@class Mapper;


@interface MapperInitializer : NSObject

+ (void)initializeMappingSchemesForMapper:(Mapper *)mapper;

@end
