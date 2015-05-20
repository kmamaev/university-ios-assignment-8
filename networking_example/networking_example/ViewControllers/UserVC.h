#import <UIKit/UIKit.h>


@class User;


@interface UserVC : UIViewController
@property (nonatomic, strong, readonly) User *user;
- (instancetype)initWithUser:(User *)user;
@end
