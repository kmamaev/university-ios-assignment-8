#import "UserVC.h"
#import "User.h"


@interface UserVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *repositoriesUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *avatarUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.nameLabel.text = self.user.name;
    self.idLabel.text = [self.user.userId stringValue];
    self.urlLabel.text = self.user.url.absoluteString;
    self.repositoriesUrlLabel.text = self.user.reposUrl.absoluteString;
    self.avatarUrlLabel.text = self.user.avatarUrl.absoluteString;
    self.typeLabel.text = self.user.type;
}

@end
