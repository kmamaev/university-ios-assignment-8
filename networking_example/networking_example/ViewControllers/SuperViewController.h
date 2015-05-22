#import <UIKit/UIKit.h>


@interface SuperViewController : UIViewController
@property (strong, nonatomic) UIView *grayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
- (void)showActivityModalView;
- (void)hideActivityModalView;
@end
