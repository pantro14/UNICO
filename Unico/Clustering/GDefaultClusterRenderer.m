#import <CoreText/CoreText.h>
#import "GDefaultClusterRenderer.h"
#import "GQuadItem.h"
#import "GCluster.h"
#import "CustomMarker.h"
#import "genericComponets.h"

@implementation GDefaultClusterRenderer

- (id)initWithGoogleMap:(GMSMapView*)googleMap {
    if (self = [super init]) {
        map = googleMap;
        markerCache = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)clustersChanged:(NSSet*)clusters {
    for (CustomMarker *marker in markerCache) {
        marker.map = nil;
    }
    [markerCache removeAllObjects];
    for (id <GCluster> cluster in clusters) {
        CustomMarker *marker;
        marker = [[CustomMarker alloc] init];
        [markerCache addObject:marker];
        if ([cluster count] > 1) {
            marker.icon = [self generateClusterIconWithCount:[cluster count]];
            marker.popEnable=NO;
            NSMutableArray* t = [self copyForceNSset:[cluster getItems]];
            marker.data=t;
        }
        else {            
            marker.icon = [UIImage imageNamed:[cluster getImage]];
            marker.popEnable=YES;
            marker.promotion=(ModelPromotion*)[cluster getObjectContainer];
            NSMutableArray* t = [self copyForceNSset:[cluster getItems]];
            marker.data=t;
        }
        marker.cluster=cluster;
        marker.infoWindowAnchor = CGPointMake(0.5, 0.5);
        marker.position = cluster.position;
        
        marker.map = map;
 
    }
}

- (UIImage*) generateClusterIconWithCount:(int)count {
    
    return [UIImage imageNamed:[genericComponets getClusterImage]];
}

#pragma mark - Util

- (NSMutableArray*) copyForceNSset:(NSSet*) set
{
    NSMutableArray* newSet =[[NSMutableArray alloc] init];
    
    for (id  item in set) {
        [newSet addObject:[item getObjectContainer]];
    
    }
    
    return newSet;
}

@end
