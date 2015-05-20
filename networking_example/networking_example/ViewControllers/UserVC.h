#import <UIKit/UIKit.h>


@class User, Mapper;


@interface UserVC : UIViewController
@property (nonatomic, strong, readonly) User *user;
@property (strong, nonatomic) Mapper *mapper;
- (instancetype)initWithUser:(User *)user;
@end
