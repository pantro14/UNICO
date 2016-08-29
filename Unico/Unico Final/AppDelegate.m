//
//  AppDelegate.m
//  Unico Final
//
//  Created by Datatraffic on 9/23/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "AppDelegate.h"
#import "genericComponets.h"
#import "PromotionsViewController.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "PromotionsViewController.h"

@import CoreLocation;

@interface AppDelegate ()

@end

/*!
 * @brief Implementacion de la clase delegate, sedeclaran las variables de la clase
 */
@implementation AppDelegate
{
    //  Diccionario con la informacion del push
    NSDictionary *userInfoNotification;
    //  Instancia de locationManager para manejar la ubicacion del usuario por GPS
    CLLocationManager* locationManager;
    //  Variable para saber si esta en modo debug el sistema
    BOOL debug;
}

/*!
 * @brief Tells the delegate that the launch process is almost done and the app is almost ready to run.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Inicializacion del location manager
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = kCLDistanceFilterNone; // meters
    
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
    
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    
    // Otros

    debug= [genericComponets getMode];
    
    //SE obtiene el key del mapa del google
    [GMSServices provideAPIKey:[genericComponets getGoogleApiKey]];
    
    //Se inicializa la clase Facebbok
    [FBLoginView class];
    [FBProfilePictureView class];

    //Se inicilizan las preferencias del usuario
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    if(![userDefaults objectForKey:@"id_movil"] )
    {
        [userDefaults setObject:@"0000000" forKey:@"id_movil"];
    }
    
    if(![userDefaults objectForKey:@"token_push"] )
    {
        [userDefaults setObject:@"ERROR TOKEN" forKey:@"token_push"];
    }
    
    if(![userDefaults objectForKey:@"shareApp"] )
    {
        [userDefaults setObject:@"Descarga la aplicación del Centro Comercial Unico Outlet que te trae los mejores descuentos en tu ciudad." forKey:@"shareApp"];
    }
    
    if(![userDefaults objectForKey:@"pushLine"] )
    {
        [userDefaults setObject:@"Gran promoción en el Centro Comercial Unico" forKey:@"pushLine"];
    }
    
    [userDefaults synchronize];
    
    
    //Si el usurio esta logeado se pide al servidor la informacion del usuario
    if([userDefaults boolForKey:@"has_login"])
    {
        NSDictionary * dict2=@{@"function":@"client@show",               @"id_movil":[userDefaults objectForKey:@"id_movil"],               @"token_push":[userDefaults objectForKey:@"token_push"],               @"os":@"ios",               @"latitud":@"0.000",               @"longitud":@"-0.0000"};
        
        [self networkCall:dict2 showLayer:NO];
    }
    
    [self updateShareData];
    
    //Se solicita permiso para enviar push notifications
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |                                        UIUserNotificationTypeBadge |                                        UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes                                                                 categories:nil];
        
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    [self clearNotifications];
    
    //Se revisa si hay notificaciones
    if([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"])
    {
        [self notificationHandler:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    }
    else
    {
        if([userDefaults boolForKey:@"has_login"])
        {
            self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            PromotionsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"promotionList"];
                
            self.window.rootViewController = viewController;
            
            [self.window makeKeyAndVisible];
        }
    }
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

/*!
 * @brief Implementacion de metodo necesario para el uso del API de Facebook
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
              sourceApplication:sourceApplication];
    
}

#pragma mark - Notificaciones

/*!
 * @brief Metodo borrar las notificaciones recibidas
 */
- (void) clearNotifications {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}

/*!
 * @brief Metodo para procesar la notificaciones recibidas
 */
- (void) notificationHandler:(NSDictionary*) notification
{
    
    [self clearNotifications];

    // Se valida si es un push de encuesta o un mensaje normal
    if([[notification objectForKey:@"action"] isEqualToString:@"survey"])
    {
        [self presentSurvey];
    }
    else if([[notification objectForKey:@"action"] isEqualToString:@"message"])
    {
        // Se muestra el mensaje en pantalla
        UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"Información"
                                                        message:[[notification objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [aView show];
    }
    else
    {
        [self showFirstView:[notification objectForKey:@"action"] andNot:notification];
    }
    
}

/*!
 * @brief Tells the delegate that the running app received a remote notification.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if(debug)
        NSLog(@" Notification %@",userInfo);
    
    [self notificationHandler:userInfo];
    
}

/*!
 * @brief Tells the delegate that the app successfully registered with Apple Push Service (APS).
 */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* newToken = [deviceToken description];
    
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    // se saca el token del equipo
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    //  Se guarda en las preferencias
    [userDefaults setObject:newToken forKey:@"token_push"];
    
    [userDefaults  synchronize];

    if(debug)
        NSLog(@"My token is: %@", newToken);
    
}

/*!
 * @briefSent Tell to the delegate when Apple Push Service cannot successfully complete the registration process.
 */
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSUserDefaults *pushToken=[NSUserDefaults standardUserDefaults];
    
    [pushToken setObject:@"ERROR TOKEN" forKey:@"token_push"];
    
    [pushToken  synchronize];
    
    if(debug)
        NSLog(@"Failed to get token, error: %@", error);
    
}

#pragma mark - Metodos Adicionales

/*!
 * @brief Sent Manejador de Notificaciones
 */
-(void)appDelegateNotificationManager:(NSNotification *)notic
{
    // Valida si llego una notificacion valida
    if([userInfoNotification objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"])
    {
        
        [self notificationHandler:userInfoNotification];
        
        NSMutableDictionary *userInfoNotification2=[[userInfoNotification objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] mutableCopy];
        
        [userInfoNotification2 setValue:@"launcher" forKey:@"source"];
        
        [notic.object setText:[ NSString stringWithFormat:@"Desde  %@",userInfoNotification2]];
        
        // Envia un mensaje al sistema con la informaicon de la notificacion
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recibiNotificacion" object:userInfoNotification2];
        
        userInfoNotification=nil;
        
    }
    
}

#pragma mark - Network

/*!
 * @brief Metodo para hacer las llamadas de RED
 * @param dict, diccionario con el json de la peticion
 * @param show, boolean que indica si se debe o no mostrar precarga
 * @return void
 */
-(void) networkCall:(NSDictionary *) dict showLayer:(BOOL) show{
    
    NSError *errorj;
    
    NSString* aStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict
                                                                                    options:NSJSONWritingPrettyPrinted
                                                                                      error:&errorj] encoding:NSUTF8StringEncoding];
    
    if(debug)
    {
        NSLog(@"consulta %@",aStr);
    }
    NSDictionary * final=@{@"information":aStr};
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[genericComponets getRequestUrl]]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@""
                                                      parameters:final ];
    
    [request setTimeoutInterval:60];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *json=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
      // Se verifica que la repsuesta sea un json
        if(json)
        {
            if(debug)
            {
                NSLog(@"Json Resultado Promociones %@",json);
            }
            //se evalua que funcion es la que respondio
            if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@show"])
            {
                if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
                {
                    if(debug)
                    {
                        NSLog(@"Error de actualizacion datos");
                    }
                }
                else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
                {
                    // Se actualzia en las preferencias del usuario los datos que llegan del servicio
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];[userDefaults setObject:[json valueForKey:@"id_movil"] forKey:@"id_movil"];if([[json valueForKey:@"data"] valueForKey:@"email"])    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"email"] forKey:@"email"];    }else    {        [userDefaults setObject:@"" forKey:@"email"];    }if([[json valueForKey:@"data"] valueForKey:@"name"])    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"name"] forKey:@"name"];    }else    {        [userDefaults setObject:@"" forKey:@"name"];    }if([[json valueForKey:@"data"] valueForKey:@"last_name"])    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"last_name"] forKey:@"lastName"];    }else    {        [userDefaults setObject:@"" forKey:@"lastName"];    }if([[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"nreference"])    {        [userDefaults setObject:[[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"nreference"]  forKey:@"city_id"];    }else    {        [userDefaults setObject:@"1" forKey:@"city_id"];    }if([[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"sname"])    {        [userDefaults setObject:[[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"sname"]  forKey:@"city_name"];    }else    {        [userDefaults setObject:@"CALI" forKey:@"city_name"];    }if([[json valueForKey:@"data"] valueForKey:@"usertype"] )    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"usertype"]  forKey:@"usertype"];    }else    {        [userDefaults setObject:@"normal" forKey:@"usertype"];    }if([[json valueForKey:@"data"] valueForKey:@"points"] )    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"points"]  forKey:@"points"];    }else    {        [userDefaults setObject:@"0" forKey:@"points"];    }if([[json valueForKey:@"data"] valueForKey:@"categories"] )    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"categories"]  forKey:@"categories"];    }else    {        [userDefaults setObject:@{} forKey:@"categories"];    }[userDefaults synchronize];
                    
                    
                    // Se valida si hay un evento cercano para redirigir al usuario a la seccion de eventos
                    if([[json valueForKey:@"data"] valueForKey:@"show_events"] && [[[json valueForKey:@"data"] valueForKey:@"show_events"] intValue]==1)                      {
                            if(debug)
                            {
                                NSLog(@"Ingreso a eventos");
                            }
                        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        PromotionsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"promotionList"];
                        
                       
                        [viewController setTypeofView:@"events"];
                        
                        self.window.rootViewController = viewController;
                        
                        [self.window makeKeyAndVisible];
                    }
                }
            }
        }
        else
        {
            if(debug)
            {
                NSLog(@"Plano %@",[operation responseString]);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Si ocurre un error se imprime en cosola
        if(debug){
            NSLog(@"Error: %@", error);
        }
        //[self alertscreen:@"Error" :[genericComponets getErrorMessage]];
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    [operation start];
    //[queue addOperation:operation];
}

/*!
 * @brief Metodo para hacer las llamadas asincronas de RED
 * @param dict2, diccionario con el json de la peticion
 * @return void
 */
- (void) asynchroRequest:(NSDictionary *)dict2
{
    NSOperationQueue *queue =[[NSOperationQueue alloc]init];
    NSURL *url=[NSURL URLWithString:[genericComponets getRequestUrl]];
    
    NSError *errorj;
    
    NSString* aStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict2                                                                    options:NSJSONWritingPrettyPrinted                                                                      error:&errorj] encoding:NSUTF8StringEncoding];
    
    NSString * final=[NSString stringWithFormat:@"information=%@",aStr];
    
    if(debug)
    {
        NSLog(@"Peticion  %@",final);
    }
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[final dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Se valida que no alla error en la peticion
        if(!connectionError)
        {
            NSError *error;
            NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if(debug)
            {
                NSLog(@"Login Ok %@",json);
            }
            //Se valida que funcion fue llamada
            if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@show"])
            {
                if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
                {
                    if(debug)
                    {
                        NSLog(@"Error de actualizacion datos");
                    }
                }
                else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
                {
                    // Se actualzia la informaicon del usuario en las preferencias
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];[userDefaults setObject:[json valueForKey:@"id_movil"] forKey:@"id_movil"];if([[json valueForKey:@"data"] valueForKey:@"email"])    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"email"] forKey:@"email"];    }else    {        [userDefaults setObject:@"" forKey:@"email"];    }if([[json valueForKey:@"data"] valueForKey:@"name"])    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"name"] forKey:@"name"];    }else    {        [userDefaults setObject:@"" forKey:@"name"];    }if([[json valueForKey:@"data"] valueForKey:@"last_name"])    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"last_name"] forKey:@"lastName"];    }else    {        [userDefaults setObject:@"" forKey:@"lastName"];    }if([[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"nreference"])    {        [userDefaults setObject:[[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"nreference"]  forKey:@"city_id"];    }else    {        [userDefaults setObject:@"1" forKey:@"city_id"];    }if([[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"sname"])    {        [userDefaults setObject:[[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"sname"]  forKey:@"city_name"];    }else    {        [userDefaults setObject:@"CALI" forKey:@"city_name"];    }if([[json valueForKey:@"data"] valueForKey:@"usertype"] )    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"usertype"]  forKey:@"usertype"];    }else    {        [userDefaults setObject:@"normal" forKey:@"usertype"];    }if([[json valueForKey:@"data"] valueForKey:@"points"] )    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"points"]  forKey:@"points"];    }else    {        [userDefaults setObject:@"0" forKey:@"points"];    }if([[json valueForKey:@"data"] valueForKey:@"categories"] )    {        [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"categories"]  forKey:@"categories"];    }else    {        [userDefaults setObject:@{} forKey:@"categories"];    }[userDefaults synchronize];
                    
                    
                }
                
            }
            else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"experiencePoll@storeMovil"])
            {
                // Se valida que se alla guardado la informaicon de la encuesta.
                if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
                {
                    if(debug)
                    {
                        NSLog(@"Error de actualizacion datos");
                    }
                }
                else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
                {
                    if(debug)
                    {
                        NSLog(@"Guardado exitoso");
                    }
                }
            }
            else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"content@index"])
            {
                if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
                {
                    if(debug)
                    {
                        NSLog(@"Error de actualizacion datos");
                    }
                }
                else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
                {
                    if(debug)
                    {
                        NSLog(@"Guardado exitoso");
                    }
                    
                    NSDictionary *data=[json valueForKey:@"data"];
                    
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    
                    // Se almacenan las constantes del sistema en las preferencias del usuario
                    for(NSDictionary* d in data)
                    {
                        if([[d objectForKey:@"stag"] isEqualToString:@"#PUSHLINE"])
                        {
                            [userDefaults setObject:[d objectForKey:@"stagcontent"] forKey:@"pushLine"];
                        }
                        
                        if([[d objectForKey:@"stag"] isEqualToString:@"#COMPARTIRAPP"])
                        {
                            [userDefaults setObject:[d objectForKey:@"stagcontent"] forKey:@"shareApp"];
                        }
                    }
                }
            }
        }
        
    }];
    
}

# pragma mark-Delegate Alert

/*!
 * @brief Metodo Se presenta al usuario la encuesta de experiencia
 * @return void
 */
-(void)presentSurvey
{
    UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"Encuesta"
                                                    message:@"¿Qué te pareció tu experiencia en C.C. Unico Outlet?"
                                                   delegate:self
                                          cancelButtonTitle:@"Mala"
                                          otherButtonTitles:@"Buena", nil];
    [aView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    NSString* good=@"0";
    
    if([title isEqualToString:@"Buena"])
    {
        good=@"1";
    }
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * dict2=@{@"function":@"experiencePoll@storeMovil",
                           @"id_movil":[userDefaults objectForKey:@"id_movil"],
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"os":@"ios",
                           @"isgood":good};
    
    [self asynchroRequest:dict2];
    
}

/*!
 * @brief Metodo reenvia al usuario a un oferta o evento especifico cunado llega uan notificaion de ese tipo
 * @param action, accion recibida desde la notificacion
 * @param Not, Diccionario con la informacion detallada del evento o oferta
 * @return void
 */
- (void) showFirstView: (NSString*) action andNot: (NSDictionary*) dict
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    // Se verifica que el usuario este logeado
    if([userDefaults boolForKey:@"has_login"])
    {
        
        if([[UIApplication sharedApplication] applicationState]==1)
        {
            self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"promotionList"];
            
            // se valida si es debe msotrar uan oferta o un evento
            if([action isEqualToString:@"show@offer"])
            {
                [(PromotionsViewController*) viewController setTypeofView:@"promotions"];
                [(PromotionsViewController*) viewController setOffer:[dict objectForKey:@"offer"]];
            }
            else if([action isEqualToString:@"show@event"])
            {
                [(PromotionsViewController*) viewController setTypeofView:@"events"];
                [(PromotionsViewController*) viewController setOffer:[dict objectForKey:@"event"]];
            }
            
            self.window.rootViewController = viewController;
            
            [self.window makeKeyAndVisible];
            
        }
        else
        {
            UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"Información"
                                                            message:[[dict objectForKey:@"aps"] objectForKey:@"alert"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [aView show];
        }
        
    }
    
}

/*!
 * @brief Metodo para solicitar al servidor los pushlines del sistema
 * @return void
 */
-(void) updateShareData
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * dict2= @{@"function":@"content@index",
                            @"id_movil":[userDefaults objectForKey:@"id_movil"],
                            @"token_push":[userDefaults objectForKey:@"token_push"],
                            @"os":@"ios",
                            @"limit":@"1",
                            @"page":@"1",
                            @"sort":@{@"property":@"nreference", @"direction":@"ASC"},
                            @"filter":@[@{@"field":@"stag", @"value":@"#COMPARTIRAPP", @"type":@"string", @"compare":@"0"}]
                            };
    
    [self asynchroRequest:dict2];
    
    dict2=@{@"function":@"content@index",
            @"id_movil":[userDefaults objectForKey:@"id_movil"],
            @"token_push":[userDefaults objectForKey:@"token_push"],
            @"os":@"ios",
            @"limit":@"1",
            @"page":@"1",
            @"sort":@{@"property":@"nreference", @"direction":@"ASC"},
            @"filter":@[@{@"field":@"stag", @"value":@"#PUSHLINE", @"type":@"string", @"compare":@"0"}]
            };
    
    [self asynchroRequest:dict2];
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        //latitude=location.coordinate.latitude;
        //longitude=location.coordinate.longitude;
        // If the event is recent, do something with it.
       
        if(debug)
        {
            NSLog(@" UBICACION latitude %+.6f, longitude %+.6f\n",location.coordinate.latitude,location.coordinate.longitude);
        }
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        // Se manda al servidor la ubicaicon donde el usuario abrio la aplicacion para el envio de la encuesta.
        NSDictionary *dict2=@{@"function":@"client@sendPoll",
                @"id_movil":[userDefaults objectForKey:@"id_movil"],
                @"token_push":[userDefaults objectForKey:@"token_push"],
                @"os":@"ios",
                @"x":[NSString stringWithFormat:@"%f",location.coordinate.longitude],
                @"y":[NSString stringWithFormat:@"%f",location.coordinate.latitude]
                };
        
        [self asynchroRequest:dict2];
        
        // Se detiene el location manager
        [locationManager stopUpdatingLocation];
    }
    
}


@end

