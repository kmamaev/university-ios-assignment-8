#import "UIViewController+ActivityModalView.h"
#import <objc/runtime.h>


@implementation UIViewController (ActivityModalView)
@dynamic grayView, activityIndicator;

- (void)showActivityModalView
{
    if (!self.grayView) {
        [self initializeGrayView];
    }
    [self.activityIndicator startAnimating];
}

- (void)hideActivityModalView
{
    [self.grayView removeFromSuperview];
    [self.activityIndicator stopAnimating];
}

- (void)initializeGrayView
{
    self.grayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.grayView.center;
    [self.grayView addSubview:self.activityIndicator];
    [self.view addSubview:self.grayView];
}

- (UIView *)grayView {
    return objc_getAssociatedObject(self, @selector(grayView));
}

- (void)setGrayView:(UIView *)grayView {
    objc_setAssociatedObject(self, @selector(grayView), grayView,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicator {
    return objc_getAssociatedObject(self, @selector(activityIndicator));
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, @selector(activityIndicator), activityIndicator,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
