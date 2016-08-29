#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GClusterItem <NSObject>

- (CLLocationCoordinate2D)position;

- (NSString*) image;

- (void) setImageName:(NSString*)image;

- (NSString*) getImage;

- (id) getObjectContainer;


@end
