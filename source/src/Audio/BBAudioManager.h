//
//  BBAudioManager.h
//  New Focus
//
//  Created by Alex Wiltschko on 7/4/12.
//  Copyright (c) 2012 Datta Lab, Harvard University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Novocaine.h"
#import "RingBuffer.h"
#import "BBAudioFileWriter.h"
#import "BBAudioFileReader.h"
#import "DSPThreshold.h"
#import "DSPAnalysis.h"
#import "NVDSP.h"
#import "NVHighpassFilter.h"
#import "NVLowpassFilter.h"
#import "NVNotchFilter.h"

#define RESETUP_SCREEN_NOTIFICATION @"resetupScreenNotification"
#define FILTER_PARAMETERS_CHANGED @"filterParametersChanged"
#define MAX_NUMBER_OF_FFT_SEC 6.0f

@class BBFile;


@interface BBAudioManager : NSObject
{

    
    UInt32 numPointsToSavePerThreshold;
    UInt32 numTriggersInThresholdHistory;

    
    BOOL recording;
    BOOL stimulating;
    BOOL thresholding;
    BOOL selecting;
    BOOL playing;
    
    //Filtering
    NVHighpassFilter * HPFilter;
    NVLowpassFilter * LPFilter;
    NVNotchFilter * NotchFilter;
    BOOL notchIsOn;
}

@property (getter=samplingRate, readonly) float samplingRate;
@property (getter=numberOfChannels, readonly) int numberOfChannels;

@property (getter=sourceSamplingRate, readonly) float sourceSamplingRate;
@property (getter=sourceNumberOfChannels, readonly) int sourceNumberOfChannels;

@property UInt32 numTriggersInThresholdHistory;

@property float threshold;
@property BBThresholdType thresholdDirection;

@property (readonly) float rmsOfSelection;

@property float currentFileTime;
@property (readonly) float fileDuration;


//Basic stats properties
@property float currSTD;
@property float currMax;
@property float currMin;
@property float currMean;

//States of manager
@property (readonly) BOOL recording;
@property BOOL stimulating;
@property (readonly) BOOL thresholding;
@property (readonly) BOOL selecting;
@property (readonly) BOOL playing;
@property (readonly) BOOL btOn;
@property (readonly) BOOL FFTOn;
@property (readonly) BOOL ECGOn;
@property (readonly) BOOL rtSpikeSorting;
@property BOOL seeking;




+ (BBAudioManager *) bbAudioManager;
-(void) quitAllFunctions;
- (void)startMonitoring;

- (void)startRecording:(NSURL *)urlToFile;
- (void)stopRecording;
- (void)startThresholding:(UInt32)newNumPointsToSavePerThreshold;
- (void)stopThresholding;
- (void)startPlaying:(BBFile *) fileToPlay;
- (void)stopPlaying;
- (void)pausePlaying;
- (void)resumePlaying;
- (float)fetchAudio:(float *)data numFrames:(UInt32)numFrames whichChannel:(UInt32)whichChannel stride:(UInt32)stride;
- (float)fetchAudioForSelectedChannel:(float *)data numFrames:(UInt32)numFrames stride:(UInt32)stride;
- (NSMutableArray *) getChannels;

//Selection
-(void) endSelection;
-(void) updateSelection:(float) newSelectionTime timeSpan:(float) timeSpan;
- (float) selectionStartTime;
- (float) selectionEndTime;
- (NSMutableArray *) spikesCount;

-(NSMutableArray *) getSpikes;
-(float) getTimeForSpikes;
- (void)saveSettingsToUserDefaults;
-(void) clearWaveform;

//Bluetooth
-(void) switchToBluetoothWithChannels:(int) channelConfiguration andSampleRate:(int) inSampleRate;
-(void) closeBluetooth;
-(void) selectChannel:(int) selectedChannel;
-(int) numberOfFramesBuffered;

//FFT
-(float **) getDynamicFFTResult;
-(UInt32) lengthOfFFTData;
-(UInt32) lengthOf30HzData;
-(void) stopFFT;
-(void) startDynanimcFFT;
-(UInt32) indexOfFFTGraphBuffer;
-(UInt32) lenghtOfFFTGraphBuffer;


//RT Spike Sorting
-(void) startRTSpikeSorting;
-(void) stopRTSpikeSorting;
-(float *) rtSpikeValues;
-(float *) rtSpikeIndexes;
-(int) numberOfRTSpikes;
@property float rtThresholdFirst;
@property float rtThresholdSecond;

//ECG
-(void) startECG;
-(void) stopECG;
@property (readonly) float heartRate;
@property (readonly) BOOL heartBeatPresent;
@property (nonatomic) float ecgThreshold;

@end
