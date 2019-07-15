//
//  ViewController.h
//  Vibro
//
//  Created by Shubham Mandal on 7/15/19.
//  Copyright © 2019 Shubham Mandal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FFTCalculator.h"
#import "ToneGenerator.h"

@interface ViewController : UIViewController {
    FFTCalculator *fftCalculator;
}
@property (nonatomic, strong) ToneGenerator *toneController;


@end

