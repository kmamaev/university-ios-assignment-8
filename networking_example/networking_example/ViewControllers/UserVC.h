#import "SuperViewController.h"


@class User, Mapper;


@interface UserVC : SuperViewController
@property (nonatomic, strong, readonly) User *user;
@property (strong, nonatomic) Mapper *mapper;
- (instancetype)initWithUser:(User *)user;
@end
