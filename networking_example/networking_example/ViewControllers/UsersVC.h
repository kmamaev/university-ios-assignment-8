#import <UIKit/UIKit.h>


@interface UsersVC : UIViewController
@property (strong, nonatomic, readonly) NSArray *users;
- (instancetype)initWithUsers:(NSArray *)users;
@end
