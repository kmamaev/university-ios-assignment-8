#import <Foundation/Foundation.h>


@class Person;


@interface Repository : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, assign) NSInteger commitsCount;
@property (nonatomic, strong) Person *owner;
@property (nonatomic, copy) NSString *repositoryDescription;
@property (nonatomic, assign) BOOL isPrivate;
@property (nonatomic, strong) NSURL *repositoryUrl;
@property (nonatomic, strong) NSURL *cloneUrl;
@property (nonatomic, assign) NSInteger forksCount;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *lastCommitDate;
@end