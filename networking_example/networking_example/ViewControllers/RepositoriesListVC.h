#import <UIKit/UIKit.h>


@class Mapper;


@interface RepositoriesListVC : UITableViewController
@property (strong, nonatomic, readonly) NSArray *repositories;
@property (strong, nonatomic) Mapper *mapper;
- (instancetype)initWithRepositories:(NSArray *)repositories;
@end
