#import <Foundation/Foundation.h>


@class AFHTTPRequestOperation;


@interface LoginController : NSObject

+ (LoginController *)sharedInstance;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
    success:(void (^)())success
    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)logout;

@end
