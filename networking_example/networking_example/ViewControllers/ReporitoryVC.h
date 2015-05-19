#import "ViewController.h"


@class Repository;


@interface ReporitoryVC : ViewController
@property (nonatomic, strong, readonly) Repository *repository;
- (instancetype)initWithRepository:(Repository *)repository;
@end
