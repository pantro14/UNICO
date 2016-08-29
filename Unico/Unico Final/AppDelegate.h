//
//  AppDelegate.h
//  Unico Final
//
//  Created by Datatraffic on 9/23/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//  Delegate principal de la aplicacion
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void) updateShareData;

@end

