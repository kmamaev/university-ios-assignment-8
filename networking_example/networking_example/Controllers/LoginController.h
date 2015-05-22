#import <Foundation/Foundation.h>


@class AFHTTPRequestOperation;


@interface LoginController : NSObject

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *token;

+ (LoginController *)sharedInstance;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
    success:(void (^)())success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)logout;
- (void)setUpToken;

@end
