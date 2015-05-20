#import <UIKit/UIKit.h>


@interface UIViewController (ActivityModalView)
@property (strong, nonatomic) UIView *grayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
- (void)showActivityModalView;
- (void)hideActivityModalView;
@end
