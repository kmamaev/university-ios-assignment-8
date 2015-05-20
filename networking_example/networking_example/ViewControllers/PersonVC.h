#import <UIKit/UIKit.h>


@class Person;


@interface PersonVC : UIViewController
@property (nonatomic, strong, readonly) Person *person;
- (instancetype)initWithPerson:(Person *)person;
@end
