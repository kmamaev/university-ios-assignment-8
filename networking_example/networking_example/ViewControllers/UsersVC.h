#import <UIKit/UIKit.h>


@class Mapper;


@interface UsersVC : UIViewController
@property (strong, nonatomic, readonly) NSArray *users;
@property (strong, nonatomic) Mapper *mapper;
- (instancetype)initWithUsers:(NSArray *)users;
@end
