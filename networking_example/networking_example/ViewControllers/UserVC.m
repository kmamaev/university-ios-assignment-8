#import "UserVC.h"
#import "User.h"
#import "RepositoriesHelper.h"
#import "UIViewController+ActivityModalView.h"
#import "GITHUBAPIController.h"
#import "Repository.h"
#import "RepositoriesListVC.h"
#import "Mapper.h"
#import "AlertUtils.h"


@interface UserVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UIButton *repositoriesUrlButton;
@property (strong, nonatomic) IBOutlet UILabel *avatarUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) GITHUBAPIController *controller;
@end


@implementation UserVC

- (instancetype)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.controller = [GITHUBAPIController sharedController];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.nameLabel.text = self.user.name;
    self.idLabel.text = [self.user.userId stringValue];
    self.urlLabel.text = self.user.url.absoluteString;
    [self.repositoriesUrlButton setTitle:self.user.reposUrl.absoluteString forState:UIControlStateNormal];
    self.repositoriesUrlButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.avatarUrlLabel.text = self.user.avatarUrl.absoluteString;
    self.typeLabel.text = self.user.type;
}

- (IBAction)repositoriesUrlButtonDidTap:(UIButton *)sender
{
    [self showActivityModalView];
    
    typeof(self) __weak wself = self;
    
    [self.controller
        getRepositoriesForUser:self.user.name
        success:^(NSArray *dictionaries) {
            NSArray *repositories = [wself.mapper generateObjectsOfClass:[Repository class]
                byDictionaries:dictionaries];
            [RepositoriesHelper addCommitsCountToRepositories:(NSArray *)repositories
                success:^(NSArray *repositories) {
                    typeof(wself) __strong sself = wself;
                    RepositoriesListVC *repositoriesListVC = [[RepositoriesListVC alloc]
                        initWithRepositories:repositories];
                    repositoriesListVC.mapper = self.mapper;
                    [sself.navigationController pushViewController:repositoriesListVC animated:YES];
                    [sself hideActivityModalView];
                } failure:^(NSArray *errors) {
                    for (NSError *error in errors) {
                        NSLog(@"Error: %@", error);
                    }
                    typeof(wself) __strong sself = wself;
                    [sself hideActivityModalView];
                    NSError *error = errors.firstObject;
                    showInfoAlert(@"Unable to receive data", error.localizedDescription, sself);
                }];
        }
        failure:^(NSError *error) {
            typeof(wself) __strong sself = wself;
            NSLog(@"Error: %@", error);
            [sself hideActivityModalView];
            showInfoAlert(@"Unable to receive data", error.localizedDescription, sself);
        }];
}

@end
