#import "SuperViewController.h"


@protocol LoginVCDelegate <NSObject>
- (void)loginVCDelegateDidFinishLoginWithUsername:(NSString *)username;
@end


@interface LoginVC : SuperViewController
@property (nonatomic, weak) id<LoginVCDelegate> delegate;
@end
