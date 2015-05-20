#import "RepositoriesListVC.h"
#import "Repository.h"
#import "ReporitoryVC.h"


static NSString *const reuseId = @"ReuseId";

@interface RepositoriesListVC () <UITableViewDataSource, UITableViewDelegate>
@end


@implementation RepositoriesListVC

- (instancetype)initWithRepositories:(NSArray *)repositories
{
    self = [self init];
    if (self != nil) {
        _repositories = repositories;
    }
    return self;
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Repository *repository = self.repositories[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:reuseId];
    }
    cell.textLabel.text = repository.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"commits count = %ld",
        repository.commitsCount];
    return cell;
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReporitoryVC *repositoryVC = [[ReporitoryVC alloc] initWithRepository:self.repositories[indexPath.row]];
    repositoryVC.mapper = self.mapper;
    [self.navigationController pushViewController:repositoryVC animated:YES];
}

@end
