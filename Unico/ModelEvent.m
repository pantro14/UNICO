//
//  ModelEvent.m
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "ModelEvent.h"

@implementation ModelEvent

// Inicializacion rapida de GET y SET
@synthesize eventId,eventName,eventDescription,eventImage,eventLikes,swipe,startDate,endDate,liked,promotionsName;

-(id) init
{
    swipe=NO;
    liked=NO;
    
    return self;
}

/*!
 * @brief Metodo para crear un evento desde un json
 * @param json, Json para crear un nuevo objeto tipo evento
 * @return void
 */
- (void) populateWithJson:(NSDictionary *)dictionary{
    
    eventName=[dictionary objectForKey:@"sname"];
    eventId =[[dictionary objectForKey:@"nreference"] integerValue];
    eventImage=[dictionary objectForKey:@"simage"];
    eventDescription=[dictionary objectForKey:@"sdescriptionios"];
    eventLikes=[[dictionary objectForKey:@"nlikes"]  integerValue];
    startDate=[dictionary objectForKey:@"tstart"];
    endDate=[dictionary objectForKey:@"tend"];
    promotionsName = [[NSMutableArray alloc] init];
    
    for( NSDictionary* d in [dictionary objectForKey:@"offers"])
    {
        [promotionsName addObject:[NSString stringWithFormat:@"%@ - %@",[d objectForKey:@"stitle"],[d objectForKey:@"soffertypedetails"]]];
    }
}

@end
