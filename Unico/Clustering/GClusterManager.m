#import "GClusterManager.h"
#import "CustomInfoWindow.h"
#import "CustomMarker.h"
#import "GCluster.h"
#import "genericComponets.h"


@implementation GClusterManager

- (void)setMapView:(GMSMapView*)mapView {
    map = mapView;
}

- (void)setClusterAlgorithm:(id <GClusterAlgorithm>)clusterAlgorithm {
    algorithm = clusterAlgorithm;
}

- (void)setClusterRenderer:(id <GClusterRenderer>)clusterRenderer {
    renderer = clusterRenderer;
}

- (void)addItem:(id <GClusterItem>) item {
    [algorithm addItem:item];
}

- (void)cluster {
    NSSet *clusters = [algorithm getClusters:map.camera.zoom];
    [renderer clustersChanged:clusters];
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    // Don't re-compute clusters if the map has just been panned/tilted/rotated.
    GMSCameraPosition *position = [mapView camera];
    if (previousCameraPosition != nil && previousCameraPosition.zoom == position.zoom) {
        return;
    }
    previousCameraPosition = [mapView camera];
    
    [self cluster];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(CustomMarker *)marker {
    /* don't move map camera to center marker on tap */
    if([marker respondsToSelector:@selector(popEnable)])
    {
        if(marker.popEnable)
        {
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude longitude:marker.position.longitude zoom:mapView.camera.zoom bearing:mapView.camera.bearing viewingAngle:mapView.camera.viewingAngle ];
            [mapView animateToCameraPosition:camera];
        }
        mapView.selectedMarker = marker;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"markerSelecction" object:marker.data];
    }
    return YES;
}

- (void) mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"markerUnSelecction" object:nil];
}


@end
