//
//  ToneGenerator.h
//  Vibro
//
//  Created by Shubham Mandal on 7/15/19.
//  Copyright © 2019 Shubham Mandal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ToneGenerator : NSObject
{
    AudioComponentInstance toneUnit;
    
@public
    
    double sampleRate;
    double theta;
}

@property (nonatomic, assign) double frequency;
- (void)togglePlay:(BOOL)shouldPlay;

@end

NS_ASSUME_NONNULL_END
