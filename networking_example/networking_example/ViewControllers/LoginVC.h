#import <UIKit/UIKit.h>


@protocol LoginVCDelegate <NSObject>
- (void)loginVCDelegateDidFinishLoginWithUsername:(NSString *)username;
@end


@interface LoginVC : UIViewController
@property (nonatomic, weak) id<LoginVCDelegate> delegate;
@end
