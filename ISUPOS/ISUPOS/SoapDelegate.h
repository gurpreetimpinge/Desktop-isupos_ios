/*
 SoapDelegate.h
 Interfaces for the SoapDelegate protocol.
 Author:	Jason Kichline, andCulture - Harrisburg, Pennsylvania USA
 */

#import "SoapFault.h"

@protocol SoapDelegate <NSObject>


@optional
- (void) onload: (id) value;
- (void) onerror: (NSError*) error;
- (void) onfault: (SoapFault*) fault;

@end