//
//  genericComponets.h
//  Unico Final
//
//  Created by Francisco Garcia on 10/20/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Clase donde se manejan todas las constantes del sistema
//

#import <Foundation/Foundation.h>

@interface genericComponets : NSObject


+ (NSString *) getRequestUrl;
+ (NSString *) getDefaultImagePromotion;
+ (NSString *) getErrorMessage;
+ (NSString *) md5:(NSString *) input;
+ (BOOL) getMode;
+ (NSString *) getStoresPerLoad;
+ (NSString *) getPromotionsPerLoad;
+ (NSArray *) getCitiesArray;
+ (NSArray *) getGenderArray;
+ (NSArray *) getTypeOfferArray;
+ (NSString *) fixTypeOffer:(NSString *) inTypeOffer;
+ (NSArray *) getCategoriesArray;
+ (NSString *) fixCategories:(NSString *) inCategory;
+ (NSString *) fixCity:(NSString *) inCity;
+ (NSString *) fixGender:(NSString *) inGender;
+ (NSString *) fixBirthday:(NSString *) inBirthday;
+ (NSString *) fixGenderFB:(NSString *) inGender;
+ (NSPredicate*) emailValidator;
+ (NSPredicate*) passwordValidator;
+(NSString*) shareURL;
+(NSString*) getItunesLink;
+ (NSString *) getClusterImage;
+ (NSString *) getNumberPromotionsMap;
+ (NSString *) getGoogleApiKey;
+ (NSMutableArray*) getMapCoordinatesByCity:(int)cityId andFloor:(int) nFloor;
+(NSString *) getMapRoutingIconByType:(NSString *) type;
+ (NSString *) getMapImageByCity:(int) cityId andFloor:(int) floor;
+ (NSString *) getMapImageByCategory:(int) category andType:(int) type;
+ (NSString *) advertisingIdentifier;

@end
