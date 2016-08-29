//
//  ModelRouting.m
//  Unico Final
//
//  Created by Francisco Garcia on 11/4/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "ModelRouting.h"

@implementation ModelRouting

// Inicializacion de los Metodos GET y SET
@synthesize order,floor,geometry,sLatitude,sLongitude,sType,eLatitude,eLongitude,eType;


/*!
 * @brief Metodo para crear una ruta desde Json
 * @param dictionary, Json con la informacion de la Ruta
 * @return void
 */
- (void) populateWithJson:(NSDictionary *)dictionary{
    
    order=[[dictionary objectForKey:@"order"] intValue];
    floor=[[dictionary objectForKey:@"floor"] intValue];
    if([dictionary objectForKey:@"geometry"]!=[NSNull null])
    {
        geometry=[dictionary objectForKey:@"geometry"];
        geometry=[geometry stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    }
    else
    {
        geometry=@"";
    }
    sLatitude=[[[dictionary objectForKey:@"starPoint"] objectForKey:@"y"] floatValue];
    sLongitude=[[[dictionary objectForKey:@"starPoint"] objectForKey:@"x"] floatValue];
    if([[dictionary objectForKey:@"starPoint"] objectForKey:@"type"]!=[NSNull null])
    {
        sType=[[dictionary objectForKey:@"starPoint"] objectForKey:@"type"];
    }
    else
    {
        sType=@"";
    }
    
    eLatitude=[[[dictionary objectForKey:@"endPoint"] objectForKey:@"y"] floatValue];
    eLongitude=[[[dictionary objectForKey:@"endPoint"] objectForKey:@"x"] floatValue];
    
    if([[dictionary objectForKey:@"endPoint"] objectForKey:@"type"]!=[NSNull null])
    {
        eType=[[dictionary objectForKey:@"endPoint"] objectForKey:@"type"];
    }
    else
    {
        eType=@"";
    }
    
    
}

/*!
 * @brief Metodo para crear una ruta por parametros
 * @param Datos de una ruta
 * @return void
 */
- (void) populateWithOrder:(int)nOrder floor:(int) nfloor geometry:(NSString*)nGeometry sLatitude:(float)nsLatitude sLongitude:(float) nsLongitude sType:(NSString*)nsType eLatitude:(float)neLatitude eLongitude:(float)neLongitude eType:(NSString*)neType
{
    order=nOrder;
    floor=nfloor;
    geometry=nGeometry;
    sLatitude=nsLatitude;
    sLongitude=nsLongitude;
    sType=nsType;
    eLatitude=neLatitude;
    eLongitude=neLongitude;
    eType=neType;
}

/*!
 * @brief Metodo que indica si la ruta es el punto inicial de uan ruta total
 * @return BOOL, si es punto de inicio
 */
- (BOOL) iamStratPoint
{
    if([sType isEqualToString:@"START"] || [eType isEqualToString:@"START"])
    {
        return YES;
    }
    
    return NO;
}

@end
