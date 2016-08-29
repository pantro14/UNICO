//
//  ModelStore.m
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "ModelStore.h"

@implementation ModelStore

/*!
 * @brief Declaracion rapida de metodos GET y SET
 */
@synthesize storeId,storeName,storeDescription,storeImage,storeLikes,idlocal,numlocal,latitude,longitude,floor,StoreCategories,liked;

/*!
 * @brief Metodo de inicializacion de la clase
 */
-(id) init
{
    liked=NO;
    
    return self;
}

/*!
 * @brief Metodo para crear una tienda desde un json.
 */
- (void) populateWithJson:(NSDictionary *)dictionary{
    
    storeName=[dictionary objectForKey:@"sname"];
    storeId =[[dictionary objectForKey:@"nreference"] integerValue];
    storeImage=[dictionary objectForKey:@"simage"];
    if([dictionary objectForKey:@"sdescriptionios"]!=[NSNull null])
    {
        storeDescription=[dictionary objectForKey:@"sdescriptionios"];
    }
    else
    {
        storeDescription=@"";
    }
    storeLikes=[[dictionary objectForKey:@"nlikes"] integerValue];
    idlocal=[[[dictionary objectForKey:@"local"] objectForKey:@"nreference"] integerValue];
    numlocal=[[dictionary objectForKey:@"local"] objectForKey:@"nnumlocal"];
    latitude=[[[dictionary objectForKey:@"local"] objectForKey:@"flatitude"] floatValue];
    longitude=[[[dictionary objectForKey:@"local"] objectForKey:@"flongitude"] floatValue];
    floor=[[[dictionary objectForKey:@"local"] objectForKey:@"floor"] integerValue];
    StoreCategories = [[NSMutableArray alloc] init];
    for (NSDictionary* cate in [dictionary objectForKey:@"categories"])
    {
        [StoreCategories addObject:[cate objectForKey:@"id_category"]];
    }
}

/*!
 * @brief Metodo para convetir a string el objeto
 */
- (NSString *) convertToString
{
    NSString* val=[NSString stringWithFormat:@"Store: id %d, name %@, description %@, image %@, likes %d, idlocal %d, numlocal %@, latitude %f, longitude %f, floor %d, category %@",storeId,storeName,storeDescription,storeImage,storeLikes,idlocal,numlocal,latitude,longitude,floor,StoreCategories];
    
    return val;
}

/*!
 * @brief Metodo para crear una tienda por parametros
 */
- (void) populateWithName:(NSString*)sName image:(NSString*)sImage description:(NSString*)sDescription likes:(int)sLikes id:(int)sid latitude:(float)sLatitude longitude:(float)sLongitude floor:(int)sfloor numlocal:(NSString*)snumlocal{
    storeName=sName;
    storeId=sid;
    storeLikes=sLikes;
    storeImage=sImage;
    storeDescription=sDescription;
    latitude=sLatitude;
    longitude=sLongitude;
    floor=sfloor;
    numlocal=snumlocal;
    
}


@end
