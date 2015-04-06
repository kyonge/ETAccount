//
//  MKMapView+ZoomLevel.h
//  PopOp
//
//  Created by 기용 이 on 2015. 3. 6..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
