//
//  ModelPromotion.m
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "ModelPromotion.h"

@implementation ModelPromotion

// Inicializacion rapida de metodos GET y SET
@synthesize promotionId,promotionNames,promotionDescription,promotionImage,promotionLikes,promotionStore,storeId,promotionDiscount,swipe,store,promotionCategory,promotionPriority,liked;

-(id) init
{
    swipe=NO;
    liked=NO;
    
    return self;
}

/*!
 * @brief Crea una promocion desde un json
 * @param json, Json con la informacion de una promocion
 * @return Void
 */
- (void) populateWithJson:(NSDictionary *)dictionary{
    
    promotionNames=[dictionary objectForKey:@"stitle"];
    promotionId =[[dictionary objectForKey:@"nreference"] intValue];
    if([dictionary objectForKey:@"simage"]!=[NSNull null])
    {
        promotionImage=[dictionary objectForKey:@"simage"];
    }
    else
    {
        promotionImage=@"calzadoCAZAOFERTAS@2X.png";
    }
    if([dictionary objectForKey:@"sdescriptionios"]!=[NSNull null])
    {
        promotionDescription=[dictionary objectForKey:@"sdescriptionios"];
    }
    else
    {
        promotionDescription=@"";
    }
    promotionStore=[[dictionary objectForKey:@"store"] objectForKey:@"sname"];
    storeId =[[[dictionary objectForKey:@"store"] objectForKey:@"nreference"] intValue];
    promotionDiscount=[dictionary objectForKey:@"soffertypedetails"];
    promotionLikes=[[dictionary objectForKey:@"nlikes"]  intValue];
    if([dictionary objectForKey:@"category"]!=[NSNull null])
    {
        promotionCategory=[[[dictionary objectForKey:@"category"] objectForKey:@"id_category"]  intValue];
    }
    else
    {
        promotionCategory=-1;
    }
    promotionPriority=[[[dictionary objectForKey:@"offer_priority"] objectForKey:@"id_offer_priority"]  intValue];
    store=nil;
    if([dictionary objectForKey:@"store"]!=[NSNull null])
    {
        store=[[ModelStore alloc] init];
        [store populateWithJson:[dictionary objectForKey:@"store"]];
    }

}

/*!
 * @brief Crear una promocion por parametros
 * @param Datos de la promocion
 * @return Void
 */
- (void) populateWithName:(NSString*)pName discount:(NSString*)pDiscount image:(NSString*)pImage description:(NSString*)pDescription store:(NSString*)pStore likes:(int)pLikes id:(int)pid storeId:(int)pStoreId
{
    promotionNames=pName;
    promotionId =pid;
    promotionLikes=pLikes;
    promotionImage=pImage;
    promotionDescription=pDescription;
    promotionStore=pStore;
    storeId =pStoreId;
    promotionDiscount=pDiscount;
}

/*!
 * @brief Metodo que convierte una promocion a string
 * @return NSString, la promocion como un string
 */
- (NSString *) convertToString
{
    NSString* val= [NSString stringWithFormat:@" Promotion: id %d, name %@, description %@, image %@, likes %d, storename%@, storeid %d, discount %@, swipe %@, store %@, category %d, priority %d ",promotionId,promotionNames,promotionDescription,promotionImage,promotionLikes,promotionStore,storeId,promotionDiscount,(swipe ? @"YES" : @"NO"),[store convertToString],promotionCategory,promotionPriority];
    
    return val;
}

/*!
 * @brief Metodo que retorna la latitud de la promcion.
 * @return Void
 */
- (float) getLatitude
{
    return [store latitude];
}

/*!
 * @brief Metodo que retorna la longitud de la promcion.
 * @return Void
 */
- (float) getLongitude
{
    return [store longitude];
}


@end