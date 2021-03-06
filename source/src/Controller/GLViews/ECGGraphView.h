//
//  ECGGraphView.h
//  Backyard Brains
//
//  Created by Stanislav Mircic on 9/11/14.
//  Copyright (c) 2014 Datta Lab, Harvard University. All rights reserved.
//

#import "CCGLTouchView.h"
#include "cinder/Font.h"
#include "cinder/gl/TextureFont.h"
#include "cinder/Text.h"
#include "cinder/Utilities.h"
@protocol HeartBeatDelegate;
@interface ECGGraphView : CCGLTouchView
{
    CameraOrtho mCam;
    gl::Texture mColorScale;
    Font heartFont;
    Font scaleFont;
    gl::TextureFontRef heartRateFont;
    gl::TextureFontRef mScaleFont;
    gl::TextureFontRef tempHeartRateFont;
    gl::TextureFontRef tempMScaleFont;
    
    PolyLine2f displayVector;

    float samplingRate;

    Vec2f scaleXY;//relationship between pixels and GL world (pixels x scaleXY = GL units)
    
    // Display parameters
    int numSamplesMax;
    int numSamplesMin;
    float numSamplesVisible; //current zoom for every channel x axis
    
    float numVoltsMax;
    float numVoltsMin;
    float numVoltsVisible; //current zoom for every channel y axis

    BOOL firstDrawAfterChannelChange;
    
    BOOL foundBeat;
    
    NSTimeInterval lastUserInteraction;//last time user taped screen
    NSTimeInterval currentUserInteractionTime;//temp variable for calculation
    BOOL handlesShouldBeVisible;
    float offsetPositionOfHandle;
    
    NSTimer * autorangeTimer;
    BOOL autorangeActive;

}

-(void) setupWithBaseFreq:(float) inSamplingRate;
@property (nonatomic, assign) id <HeartBeatDelegate> masterDelegate;

@end

@protocol HeartBeatDelegate <NSObject>
-(void) changeHeartActive:(BOOL) active;

-(void) autorangeSelectedChannel;

@end
