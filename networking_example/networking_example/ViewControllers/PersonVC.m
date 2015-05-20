#import "PersonVC.h"
#import "Person.h"


@interface PersonVC ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *repositoriesUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *avatarUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@end


@implementation PersonVC

- (instancetype)initWithPerson:(Person *)person
{
    self = [super init];
    if (self) {
        _person = person;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.nameLabel.text = self.person.name;
    self.idLabel.text = [self.person.personId stringValue];
    self.urlLabel.text = self.person.url.absoluteString;
    self.repositoriesUrlLabel.text = self.person.reposUrl.absoluteString;
    self.avatarUrlLabel.text = self.person.avatarUrl.absoluteString;
    self.typeLabel.text = self.person.type;
}

@end
