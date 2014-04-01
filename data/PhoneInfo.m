//
//  PhoneInfo.m
//  xocde_test
//
//  Created by GuiQing on 3/31/14.
//  Copyright (c) 2014 GuiQing. All rights reserved.
//

#import "PhoneInfo.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


id CTTelephonyCenterGetDefault(void);
void CTTelephonyCenterAddObserver(id,id,CFNotificationCallback,NSString*,void*,int);
void CTTelephonyCenterRemoveObserver(id,id,NSString*,void*);
NSString *CTCallCopyAddress(void*, CTCall *);
//NSString *CTSettingCopyMyPhoneNumber();
extern NSString* kCTCallIdentificationChangeNotification;






static void telephonyEventCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *notifyname = (__bridge NSString*)name;    // TODO: not necessary if notify name given when addObserver
    if ([notifyname isEqualToString:kCTCallIdentificationChangeNotification])
    {
        NSDictionary* info = (__bridge NSDictionary*)userInfo;
        //CTCall* call = (CTCall*)[[[info objectForKey:@"kCTCall"] stringValue] isEqualToString:@"4"];
        if(observer)
        {
            PhoneInfo* phoneInfo = (__bridge PhoneInfo*)observer;            
            if ([phoneInfo callState]==CTCallStateIncoming)
            {
                CTCall* call = (CTCall *)[info objectForKey:@"kCTCall"];
                NSString* callerNumber = CTCallCopyAddress(NULL, call);
                NSLog(@"Caller number is %@", callerNumber);
            }
        }
        
//         CTCallStateDialing
//         CTCallStateIncoming
//         CTCallStateConnected
//         CTCallStateDisconnected
//
//
//         CTCallDisconnect(call);
//         CTCallAnswer(call);
//         CTCallGetStatus(CTCall *call); // dialing 3, incoming 4, disconnected 5
    }
}





@interface PhoneInfo()
@property (strong, atomic) CTCallCenter* callCenter;
@end



@implementation PhoneInfo

@synthesize callCenter;

- (id) init
{
    self = [super init];
    [self setCallCenter:[[CTCallCenter alloc] init]];
    [self startObservingCalls];
    return self;
}

-(void) dealloc
{
    [self callCenter].callEventHandler = nil;
    CTTelephonyCenterRemoveObserver(CTTelephonyCenterGetDefault(),
                                    self,
                                    kCTCallIdentificationChangeNotification,
                                    NULL);
}

- (void) startObservingCalls
{
    [self callCenter].callEventHandler = ^(CTCall* call)
    {
        [self setCallState:call.callState];
    };
    
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(),   // center
                                 self, // observer
                                 telephonyEventCallback,  // callback
                                 kCTCallIdentificationChangeNotification, // event name (or NULL: all)
                                 NULL,                    // object
                                 CFNotificationSuspensionBehaviorDeliverImmediately); 
}

@end
