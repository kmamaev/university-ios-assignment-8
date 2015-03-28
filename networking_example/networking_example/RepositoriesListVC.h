#import <UIKit/UIKit.h>


@interface RepositoriesListVC : UITableViewController

@property (strong, nonatomic, readonly) NSArray *repositories;

- (instancetype)initWithRepositories:(NSArray *)repositories;

@end
