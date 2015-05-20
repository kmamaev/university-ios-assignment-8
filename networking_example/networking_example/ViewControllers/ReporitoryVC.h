#import <UIKit/UIKit.h>


@class Repository;


@interface ReporitoryVC : UIViewController
@property (nonatomic, strong, readonly) Repository *repository;
- (instancetype)initWithRepository:(Repository *)repository;
@end
