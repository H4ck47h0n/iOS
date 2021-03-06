//
//  ChatViewController.m
//  AgoraDemo
//
//  Created by Remi Robert on 21/05/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "ChatViewController.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "crasheye.h"

@interface ChatViewController () <AgoraRtcEngineDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelCountUuid;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *venderKey;
@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) NSMutableSet<NSNumber *> *uuids;
@end

@implementation ChatViewController

- (IBAction)closeChatController:(id)sender {
    self.labelStatus.text = @"leaving chat ...";
    [self.agoraKit leaveChannel:^(AgoraRtcStats *stat) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraRtcErrorCode)errorCode {
    NSLog(@"get error : %ld", (long)errorCode);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self.uuids addObject:@(uid)];
    self.labelCountUuid.text = [NSString stringWithFormat:@"%ld", self.uuids.count];
}
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraRtcUserOfflineReason)reason {
    [self.uuids removeObject:@(uid)];
    self.labelCountUuid.text = [NSString stringWithFormat:@"%ld", self.uuids.count];
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit *)engine {
    self.labelStatus.text = @"connection lost";
}

- (void)initAgoraKit {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithVendorKey:self.venderKey delegate:self];
    
    [self.agoraKit disableVideo];
    [self.agoraKit setEnableSpeakerphone:true];
    
    [self.agoraKit joinChannelByKey:nil channelName:self.channel info:nil uid:0
                        joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
                            [self.uuids addObject:@(uid)];
                            self.labelStatus.text = [NSString stringWithFormat:@"join channel success: [%@], %ld %ld", channel, uid, (long)elapsed];
                            NSLog(@"joined channel : %@ / %lu / %ld", channel, (unsigned long)uid, (long)elapsed);
                        }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initAgoraKit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uuids = [NSMutableSet new];
    self.channel = @"401";
    self.venderKey = @"92ba4a35a6834810ba022f6bd76dc589";
}

@end
