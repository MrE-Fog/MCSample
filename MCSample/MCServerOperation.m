//
//  MCServerOperation.m
//  MCSample
//
//  Created by MIYOKAWA, Nobuyoshi on 2013/06/08.
//

#import "MCServerOperation.h"

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#import "NetworkUtils.h"

@implementation MCServerOperation

- (void)main
{
  struct sockaddr_in addr;

  int sock = socket(AF_INET, SOCK_DGRAM, 0);
  addr.sin_family = AF_INET;
  addr.sin_port = htons(MCPORT);
#if defined(BIND_ACCEPT_INADDR)
  addr.sin_addr.s_addr = INADDR_ANY;
#else
 addr.sin_addr.s_addr = inet_addr(MCADDRESS);
#endif
  addr.sin_len = sizeof(addr);
  bind(sock, (struct sockaddr *)&addr, sizeof(addr));

  struct ip_mreq mreq;
  memset(&mreq, 0, sizeof(mreq));
  mreq.imr_interface.s_addr =
#if defined(BIND_ACCEPT_MULTICAST_IF_LO0)
    inet_addr([[NetworkUtils lo0IPAddress] UTF8String])
#elif defined(BIND_ACCEPT_MULTICAST_IF_EN0)
    inet_addr([[NetworkUtils en0IPAddress] UTF8String])
#else
    INADDR_ANY
#endif
  ;
  mreq.imr_multiaddr.s_addr = inet_addr(MCADDRESS);

  if (setsockopt(sock,
                 IPPROTO_IP,
                 IP_ADD_MEMBERSHIP,
                 (char *)&mreq, sizeof(mreq)) != 0) {
    perror("setsockopt");
    return;
  }

  char buf[BUFSIZ];
  NSLog(@"packet waiting...");
  while (1) {
    ssize_t len = 0;
    struct sockaddr_in from;
    socklen_t fromlen = sizeof(from);

    memset(buf, 0, sizeof(buf));
		len = recvfrom(sock, buf, sizeof(buf), 0,
                   (struct sockaddr *)&from, &fromlen);
		buf[len] = 0;
		NSLog(@"recv: %s:%d: '%s'",
          inet_ntoa(from.sin_addr), ntohs(from.sin_port), buf);
  }

  close(sock);
}

@end

// EOF
