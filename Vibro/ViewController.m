//
//  ViewController.m
//  Vibro
//
//  Created by Shubham Mandal on 7/15/19.
//  Copyright © 2019 Shubham Mandal. All rights reserved.
//

#import "ViewController.h"
#import "Vibro-Swift.h"
#import <Charts/Charts-Swift.h>

@interface ViewController ()<ChartViewDelegate> {
    int time;
}

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@end

@implementation ViewController

- (IBAction)startUpdates:(id)sender {
    if (![fftCalculator isSupported]) {
        return NSLog(@"Error: FFTCalculator not supported due to device restrictions - Please run this project on the device to use the CoreMotion sensor.");
    }
    
    _toneController.frequency = 200;
    [_toneController togglePlay:YES];
    __weak typeof(self) weakself = self;
    [fftCalculator startUpdatesWithCalculationHandler:^(NSArray<NSNumber *> * _Nullable values, float mean, NSError * _Nullable error) {
        NSLog(@"\nFourier values: %@", values);
        NSLog(@"Fourier mean-value: %f", mean);
        double freq = mean * 1000;
        freq = freq < 200 ? 200 : freq;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.toneController.frequency = freq;

            [weakself setDataCountRange:mean * 1000];
        });
    }];
}

- (IBAction)stopUpdates:(id)sender {
    [fftCalculator stopUpdates];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    time = 0;
    [self initCharts];
    _toneController = [[ToneGenerator alloc] init];
    fftCalculator = [[FFTCalculator alloc] initWithFrameSize: 50];
    //    [fftCalculator setDebugEnabled:YES];
}

- (void)initCharts {
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.highlightPerDragEnabled = YES;
    
    _chartView.backgroundColor = UIColor.whiteColor;
    
    _chartView.legend.enabled = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionTopInside;
    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.f];
    xAxis.labelTextColor = [UIColor redColor];
    xAxis.drawAxisLineEnabled = NO;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.centerAxisLabelsEnabled = YES;
    xAxis.granularity = 3600.0;
    //xAxis.valueFormatter = [[DateValueFormatter alloc] init];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionInsideChart;
    leftAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    leftAxis.labelTextColor = [UIColor redColor];
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.granularityEnabled = YES;
    leftAxis.axisMinimum = 0.0;
    leftAxis.axisMaximum = 10000.0;
    leftAxis.yOffset = -9.0;
    leftAxis.labelTextColor = [UIColor redColor];
    
    _chartView.rightAxis.enabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
}



- (void)setDataCountRange:(double)range
{
    double delayInSeconds = 0.1;
    
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        time ++;
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:time y:range];
        [set1 addEntry:entry];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:time y:range];
        set1 = [[LineChartDataSet alloc] initWithEntries:@[entry] label:@"DataSet 1"];
        set1.axisDependency = AxisDependencyLeft;
        set1.valueTextColor = [UIColor redColor];
        set1.lineWidth = 1.5;
        set1.drawCirclesEnabled = NO;
        set1.drawValuesEnabled = NO;
        set1.fillAlpha = 0.26;
        set1.fillColor = [UIColor redColor];
        set1.highlightColor = [UIColor redColor];
        set1.drawCircleHoleEnabled = NO;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.whiteColor];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.0]];
        
        _chartView.data = data;
    }
}

@end
