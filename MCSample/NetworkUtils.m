//
//  NetworkUtils.m
//  MCSample
//
//  Created by MIYOKAWA, Nobuyoshi on 2013/06/09.
//

#import "NetworkUtils.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>

#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NetworkUtils

+ (NSString *)lo0IPAddress
{
  return @"127.0.0.1";
}

+ (NSString *)en0IPAddress
{
  return [NetworkUtils ipAddressForInterface:@"en0"];
}

+ (void)showNetworkInterfacesFromKernel
{
  NSLog(@"[showNetworkInterfacesFromKernel]");
#define MAXIFNUM 20
#define MAXIFNAMELEN 128
  for (int i = 1; i < MAXIFNUM; i++) {
    char name[MAXIFNAMELEN];
    memset(name, 0, sizeof(name));
    if (if_indextoname(i, name)) {
      NSString* str =
        [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
      NSLog(@"%@", str);
      [self showIPAddressForInterface:str];
    }
  }
}

+ (void)showNetworkInterfacesOnCN
{
  NSLog(@"[showNetworkInterfacesOnCN]");
  CFArrayRef ifs = CNCopySupportedInterfaces();
  for (CFIndex i = 0; i < CFArrayGetCount(ifs); i++) {
    NSString *nsn = (__bridge NSString *)CFArrayGetValueAtIndex(ifs, i);
    NSLog(@"%@", nsn);
    [self showIPAddressForInterface:nsn];
  }
  if (ifs) {
    CFRelease(ifs);
  }
}

#pragma mark -

+ (void)showIPAddressForInterface:(NSString *)interface
{
  NSString *s = [self ipAddressForInterface:interface];
  if (s) {
    NSLog(@"- %@", s);
  } else {
    NSLog(@"- (no address)");
  }
}

+ (NSString *)ipAddressForInterface:(NSString *)interface
{
  NSString *ret = nil;
  struct ifreq ifr;

  int fd = socket(AF_INET, SOCK_DGRAM, 0);
  ifr.ifr_addr.sa_family = AF_INET;
  strncpy(ifr.ifr_name, [interface UTF8String], IFNAMSIZ-1);

  if (ioctl(fd, SIOCGIFFLAGS, &ifr) == -1) {
    perror("SIOCGIFFLAGS");
    goto exit;
  }
  if (!(ifr.ifr_flags & IFF_UP)) {
    goto exit;
  }
  if (ioctl(fd, SIOCGIFADDR, &ifr) == -1) {
    perror("SIGCGIFADDR");
    goto exit;
  }
  char *s = inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr);
  ret = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];

exit:
  close(fd);

  return ret;
}

@end

// EOF
