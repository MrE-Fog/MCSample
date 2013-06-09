//
//  ViewController.m
//  MCSample
//
//  Created by MIYOKAWA, Nobuyoshi on 2013/06/08.
//

#import "ViewController.h"

#import "MCClient.h"
#import "MCServerOperation.h"
#import "NetworkUtils.h"

@interface ViewController ()

@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) MCServerOperation *serverOperation;

@end

@implementation ViewController

#pragma mark -

- (NSOperationQueue *)queue
{
  if (_queue) {
    return _queue;
  }
  _queue = [NSOperationQueue new];
  return _queue;
}

- (MCServerOperation *)serverOperation
{
  if (_serverOperation) {
    return _serverOperation;
  }
  _serverOperation = [MCServerOperation new];
  return _serverOperation;
}

#pragma mark - 

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
  MCClient *mc = [MCClient new];
  [NetworkUtils showNetworkInterfacesFromKernel];
  [NetworkUtils showNetworkInterfacesOnCN];

  [self.queue addOperation:self.serverOperation];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
                 dispatch_get_main_queue(), ^{
    [mc sendPacket];
  });
}

@end

// EOF
