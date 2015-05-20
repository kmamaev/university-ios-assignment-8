#import <UIKit/UIKit.h>


@class Repository, Mapper;


@interface ReporitoryVC : UIViewController
@property (nonatomic, strong, readonly) Repository *repository;
@property (strong, nonatomic) Mapper *mapper;
- (instancetype)initWithRepository:(Repository *)repository;
@end
