#import "ViewController.h"


@class Repository;


@interface ReporitoryVC : ViewController
@property (nonatomic, strong) Repository *repository;
- (instancetype)initWithRepository:(Repository *)repository;
@end
