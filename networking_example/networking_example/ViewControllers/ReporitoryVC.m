#import "ReporitoryVC.h"
#import "UserVC.h"
#import "Repository.h"
#import "User.h"


@interface ReporitoryVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *ownerButton;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *privacyLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *cloneUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *forksCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *commitsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastCommitLabel;
- (IBAction)ownerButtonDidTap:(UIButton *)sender;
@end


@implementation ReporitoryVC

- (instancetype)initWithRepository:(Repository *)repository
{
    self = [super init];
    if (self) {
        _repository = repository;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
    }

    self.nameLabel.text = self.repository.name;
    [self.ownerButton setTitle:self.repository.owner.name forState:UIControlStateNormal];
    self.ownerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.fullNameLabel.text = self.repository.fullName;
    self.descriptionLabel.text = self.repository.repositoryDescription;
    self.privacyLabel.text = self.repository.isPrivate ? @"Yes" : @"No";
    self.urlLabel.text = self.repository.repositoryUrl.absoluteString;
    self.cloneUrlLabel.text = self.repository.cloneUrl.absoluteString;
    self.forksCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.repository.forksCount];
    self.commitsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.repository.commitsCount];
    self.creationDateLabel.text = [formatter stringFromDate:self.repository.creationDate];
    self.lastCommitLabel.text = [formatter stringFromDate:self.repository.lastCommitDate];
}

- (IBAction)ownerButtonDidTap:(UIButton *)sender
{
    UserVC *userVC = [[UserVC alloc] initWithUser:self.repository.owner];
    [self.navigationController pushViewController:userVC animated:YES];
}

@end
