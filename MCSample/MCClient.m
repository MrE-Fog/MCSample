//
//  MCClient.m
//  MCSample
//
//  Created by MIYOKAWA, Nobuyoshi on 2013/06/08.
//

#import "MCClient.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>

#import "NetworkUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation MCClient

- (void)sendPacket
{
  struct sockaddr_in addr;

  int sock = socket(AF_INET, SOCK_DGRAM, 0);

  addr.sin_family = AF_INET;
  addr.sin_port = htons(MCPORT);
  addr.sin_addr.s_addr = inet_addr(MCADDRESS);
  addr.sin_len = sizeof(addr);

  u_char loop = 0;
#if defined(SEND_PACKET_TO_LOOPBACK)
  loop = 1;
#endif
  setsockopt(sock, IPPROTO_IP, IP_MULTICAST_LOOP, &loop, sizeof(loop));

#if defined(SETUP_SEND_MULTICAST_IF_LO0) || defined(SETUP_SEND_MULTICAST_IF_EN0)
  in_addr_t ipaddr = inet_addr(
#if defined(SETUP_SEND_MULTICAST_IF_LO0)
    [[NetworkUtils lo0IPAddress] UTF8String]
#elif defined(SETUP_SEND_MULTICAST_IF_EN0)
    [[NetworkUtils en0IPAddress] UTF8String]
#endif
    );
  if (setsockopt(sock,
                 IPPROTO_IP,
                 IP_MULTICAST_IF,
                 (char *)&ipaddr, sizeof(ipaddr)) != 0) {
    perror("setsockopt");
    return;
  }
#endif

  NSLog(@"send packet");
  sendto(sock, "hello", 5, 0, (struct sockaddr *)&addr, sizeof(addr));

  close(sock);
  return;
}

@end

// EOF
