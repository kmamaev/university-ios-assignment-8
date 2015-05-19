#import "ReporitoryVC.h"
#import "Repository.h"


@interface ReporitoryVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *privacyLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *cloneUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *forksCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *commitsCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastCommitLabel;
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
    // TODO: implement owner displaying
    self.ownerLabel.text = @"Not implemented yet";
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

@end
