//
//  PromotionsViewController.m
//  Unico Final
//
//  Created by Datatraffic on 9/23/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "PromotionsViewController.h"
#import "TableViewCell.h"
#import "ModelPromotion.h"
#import "ModelEvent.h"
#import "PromotionDetailViewController.h"
#import "CategoryViewController.h"
#import "MenuViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "genericComponets.h"

@interface PromotionsViewController ()

@end

@implementation PromotionsViewController{
    // si esta animado
    BOOL animating;
    // Modo de la vista
    BOOL debug;
    // Si hay mas datos para cargar
    BOOL ShouldLoadMore;
    // Contenedor de datos par ala tabla
    NSMutableArray *container;
    // Celda seleccionada
    NSUInteger tag;
    // Celda activa
    NSString *activeCel;
    //Cola de llamados al servidor
    NSOperationQueue *queue;
    // Pagina actual
    int page;
    // Filtro de categorias aplicado
    NSMutableArray *categoriesFilter;
    // Tiendas
    NSMutableDictionary* storeReference;
    // Texto de busqueda
    NSString* querySearch;
    //Tipo de la vista
    NSString* viewType;
    // Oferta
    NSString* offer;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self changeView];
    
    [self setNeedsStatusBarAppearanceUpdate];
    debug=[genericComponets getMode];
    ShouldLoadMore=YES;
    querySearch=@"";
    if(!viewType)
    {
        viewType=@"promotions";
    }
    
    if(!offer)
    {
        offer=@"";
    }
    page=1;
    self.listings.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    queue=[[NSOperationQueue alloc]init];
    activeCel=@"";
    container = [[NSMutableArray alloc] init];
    storeReference= [[NSMutableDictionary alloc] init];
    self.serachBar.delegate=self;
    // Filtro Categorias
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"closeCategories" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"closeMenu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"showEventsAutomatic" object:nil];
    
    [self.listings setDelegate:self];
    self.listings.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
    
    [self loadMoreRowsByIndex:1 AndQuery:querySearch];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cellView" object:nil];
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"cellView" object:nil];
    
    if(offer && ![offer isEqualToString:@""])
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSDictionary * dict=@{@"property":@"nreference",
                              @"direction":@"ASC"};
        
        NSMutableArray* dictU=[[NSMutableArray alloc] init];
        
        [dictU addObject:@{@"field":@"nreference",@"value":offer,@"type":@"numeric",@"comparison":@"eq"}];
        
        NSString *function =@"offer";
        
        if([viewType isEqualToString:@"promotions"])
        {
            function =@"offer";
        }
        else if([viewType isEqualToString:@"events"])
        {
            function =@"event";
        }
        
        
        NSDictionary * dict2=@{@"function":[ NSString stringWithFormat:@"%@@index",function],
                               @"id_movil":[userDefaults objectForKey:@"id_movil"],
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios",
                               @"latitud":@"0.000",
                               @"longitud":@"-0.0000",
                               @"page":@"1",
                               @"limit":@"1",
                               @"sort":dict,
                               @"filter":dictU};
        
        [self asynchroRequest:dict2];
    }

}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 * @brief Metodo para definir una oferta o evento cuando es llega una notificacion
 * @param of, oferta/tienda
 * @return void
 */
- (void) setOffer:(NSString*) of
{
    offer=of;
}
/*!
 * @brief Metodo llamado cuando elusuario toca la pantalla
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)tapped:(id)sender {
    
}
/*!
 * @brief Metodo llamado cuando presionan el boton de buscar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonSearch:(id)sender {
    
    [UIView animateWithDuration:0.3 delay:0
     
            options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.serachBar.frame=CGRectMake(30, self.serachBar.frame.origin.y, self.serachBar.frame.size.width ,self.serachBar.frame.size.height);
                
                self.serachBar.alpha=1.0;
                self.imageHeaderTwo.frame=CGRectMake(0, self.imageHeaderTwo.frame.origin.y, self.imageHeaderTwo.frame.size.width ,self.imageHeaderTwo.frame.size.height);
                self.buttonBack.frame=CGRectMake(5, self.buttonBack.frame.origin.y, self.buttonBack.frame.size.width ,self.buttonBack.frame.size.height);
                self.buttonBack.alpha=1.0;
                
                self.imageHeader.frame=CGRectMake(-320, self.imageHeader.frame.origin.y, self.imageHeader.frame.size.width ,self.imageHeader.frame.size.height);
                self.buttonUnicoLogo.frame=CGRectMake(-273, self.buttonUnicoLogo.frame.origin.y, self.buttonUnicoLogo.frame.size.width ,self.buttonUnicoLogo.frame.size.height);
                self.buttonSearch.frame=CGRectMake(-86, self.buttonSearch.frame.origin.y, self.buttonSearch.frame.size.width ,self.buttonSearch.frame.size.height);
                self.buttonSearch.alpha=0;
                self.arrow.frame=CGRectMake(-121, self.arrow.frame.origin.y, self.arrow.frame.size.width ,self.arrow.frame.size.height);
                self.buttonMenu.frame=CGRectMake(-357,self.buttonMenu.frame.origin.y, self.buttonMenu.frame.size.width ,self.buttonMenu.frame.size.height);
                self.buttonMenu.alpha=0;
                self.textMenu.frame=CGRectMake(-327,self.textMenu.frame.origin.y, self.textMenu.frame.size.width ,self.textMenu.frame.size.height);
                self.textMenu.alpha=0;
                
            } completion:nil];
    
    
}

/*!
 * @brief Metodo llamado cuando presionan el boton de volver de busqueda
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonBack:(id)sender {
    
    self.serachBar.text = @"";
    [self.serachBar resignFirstResponder];
    [self cleanList];
    [self loadMoreRowsByIndex:1 AndQuery:@""];
    [UIView animateWithDuration:0.3 delay:0
     
            options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                self.serachBar.frame=CGRectMake(400, self.serachBar.frame.origin.y, self.serachBar.frame.size.width ,self.serachBar.frame.size.height);
                self.serachBar.alpha=0;
                self.imageHeaderTwo.frame=CGRectMake(320, self.imageHeaderTwo.frame.origin.y, self.imageHeaderTwo.frame.size.width ,self.imageHeaderTwo.frame.size.height);
                self.buttonBack.frame=CGRectMake(325, self.buttonBack.frame.origin.y, self.buttonBack.frame.size.width ,self.buttonBack.frame.size.height);
                self.buttonBack.alpha=0;
                
                self.imageHeader.frame=CGRectMake(0, self.imageHeader.frame.origin.y, self.imageHeader.frame.size.width ,self.imageHeader.frame.size.height);
                self.buttonUnicoLogo.frame=CGRectMake(83, self.buttonUnicoLogo.frame.origin.y, self.buttonUnicoLogo.frame.size.width ,self.buttonUnicoLogo.frame.size.height);
                self.buttonSearch.frame=CGRectMake(283, self.buttonSearch.frame.origin.y, self.buttonSearch.frame.size.width ,self.buttonSearch.frame.size.height);
                self.buttonSearch.alpha=1.0;
                self.arrow.frame=CGRectMake(245, self.arrow.frame.origin.y, self.arrow.frame.size.width ,self.arrow.frame.size.height);
                self.buttonMenu.frame=CGRectMake(-1, self.buttonMenu.frame.origin.y, self.buttonMenu.frame.size.width ,self.buttonMenu.frame.size.height);
                self.textMenu.frame=CGRectMake(30,self.textMenu.frame.origin.y, self.textMenu.frame.size.width ,self.textMenu.frame.size.height);
                self.buttonMenu.alpha=1.0;
                self.textMenu.alpha=1.0;
                
            } completion:nil];
    
}
/*!
 * @brief Metodo llamado cuando presionan el boton del filtro
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)promotionButton:(id)sender {
    [self startSpin];
    //sleep(10);
    [NSTimer scheduledTimerWithTimeInterval: 0.02 target: self selector: @selector(stopSpin) userInfo: nil repeats: YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"categories"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
    [sfvc setStateCatgories:[categoriesFilter mutableCopy]];
    [sfvc changeBehaviorTipo:NO];
}
/*!
 * @brief Metodo llamado cuando presionan el boton de abrir el menu
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)menuButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    if([viewType isEqualToString:@"promotions"])
    {
        [sfvc setViewCaller:@"promotionView"];
    }
    else if([viewType isEqualToString:@"events"])
    {
        [sfvc setViewCaller:@"eventView"];
    }
    [self presentViewController:sfvc animated:YES completion:nil];
}


- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.05f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}

/*!
 * @brief Metodo llamado cuando se quiere compartir un elemento
 * @param cell, Celda a la que se le dio share
 * @return void
 */
- (void) sharingButton:(TableViewCell *) cell {
    
    NSString * typeRequest=@"";
    
    int reference=0;
    
    if(debug)
    {
        NSLog(@"sharing %@",viewType);
    }
    NSArray * activityItems;
    NSString *className = NSStringFromClass([[container objectAtIndex:[cell getId]] class]);
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    if([className isEqualToString:@"ModelPromotion"])
    {
        ModelPromotion *p1 = [container objectAtIndex:[cell getId]];
        
        activityItems = @[[NSString stringWithFormat:@"%@ %@ en %@",[userDefaults objectForKey:@"pushLine"],[p1 promotionNames], [p1 promotionStore]],[NSURL URLWithString:[genericComponets shareURL]], [cell imagePromotion].image];
        
        typeRequest=@"offer";
        reference=[p1 promotionId];
    }
    else if([className isEqualToString:@"ModelEvent"])
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        ModelEvent *p1 = [container objectAtIndex:[cell getId]];
        activityItems = @[[NSString stringWithFormat:@"%@ %@ desde el %@",[userDefaults objectForKey:@"pushLine"],[p1 eventName],[p1 startDate]],[NSURL URLWithString:[genericComponets shareURL]],[cell imagePromotion].image];
        
        typeRequest=@"event";
        reference=[p1 eventId];
    }
    
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact,
                                    UIActivityTypePostToWeibo, UIActivityTypePrint];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
    
    NSDictionary * dict2=@{@"function":[NSString stringWithFormat:@"%@@share",typeRequest],
                           @"id_movil":[userDefaults objectForKey:@"id_movil"],
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"os":@"ios",
                           @"ref":[NSString stringWithFormat:@"%d",reference]};
    
    [self networkCall:dict2 showLayer:NO];
}

#pragma mark - Table Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)listing
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [container count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(debug)
    {
        NSLog(@"sharing %@",viewType);
    }
    
    static NSString *CellIdentifier = @"TableViewCell";
    TableViewCell *cell = (TableViewCell *) [self.listings dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if([container count]>indexPath.row)
    {
        if([viewType isEqualToString:@"promotions"])
        {
            cell.storeName.text = [[container objectAtIndex:indexPath.row] promotionStore];
            
            cell.discountPromotions.text =[[container objectAtIndex:indexPath.row] promotionDiscount];
            
            cell.promotionName.text = [[container objectAtIndex:indexPath.row] promotionNames];
            
            [cell.imagePromotion setImageWithURL:[NSURL URLWithString:[[container objectAtIndex:indexPath.row] promotionImage]] placeholderImage:[UIImage imageNamed:[genericComponets getDefaultImagePromotion]]];
        }
        else if([viewType isEqualToString:@"events"])
        {
            cell.storeName.text = [[container objectAtIndex:indexPath.row] eventName];
            
            cell.discountPromotions.text=@"";
            
            //cell.promotionName.text =[[container objectAtIndex:indexPath.row] startDate];
            cell.promotionName.text = @"";
            
            [cell.imagePromotion setImageWithURL:[NSURL URLWithString:[[container objectAtIndex:indexPath.row] eventImage]] placeholderImage:[UIImage imageNamed:[genericComponets getDefaultImagePromotion]]];
        }
        
        
        [cell setId:indexPath.row];
        
        cell.slide.hidden=![[container objectAtIndex:indexPath.row] swipe];
        
        if ([[NSUserDefaults standardUserDefaults]
             boolForKey:@"perform"]) {
            [self performSegueWithIdentifier:@"cellView" sender:self];
        }
        
        if (indexPath.row == [container count] - 1 && ShouldLoadMore)
        {
            page++;
            [self loadMoreRowsByIndex:page AndQuery:querySearch];
            
        }
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleSwipeGestureLeft:)];
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell addGestureRecognizer:swipeGestureLeft];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(handleSwipeGestureRight:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        
        [cell addGestureRecognizer:swipeGesture];
        
        [self removeSelectedSwipe];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 252;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"cellView" sender:self];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.serachBar resignFirstResponder];
}


#pragma mark - Network

/*!
 * @brief Metodo para hacer las llamadas de RED
 * @param dict, diccionario con el json de la peticion
 * @param show, Inidica si se debe mostrar o no la precarga
 * @return void
 */
-(void) networkCall:(NSDictionary *) dict showLayer:(BOOL) show{
  
    [queue cancelAllOperations];
    if(show)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
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
        
        if(show)
        {
            [SVProgressHUD dismiss];
        }
        if(json)
        {
            if(debug)
            {
               NSLog(@"Json Resultado Promociones %@",json);
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
        if(show)
        {
            [SVProgressHUD dismiss];
        }
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
 * @brief Metodo trae del servidor mas elementos para la lista
 * @param index, pagina
 * @param query, texto a buscar en la lista
 * @return void
 */
- (void) loadMoreRowsByIndex:(int) index AndQuery:(NSString*)query
{
    page=index;
    querySearch=query;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * dict=@{@"property":@"nreference",
                          @"direction":@"ASC"};
    
    NSMutableArray* dictU=[[NSMutableArray alloc] init];

    [dictU addObject:@{@"field":@"nmall",@"value":[userDefaults objectForKey:@"city_id"],@"type":@"numeric",@"comparison":@"eq"}];
    
    if(![query isEqualToString:@""])
    {
        [dictU addObject:@{@"field":@"stitle",@"value":query,@"type":@"string"}];
    }
    
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
    NSString *function =@"offer";
    
    if([viewType isEqualToString:@"promotions"])
    {
        function =@"offer";
    }
    else if([viewType isEqualToString:@"events"])
    {
        function =@"event";
    }
    
    
    NSDictionary * dict2=@{@"function":[ NSString stringWithFormat:@"%@@index",function],
                           @"id_movil":[userDefaults objectForKey:@"id_movil"],
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"os":@"ios",
                           @"latitud":@"0.000",
                           @"longitud":@"-0.0000",
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"limit":[genericComponets getPromotionsPerLoad],
                           @"sort":dict,
                           @"filter":dictU};
    
    [self networkCall:dict2 showLayer:YES];
    
    
}

/*!
 * @brief Metodo que realiza llamadas asincronas al servidor
 * @param dict2, Jsonc on los datos a ser enviados
 * @return void
 */
- (void) asynchroRequest:(NSDictionary *)dict2
{
    offer=@"";
    NSError *errorj;
    
    NSString* aStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict2
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
                // NSLog(@"Json Resultado Promociones %@",json);
            }
            if([json valueForKey:@"function"] && ([[json valueForKey:@"function"] isEqualToString:@"offer@index"] || [[json valueForKey:@"function"] isEqualToString:@"event@index"]))
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
                    
                    if([json valueForKey:@"data"])
                    {
                        if([viewType isEqualToString:@"promotions"])
                        {
                            for(NSDictionary *promDict in data){
                                
                                ModelPromotion *temp = [[ModelPromotion alloc] init];
                                [temp populateWithJson:promDict];
                                
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                PromotionDetailViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
                                [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
                                [sfvc setType:@"promotion"];
                                [sfvc setPromotion:temp];
                                [self presentViewController:sfvc animated:YES completion:nil];
                                
                            }
                        }
                        else if([viewType isEqualToString:@"events"])
                        {
                            for(NSDictionary *eveDict in data){
                                
                                ModelEvent *temp = [[ModelEvent alloc] init];
                                [temp populateWithJson:eveDict];
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                PromotionDetailViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
                                [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
                                [sfvc setType:@"event"];
                                [sfvc setEventObject:temp];
                                [self presentViewController:sfvc animated:YES completion:nil];
                            }
                        }
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
 * @brief Metodo encargado de manejar la respeusta al servicio
 * @param json, Json con la respuesta
 * @return void
 */
-(void) handlerResponse:(NSDictionary *)json
{
    // Se verifica el llamado
    if([json valueForKey:@"function"] && ([[json valueForKey:@"function"] isEqualToString:@"offer@index"] || [[json valueForKey:@"function"] isEqualToString:@"event@index"]))
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
            if([json valueForKey:@"data"])
            {
                if([viewType isEqualToString:@"promotions"])
                {
                    for(NSDictionary *promDict in data){
                        
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
                            
                            [container addObject:temp];
                        }
                        
                        cont++;
                    }
                }
                else if([viewType isEqualToString:@"events"])
                {
                    for(NSDictionary *eveDict in data){
                        
                        ModelEvent *temp = [[ModelEvent alloc] init];
                        [temp populateWithJson:eveDict];
                        
                        [container addObject:temp];
                        cont++;
                    }
                }
                if(debug)
                    NSLog(@"count %d",cont);
                
                if(cont<[[genericComponets getPromotionsPerLoad] integerValue])
                {
                    ShouldLoadMore=NO;
                }
                else
                {
                    ShouldLoadMore=YES;
                }
                
                if(page==1 && cont!=0)
                {
                    [self.listings reloadData];
                }
                else
                {
                    [self.listings performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }
            }
           
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] rangeOfString:@"@share"].location != NSNotFound )
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Share");
            }
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"points"] forKey:@"points"];
            [userDefaults synchronize];
        }
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
    }
}


# pragma mark - SwipeHandler

-(void)handleSwipeGestureLeft:(UIGestureRecognizer *)gestureRecognizer{
    // Se agrega el gesto a la celda
    TableViewCell *cell=(TableViewCell *)gestureRecognizer.view ;
    
    [self removeSelectedSwipe];
    
    if(![[container objectAtIndex:[cell getId]] swipe])
    {
        activeCel=[NSString stringWithFormat:@"%d",[cell getId]];
        [[container objectAtIndex:[cell getId]] setSwipe:YES];
        
        cell.slide.hidden=NO;
        cell.slide.alpha=0;
        
        [UIView animateWithDuration:0.3 delay:0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                
                                cell.slide.alpha=0.9;
                                
                            } completion:nil];
    }
    
    
}

-(void)handleSwipeGestureRight:(UIGestureRecognizer *)gestureRecognizer{
    // Se agrega el gesto a celda
    TableViewCell *cell=(TableViewCell *)gestureRecognizer.view ;
    
    if([[container objectAtIndex:[cell getId]] swipe])
    {
        activeCel=@"";
        [[container objectAtIndex:[cell getId]] setSwipe:NO];
        
        [UIView animateWithDuration:0.3 delay:0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                
                                cell.slide.alpha=0;
                                
                                
                            } completion:^(BOOL finished) { cell.slide.hidden=YES; }];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // oculta la iamgen de swipe cuando el usuario mueve la lista
    [self removeSelectedSwipe];
}

/*!
 * @brief Metodo que hace el efecto de la imagen de swipe
 * @return void
 */
- (void) removeSelectedSwipe
{
    if (![activeCel isEqualToString:@""])
    {
        
        [[container objectAtIndex:[activeCel intValue]] setSwipe:NO];
        
        TableViewCell *cell= ((TableViewCell *)[self.listings cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[activeCel intValue]inSection:0]]);
        
        activeCel=@"";
        [UIView animateWithDuration:0.3 delay:0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                
                                cell.slide.alpha=0;
                                
                                
                            } completion:^(BOOL finished) { cell.slide.hidden=YES; }];
        
        
    }
}

#pragma mark - msegueHandler

/*!
 * @brief Metodo que es llamado cuando se envia una notificacion desde otra vista
 * @param notice, informacion del mensaje enviado
 * @return void
 */
-(void)yourNotificationHandler:(NSNotification *)notice{
    if(debug)
    {
        NSLog(@"La Celda %@",notice.name);
    }
    // Se verfica que mensaje llego
    if([notice.name isEqualToString:@"cellView"])
    {
        TableViewCell *cell=(TableViewCell* )[notice object];
        if(cell.slide.hidden)
        {
            tag = [cell getId];
            if(debug)
            {
                NSLog(@"se hace segue ");
            }
            if([container count]>tag)
            {
                [self performSegueWithIdentifier:@"cellView" sender:self];
            }
            else{
                NSLog(@"TOY VACIO ");
            }
        }
        else
        {
            [self sharingButton:cell];
        }
    }
    else if([notice.name isEqualToString:@"closeCategories"])
    {
        [self startSpin];
        //sleep(10);
        [NSTimer scheduledTimerWithTimeInterval: 0.02 target: self selector: @selector(stopSpin) userInfo: nil repeats: YES];
        
        if(notice.object)
        {
            categoriesFilter=notice.object;
            
            [self cleanList];
            
            [self loadMoreRowsByIndex:1 AndQuery:querySearch];
        }
    }
    else if([notice.name isEqualToString:@"closeMenu"])
    {
        [self cleanList];
        
        [self loadMoreRowsByIndex:1 AndQuery:querySearch];
    }
    else if([notice.name isEqualToString:@"showEventsAutomatic"])
    {
        [self performSegueWithIdentifier:@"itselfPromotions" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Verfica que tipo de segue se va realziar
    if ([[segue identifier] isEqualToString:@"cellView"]) {
        
        // Get destination view
        
        if([container count]>tag)
        {
            PromotionDetailViewController *vc = [segue destinationViewController];
            [vc setType:@"promotion"];
            [vc setPromotion:[container objectAtIndex:tag]];
            if([viewType isEqualToString:@"promotions"])
            {
                [vc setType:@"promotion"];
                [vc setPromotion:[container objectAtIndex:tag]];
            }
            else if([viewType isEqualToString:@"events"])
            {
                [vc setType:@"event"];
                [vc setEventObject:[container objectAtIndex:tag]];
            }
        }
    }
    else if ([[segue identifier] isEqualToString:@"itselfPromotions"]) {
        
        PromotionsViewController *vc = [segue destinationViewController];
        [vc setTypeofView:@"events"];
    }
}

#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // ingresa texto de busqueda
    [self cleanList];
    querySearch=searchText;
    
    [self loadMoreRowsByIndex:1 AndQuery:querySearch];
}

#pragma mark - Custom

/*!
 * @brief Metodo para definir el tipo de vista
 * @param newViewType, Boton
 * @return void
 */
-(void) setTypeofView:(NSString* )newViewType
{
    viewType=newViewType;
}

/*!
 * @brief Metodo que configura la interfaz segun el tipo de vista
 * @return void
 */
-(void) changeView
{
    if([viewType isEqualToString:@"promotions"])
    {
        self.buttonUnicoLogo.hidden=NO;
        self.buttonSearch.hidden=NO;
        self.arrow.hidden=NO;
        self.labelTitle.text=@"Promociones";
    }
    else if([viewType isEqualToString:@"events"])
    {
        self.buttonUnicoLogo.hidden=YES;
        self.buttonSearch.hidden=YES;
        self.arrow.hidden=YES;
        self.labelTitle.text=@"Eventos";
    }
}

#pragma mark - Util

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
 * @brief Metodo que borra los datos de la tabla
 * @return void
 */
- (void) cleanList
{
    [self.listings scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    container=[[NSMutableArray alloc] init];
    
    storeReference=[[NSMutableDictionary alloc] init];
}





@end
