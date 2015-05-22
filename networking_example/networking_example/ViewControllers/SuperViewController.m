#import "SuperViewController.h"


@implementation SuperViewController

- (void)showActivityModalView
{
    if (!self.grayView) {
        [self initializeGrayView];
    }
    [self.view addSubview:self.grayView];
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
}

@end
