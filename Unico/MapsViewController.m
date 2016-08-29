//
//  MapsViewController.m
//  Unico Final
//
//  Created by Francisco Garcia on 11/3/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "MapsViewController.h"
@import CoreLocation;
#import "Spot.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "GDefaultClusterRenderer.h"
#import "genericComponets.h"
#import "MenuViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "ModelPromotion.h"
#import "ModelStore.h"
#import "CustomInfoWindow.h"
#import "PromotionDetailViewController.h"
#import "CategoryViewController.h"
#import "SearchRouteViewController.h"
#import "SliderViewController.h"
#import "ModelRouting.h"

@interface MapsViewController ()

@end

@implementation MapsViewController
{
    //Modo de los datos
    BOOL debug;
    // bounds de la ruta resultante
    GMSCoordinateBounds *overlayBounds;
    // coordanadas de la ubiacion del centro comercial
    CLLocationCoordinate2D newark;
    // Cola de peticiones
    NSOperationQueue *queue;
    //Arreglo de tiendas de las promociones
    NSMutableDictionary* storeReference;
    // Arreglo con el filtro por actegorias
    NSMutableArray *categoriesFilter;
    // Piso actual
    int floorV;
    // Rutas cradas
    NSMutableArray *routing;
    // Geometria de las rutas en el mapa
    NSMutableArray *polylinesMap;
    CLLocationManager* locationManager;
    // latitud del usuario
    float latitude;
    // Longitud del usuario
    float longitude;
    // Variable que indica que debe hacer ruteo automatico (como llegar)
    BOOL autoRouting;
    // Tienda del como llegar
    ModelStore* autoStore;
    
}

- (void)viewDidLoad {
    
    latitude=0.0;
    longitude=0.0;
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = kCLDistanceFilterNone; // meters
    
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
    
    [super viewDidLoad];
    debug=[genericComponets getMode];
    floorV=1;
    queue=[[NSOperationQueue alloc]init];
    storeReference= [[NSMutableDictionary alloc] init];
    routing= [[NSMutableArray alloc]init];
    polylinesMap= [[NSMutableArray alloc]init];
    categoriesFilter = [[NSMutableArray alloc] init];
    [categoriesFilter insertObject:@"NO" atIndex:0];
    [categoriesFilter insertObject:@"NO" atIndex:1];
    [categoriesFilter insertObject:@"NO" atIndex:2];
    [categoriesFilter insertObject:@"NO" atIndex:3];
    [categoriesFilter insertObject:@"NO" atIndex:4];
    [categoriesFilter insertObject:@"NO" atIndex:5];
    [categoriesFilter insertObject:@"NO" atIndex:6];
    [categoriesFilter insertObject:@"NO" atIndex:7];
    [categoriesFilter insertObject:@"NO" atIndex:8];
    [categoriesFilter insertObject:@"NO" atIndex:9];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"markerSelecction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"markerUnSelecction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"showPromotion" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"closeCategoriesToMap" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"showFilter" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"closeMenuMap" object:nil];
    
    [self calculateBounds];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:newark zoom:17 bearing:0 viewingAngle:0];
    
    self.mapViewUI.camera = camera;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    self.mapViewUI.myLocationEnabled = YES;
    
    self.mapViewUI.settings.myLocationButton=YES;
    
    self.scrollElements.delegate=self;
    self.scrollElements.layer.borderColor = [UIColor colorWithRed:204.0/255.0
                                                            green:204.0/255.0
                                                             blue:204.0/255.0
                                                            alpha:1.0].CGColor;
    self.scrollElements.layer.borderWidth = 1.0f;
    
    self.scrollElements.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [self addOverlayUnico];
    [self loadElements];
    
    [self alertscreen:@"Información" :@"La precisión de tu ubicación en el mapa depende del equipo que estés usando."];
}

-(void) viewDidAppear:(BOOL)animated
{
    // Se inicial el location manager cuando aparece la vista
    [locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"doRouting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"closeMenuMap" object:nil];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    // Se detiene el location manager cuando desaparece la vista
    [locationManager stopUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doRouting" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeMenuMap" object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 * @brief Metodo que borra el cluster e inicializa uno nuevo
 * @return void
 */
- (void) generateNewCluster
{
    [self.mapViewUI clear];
    
    [self addOverlayUnico];
    
    clusterManager = [[GClusterManager alloc] init];
    [clusterManager setMapView:self.mapViewUI];
    [clusterManager setClusterAlgorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]];
    [clusterManager setClusterRenderer:[[GDefaultClusterRenderer alloc] initWithGoogleMap:self.mapViewUI]];
    
    [self.mapViewUI setDelegate:clusterManager];
}

/*!
 * @brief Metodo llamado cuando tocan el boton del primer piso
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonFirstFloor:(id)sender {
    
    if(floorV!=1)
    {
        floorV=1;
        
        [self.buttonFirstFloor setBackgroundImage:[UIImage imageNamed:@"tabIzquierdoActivo.png"] forState:UIControlStateNormal];
        
        [self.buttonFirstFloor setTitleColor:[UIColor colorWithRed:186.0/255.0
                                                             green:8.0/255.0
                                                              blue:19.0/255.0
                                                             alpha:1.0] forState:UIControlStateNormal];
        
        [self.buttonSecondFloor setBackgroundImage:[UIImage imageNamed:@"tabDerechoNoActivo.png"] forState:UIControlStateNormal];
        
        [self.buttonSecondFloor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self loadElements];
    }
}

/*!
 * @brief Metodo llamado cuando tocan el boton del segundo piso
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonSecondFloor:(id)sender {

    if(floorV!=2)
    {
        floorV=2;
        [self.buttonFirstFloor setBackgroundImage:[UIImage imageNamed:@"tabIzquierdoNoActivo.png"] forState:UIControlStateNormal];
        
        [self.buttonFirstFloor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.buttonSecondFloor setBackgroundImage:[UIImage imageNamed:@"tabDerechoActivo.png"] forState:UIControlStateNormal];
        
        [self.buttonSecondFloor setTitleColor:[UIColor colorWithRed:186.0/255.0
                                                              green:8.0/255.0
                                                               blue:19.0/255.0
                                                              alpha:1.0] forState:UIControlStateNormal];
        [self loadElements];
    }
}

/*!
 * @brief Metodo llamado cuando tocan el boton del filtro
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonFilter:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"categories"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
    [sfvc setStateCatgories:[categoriesFilter mutableCopy]];
    [sfvc setCaller:@"closeCategoriesToMap"];
    [sfvc changeBehaviorTipo:NO];
    
}

/*!
 * @brief Metodo llamado cuando tocan el boton de hacer ruta
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonRoute:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchRouteViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"seachRoute"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
}

/*!
 * @brief Metodo llamado cuando tocan el boton del menu
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonMenu:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [sfvc setViewCaller:@"mapView"];
    [self presentViewController:sfvc animated:YES completion:nil];
}

/*!
 * @brief Metodo llamado cuando tocan el boton de ayuda
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonHelp:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SliderViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"sliderTutorial"];
    [sfvc setType:@"map"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
    [sfvc setCloseAction:YES];
    
}

/*!
 * @brief Metodo llamado cuando tocan el boton de borrar ruta
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonTrashRouting:(id)sender {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.mapViewUI.camera.target.latitude longitude:self.mapViewUI.camera.target.longitude zoom:self.mapViewUI.camera.zoom bearing:self.mapViewUI.camera.bearing viewingAngle:0.0 ];
    [self.mapViewUI animateToCameraPosition:camera];
    self.buttonTrashRouting.hidden=YES;
    self.trashSeperator.hidden = YES;
    
    for(id obj in polylinesMap)
    {
        [obj setMap:nil];
    }
    
    routing= [[NSMutableArray alloc]init];
    polylinesMap = [[NSMutableArray alloc]init];
    
}

/*!
 * @brief Metodo para ejecutar la accion de como llegar
 * @param rStore, tienda a la que toca hacer la ruta
 * @return void
 */
-(void) setAutomaticRouting:(ModelStore*) rStore
{
    autoRouting=YES;
    autoStore=rStore;
}

#pragma mark- Util

/*!
 * @brief Metodo para mostrar un Alert en pantalla
 * @param title, Titulo del alert
 * @param msg, Mensaje a ser mostrado
 * @return void
 */
-(void) alertscreen:(NSString *)title :(NSString *)msg{
    
    
    UIAlertView *aView = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil, nil];
    [aView show];
    
}

/*!
 * @brief Metodo para calcular los bounds de un mapa
 * @return void
 */
-(void) calculateBounds
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray* coorTmp = [genericComponets getMapCoordinatesByCity:[[userDefaults objectForKey:@"city_id"] intValue] andFloor:floorV];
    
    if([[coorTmp objectAtIndex:4] intValue]==1)
    {
        self.buttonSecondFloor.enabled=NO;
       [self.buttonSecondFloor setTitleColor:[UIColor colorWithRed:173.0/256.0 green:170.0/256.0 blue:170.0/256.0 alpha:1.0] forState:UIControlStateHighlighted];
    }
    else
    {
        self.buttonSecondFloor.enabled=YES;
        [self.buttonSecondFloor setTitleColor:[UIColor colorWithRed:186.0/255.0
                                                              green:8.0/255.0
                                                               blue:19.0/255.0
                                                              alpha:1.0] forState:UIControlStateHighlighted];
        
    }
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake([[coorTmp objectAtIndex:0] floatValue],[[coorTmp objectAtIndex:1] floatValue]);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake([[coorTmp objectAtIndex:2] floatValue],[[coorTmp objectAtIndex:3] floatValue]);
    
    overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest coordinate:northEast];
    
    newark = GMSGeometryInterpolate(southWest, northEast, 0.5);
}

/*!
 * @brief Metodo agraga la imagen del mapa del centro comercial al mapa
 * @return void
 */
-(void) addOverlayUnico
{
    [self calculateBounds];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    GMSGroundOverlay *groundOverlay = [[GMSGroundOverlay alloc] init];
    
    groundOverlay.icon = [UIImage imageNamed:[genericComponets getMapImageByCity:[[userDefaults objectForKey:@"city_id"] intValue] andFloor:floorV]];
    
    groundOverlay.position = newark;
    
    groundOverlay.zIndex = 0;
    
    groundOverlay.bounds = overlayBounds;
    
    groundOverlay.map = self.mapViewUI;
}

/*!
 * @brief Metodo pinta la ruta en el mapa.
 * @param overview_route, Ruta
 * @return void
 */
- (void) paintRouteWithPath:(ModelRouting*) overview_route
{
    if(debug)
    {
        NSLog(@"Line #%@#",overview_route.geometry);
    }
    
    NSString* geom=[NSString stringWithString:overview_route.geometry];
    @try
    {
    
   
    GMSPath *path = [GMSPath pathFromEncodedPath:geom];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    
    polyline.strokeWidth = 5.0f;
    
        GMSStrokeStyle *solidBlack = [GMSStrokeStyle solidColor:[UIColor colorWithRed:186.0/255.0
                                                                                green:8.0/255.0
                                                                                 blue:19.0/255.0
                                                                                alpha:1.0]];
    
    polyline.spans = @[[GMSStyleSpan spanWithStyle:solidBlack]];
    
    polyline.zIndex = 100;
    
    polyline.map = self.mapViewUI;
    
    [polylinesMap addObject:polyline];
    
    GMSPolyline *stroke = [GMSPolyline polylineWithPath:path];
    stroke.strokeColor = [UIColor blackColor];
    stroke.strokeWidth = polyline.strokeWidth + 1;
    stroke.zIndex = polyline.zIndex - 1;
    
    stroke.map = self.mapViewUI;
    
    [polylinesMap addObject:stroke];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(overview_route.sLatitude,overview_route.sLongitude)];
    
    marker.icon=[UIImage imageNamed:[genericComponets getMapRoutingIconByType:overview_route.sType]];
    marker.map = self.mapViewUI;
    
    [polylinesMap addObject:marker];
    
    marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(overview_route.eLatitude,overview_route.eLongitude)];
    
    marker.icon=[UIImage imageNamed:[genericComponets getMapRoutingIconByType:overview_route.eType]];
    marker.map = self.mapViewUI;
    
    [polylinesMap addObject:marker];
    }
    
    @catch (NSException *ex) {
        if(debug)
            NSLog(@"Error %@",ex);
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // remueve el popup cuando toca el mapa.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"markerUnSelecction" object:nil];
}

#pragma mark - Network

/*!
 * @brief Metodo para hacer las llamadas de RED
 * @param dict, diccionario con el json de la peticion
 * @return void
 */
-(void) networkCall:(NSDictionary *) dict{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
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
        
        
        [SVProgressHUD dismiss];
        
        if(json)
        {
            if(debug)
            {
                NSLog(@"Json Resultado Promociones %@",[operation responseString]);
            }
            [self handlerResponse:json];
        }
        else
        {
            if(debug)
            {
                NSLog(@"Plano %@",[operation responseString]);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        if(debug){
            NSLog(@"Error: %@", error);
        }
        [self alertscreen:@"Error" :[genericComponets getErrorMessage]];
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    //[operation start];
    [queue addOperation:operation];
}

/*!
 * @brief Metodo que pide las promociones al servidor
 * @return void
 */
- (void) loadElements
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"markerUnSelecction" object:nil];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * dict=@{@"property":@"nreference",
                          @"direction":@"ASC"};
    
    NSMutableArray* dictU=[[NSMutableArray alloc] init];
    
    [dictU addObject:@{@"field":@"nmall",@"value":[userDefaults objectForKey:@"city_id"],@"type":@"numeric",@"comparison":@"eq"}];
    
    [dictU addObject:@{@"field":@"nfloor",@"value":[NSString stringWithFormat:@"%d",floorV],@"type":@"numeric",@"comparison":@"eq"}];
    
    NSString* Stringcategorias=@"";
    for (int i=0; i<[categoriesFilter count]; i++)
    {
        
        if([[categoriesFilter objectAtIndex:i] isEqualToString:@"YES"])
        {
            if([Stringcategorias isEqualToString:@""])
            {
                Stringcategorias=[NSString stringWithFormat:@"%d",(i+1)];
            }
            else
            {
                Stringcategorias=[NSString stringWithFormat:@"%@,%d",Stringcategorias,(i+1)];
            }
        }
    }
    
    if(![Stringcategorias isEqualToString:@""])
    {
        [dictU addObject:@{@"field":@"ncategory",@"value":Stringcategorias,@"type":@"numeric",@"comparison":@"in"}];
    }
    
    NSDictionary * dict2=@{@"function":@"offer@index",
                           @"id_movil":[userDefaults objectForKey:@"id_movil"],
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"os":@"ios",
                           @"latitud":[NSString stringWithFormat:@"%+.6f",latitude],
                           @"longitud":[NSString stringWithFormat:@"%+.6f",longitude],
                           @"page":@"1",
                           @"limit":[genericComponets getNumberPromotionsMap],
                           @"sort":dict,
                           @"filter":dictU};
    
    [self networkCall:dict2];
    
    
}

/*!
 * @brief Metodo encargado de manejar la respeusta al servicio
 * @param json, Json con la respuesta
 * @return void
 */
-(void) handlerResponse:(NSDictionary *)json
{
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"offer@index"] )
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Registro");
            }
            [self alertscreen:@"Error de Consulta" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            
            NSDictionary *data=[json valueForKey:@"data"];
            
            int cont=0;
            
            [self generateNewCluster];
             
            
            for(NSDictionary *promDict in data){
                
                //Se crean los objetos tipo promocione
                ModelPromotion *temp = [[ModelPromotion alloc] init];
                [temp populateWithJson:promDict];
                if([temp store])
                {
                    if(![storeReference objectForKey:[NSString stringWithFormat:@"%d",[temp storeId]]])
                    {
                        [storeReference setObject:[temp store] forKey:[NSString stringWithFormat:@"%d",[temp storeId]]];
                    }
                    else
                    {
                        [temp setStore:[storeReference objectForKey:[NSString stringWithFormat:@"%d",[temp storeId]]]];
                    }
                    
                    Spot* spot = [[Spot alloc] init];
                    spot.location = CLLocationCoordinate2DMake([temp getLatitude],[temp getLongitude]);
                    spot.image=[genericComponets getMapImageByCategory:[temp promotionCategory] andType:[temp promotionPriority]];
                    spot.promotion=temp;
                    //Se agregan al cluster mananger
                    [clusterManager addItem:spot];
                }
                
                cont++;
            }
            
            [clusterManager cluster];
            
            cont=0;
            
            if([routing count]!=0)
            {
                for(ModelRouting* r in routing)
                {
                    if(r.floor==floorV)
                    {
                        [self paintRouteWithPath:r];
                        NSLog(@"ACA ESTOY IMPRIMIENDO");
                    }
                }
            }
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"store@ruteo"] )
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Registro");
            }
            [self alertscreen:@"Error de Consulta" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            if(debug)
            {
                NSLog(@"Error de Registro %@",json);
            }
            
            
            NSDictionary *routes=[json valueForKey:@"route"];
            int cont=0;
            //Borra la ruta actual si existe
           [self touchButtonTrashRouting:nil];

           for (NSDictionary* route in routes)
           {
               //crea los objtos tipo ruteo
               ModelRouting* r=[[ModelRouting alloc] init];
               [r populateWithJson:route];
               
               [routing addObject:r];
               
               if([r iamStratPoint])
               {
                   if(r.floor!=floorV)
                   {
                       //Depende del piso que se este visualziando carla la ruta
                       if(floorV==1)
                       {
                           [self touchButtonSecondFloor:nil];
                       }
                       else if(floorV==2)
                       {
                           [self touchButtonFirstFloor:nil];
                       }
                   }
                   
                   [self paintRouteWithPath:r];
                   if(cont==0)
                   {
                       //Mueve el mapa al punto de incio de la ruta
                       GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:r.sLatitude longitude:r.sLongitude zoom:18 bearing:self.mapViewUI.camera.bearing viewingAngle:45.0 ];
                       [self.mapViewUI animateToCameraPosition:camera];
                       self.buttonTrashRouting.hidden=NO;
                       self.trashSeperator.hidden = NO;
                   }
                   else
                   {
                       cont=1;
                   }
               }
               else
               {
                   if(r.floor==floorV)
                   {
                       [self paintRouteWithPath:r];
                   }
               }
               
               
               
               
           }
            
        }
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
    }

}

#pragma mark - msegueHandler

/*!
 * @brief Metodo que maneja los mensajes que llegan de otras vistas
 * @param notice, Informacion del mesaje recibido
 * @return void
 */
-(void)yourNotificationHandler:(NSNotification *)notice{
    
    //Se valida que notificacion llego
    if([notice.name isEqualToString:@"markerSelecction"])
    {
        
        NSMutableArray* elements =(NSMutableArray* )[notice object];
        if([elements count]>10)
        {
            UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"Información"
                                                            message:@"Por favor acercate para ver las ofertas."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [aView show];
        }
        else
        {
            [self.scrollElements setContentOffset:CGPointZero animated:NO];
            
            [self.scrollElements.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
            
            
            self.viewInfo.frame=CGRectMake(0, 0, self.view.frame.size.width ,80);
            self.viewInfo.hidden=NO;
            // agrega al popup la vistas de cada promcion en un mismo marcador
            const int NumPages = [elements count];
            self.scrollElements.contentSize = CGSizeMake(NumPages * 320, 80);
            self.scrollElements.pagingEnabled = NO;
            int i=0;
            for(ModelPromotion* prom in elements) {
                NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"InfoWindow"
                                                                  owner:self
                                                                options:nil];
                
                CustomInfoWindow* mainView = (CustomInfoWindow*)[nibViews objectAtIndex:0];
                
                CGRect frame = mainView.frame;
                //Hint close images horinzotally distance
                frame.origin.x = i * 300/1;
                mainView.frame = frame;
                
                [mainView.imagePromotion setImageWithURL:[NSURL URLWithString:[prom promotionImage]] placeholderImage:[UIImage imageNamed:[genericComponets getDefaultImagePromotion]]];
                mainView.labelPromotion.text=prom.promotionNames;
                mainView.labelStore.text=prom.promotionStore;
                mainView.labelDiscount.text=prom.promotionDiscount;
                mainView.promotion=prom;
                
                [self.scrollElements addSubview:mainView];
                i++;
            }
            
            [UIView animateWithDuration:0.3 delay:0
             
                                options:UIViewAnimationOptionCurveEaseOut animations:^{
                                    
                                    self.viewInfo.frame=CGRectMake(0, self.header.frame.size.height + 5, self.view.frame.size.width  ,80);
                                    
                                } completion:nil];
        }
        
        
    }
    else if([notice.name isEqualToString:@"markerUnSelecction"])
    {
        //Quita el popoup
        [UIView animateWithDuration:0.3 delay:0
         
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                
                                self.viewInfo.frame=CGRectMake(10, 0, 300 ,80);
                                
                            } completion:^(BOOL finished){
                                
                                self.viewInfo.hidden=YES;
                            
                            }];
    }
    else if([notice.name isEqualToString:@"showPromotion"])
    {
        // Muestra la vista de promocion
        ModelPromotion* promotion =(ModelPromotion* )[notice object];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PromotionDetailViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
        [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
        [sfvc setType:@"promotion"];
        [sfvc setPromotion:promotion];
        [self presentViewController:sfvc animated:YES completion:nil];
    }
    else if([notice.name isEqualToString:@"closeCategoriesToMap"])
    {
        //Aplica el fintro de categorias
        if(notice.object)
        {
            categoriesFilter=notice.object;
            
            [self loadElements];
        }
    }
    else if([notice.name isEqualToString:@"showFilter"])
    {
        // Vuestra el filtro
        [self touchButtonFilter:nil];
    }
    else if([notice.name isEqualToString:@"closeMenuMap"])
    {
        // Recarga el Mapa
        if(YES)
        {
            NSLog(@"CargarMapaAgain");
        }
        floorV=1;
        
        [self calculateBounds];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:newark zoom:17 bearing:0 viewingAngle:0];
        
        self.mapViewUI.camera = camera;
        
        [self addOverlayUnico];
        [self loadElements];
    }
    else if([notice.name isEqualToString:@"doRouting"])
    {
        // Realiza el ruteo
        if(notice.object)
        {
            if(debug)
            {
                NSLog(@"Route %@",notice.object);
            }
            NSMutableArray* stores = notice.object;
            
            BOOL dorouting=YES;
            
            if(([[stores objectAtIndex:0] idlocal]==0|| [[stores objectAtIndex:1] idlocal]==0))
            {
                if(latitude==0.0 || longitude==0.0)
                {
                    dorouting=NO;
                }
            }
            
            if(dorouting)
            {
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                
                NSMutableArray* dictU=[[NSMutableArray alloc] init];
                
                [dictU addObject:@{@"field":@"nmall",@"value":[userDefaults objectForKey:@"city_id"],@"type":@"numeric",@"comparison":@"eq"}];
                

                NSDictionary * dict2=@{@"function":@"store@ruteo",
                                       @"id_movil":[userDefaults objectForKey:@"id_movil"],
                                       @"token_push":[userDefaults objectForKey:@"token_push"],
                                       @"os":@"ios",
                                       @"latitud":[NSString stringWithFormat:@"%+.6f",latitude],
                                       @"longitud":[NSString stringWithFormat:@"%+.6f",longitude],
                                       @"storeIdBegin":[NSString stringWithFormat:@"%d",[[stores objectAtIndex:0] idlocal]],
                                       @"storeIdEnd":[NSString stringWithFormat:@"%d",[[stores objectAtIndex:1] idlocal]]};
                
                [self networkCall:dict2];
                
            }
            else
            {
                [self alertscreen:@"Información" :@"Para realizar una ruta desde tu posición actual debes activar tu GPS."];
            }
        }
    }
    
}

#pragma mark - Scroll Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = round(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    
    
    CGRect newFrame = [self.scrollElements frame];
    
    // Calculate the x-coordinate of the frame where the scroll should go to.
    newFrame.origin.x = newFrame.size.width * page -20 * page;
    
    // Scroll the frame we specified above.
    [self.scrollElements scrollRectToVisible:newFrame animated:YES];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int page = round(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    
    
    CGRect newFrame = [self.scrollElements frame];
    
    // Calculate the x-coordinate of the frame where the scroll should go to.
    newFrame.origin.x = newFrame.size.width * page -20 * page;
    
    // Scroll the frame we specified above.
    [self.scrollElements scrollRectToVisible:newFrame animated:YES];
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        latitude=location.coordinate.latitude;
        longitude=location.coordinate.longitude;
        // If the event is recent, do something with it.
        //NSLog(@"latitude %+.6f, longitude %+.6f\n",location.coordinate.latitude,location.coordinate.longitude);
    }
   
    if(autoRouting)
    {
        if(debug)
        {
            NSLog(@"Autoroution");
        }
        autoRouting=NO;
        NSMutableArray* ma =[[NSMutableArray alloc] init];
        
        ModelStore* m = [[ModelStore alloc] init];
        [m populateWithName:@"Ubicación Actual" image:@"" description:@"" likes:0 id:0 latitude:0.0 longitude:0.0 floor:0 numlocal:@"0"];
        
        [ma insertObject:m atIndex:0];
        [ma insertObject:autoStore atIndex:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"doRouting" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doRouting" object:ma];
    }
}

@end
