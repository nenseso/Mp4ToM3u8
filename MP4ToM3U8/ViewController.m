//
//  ViewController.m
//  MP4ToM3U8
//
//  Created by zhouzihao on 2024/5/17.
//

#import "ViewController.h"
#include <ffmpegkit/FFmpegKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (IBAction)start:(id)sender {
    NSString *inputPath = [[NSBundle mainBundle] pathForResource:@"input" ofType:@"mp4"];
    NSString *outputPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"m3u8Path"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:outputPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *cmd = [NSString stringWithFormat:@"-i %@ -codec: copy -bsf:v h264_mp4toannexb -map 0 -f segment -segment_list %@/playlist.m3u8 -segment_time 10 %@/output%%03d.ts", inputPath, outputPath,outputPath];
//    NSLog(@"cmd: %@",cmd);
    FFmpegSession* session = [FFmpegKit executeAsync:cmd withCompleteCallback:^(FFmpegSession* session) {
        SessionState state = [session getState];
        ReturnCode *returnCode = [session getReturnCode];

        // CALLED WHEN SESSION IS EXECUTED

        NSLog(@"FFmpeg process exited with state %@ and rc %@.%@", [FFmpegKitConfig sessionStateToString:state], returnCode, [session getFailStackTrace]);

    } withLogCallback:^(Log *log) {

        // CALLED WHEN SESSION PRINTS LOGS
        NSLog(@"%@",[log getMessage]);

    } withStatisticsCallback:^(Statistics *statistics) {

        // CALLED WHEN SESSION GENERATES STATISTICS

    }];
}


@end
