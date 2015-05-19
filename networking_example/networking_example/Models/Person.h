#import <Foundation/Foundation.h>


@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *personId;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL *reposUrl;
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, copy) NSString *type;
@end
