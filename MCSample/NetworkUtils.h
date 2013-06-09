//
//  NetworkUtils.h
//  MCSample
//
//  Created by MIYOKAWA, Nobuyoshi on 2013/06/09.
//

#import <Foundation/Foundation.h>

@interface NetworkUtils : NSObject

+ (NSString *)lo0IPAddress;
+ (NSString *)en0IPAddress;
+ (void)showNetworkInterfacesFromKernel;
+ (void)showNetworkInterfacesOnCN;

@end

// EOF
