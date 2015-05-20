#import "AlertUtils.h"
#import <UIKit/UIKit.h>


void showInfoAlert(NSString *title, NSString *description, id delegate)
{
    NSString *cancelButtonTitle = NSLocalizedString(@"close",);
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:title
            message:description
            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAlert = [UIAlertAction
            actionWithTitle:cancelButtonTitle
            style:UIAlertActionStyleDefault
            handler:nil];
        [alert addAction:closeAlert];
        [delegate presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:title
            message:description
            delegate:delegate
            cancelButtonTitle:cancelButtonTitle
            otherButtonTitles:nil];
        [alertView show];
    }
}