#import <Foundation/Foundation.h>


@interface User : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL *reposUrl;
@property (nonatomic, strong) NSURL *avatarUrl;
@property (nonatomic, copy) NSString *type;
@end
