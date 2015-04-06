//
//  MapTileOverlay.m
//  PopOp
//
//  Created by 기용 이 on 2015. 3. 13..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#import "MapTileOverlay.h"

@implementation MapTileOverlay

@synthesize boundingMapRect;
@synthesize coordinate;

- (id)init
{
    self = [super init];
    if(self) {
        boundingMapRect = MKMapRectWorld;
        coordinate = MKCoordinateForMapPoint(MKMapPointMake(boundingMapRect.origin.x + boundingMapRect.size.width / 2, boundingMapRect.origin.y + boundingMapRect.size.height / 2));
    }
    return self;
}

@end


@implementation MapTileOverlayView

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
    if (!MKMapRectIntersectsRect([self.overlay boundingMapRect], mapRect)) {
        return;
    }
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);  //check docs for other blend modes
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);  //use whatever color to mute the beige
    CGContextFillRect(context, [self rectForMapRect:mapRect]);
}

@end


@implementation MapViewDelegate

- (MKOverlayView *)mapView:(MKMapView*)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MapTileOverlay class]]) {
        return [[MapTileOverlayView alloc] initWithOverlay:overlay];
    }
    return nil;
}

@end
