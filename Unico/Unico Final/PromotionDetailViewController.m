//
//  PromotionDetailViewController.m
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "MenuViewController.h"
#import "ModelPromotion.h"
#import "ModelStore.h"
#import "ModelEvent.h"
#import "MapsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "genericComponets.h"

@interface PromotionDetailViewController ()

@end

@implementation PromotionDetailViewController{
    
    // promocion
    ModelPromotion *promotion;
    // Tienda
    ModelStore *store;
    //Evento
    ModelEvent *event;
    // Tipo de la vista
    NSString *type;
    // Modo de la vista
    BOOL debug;
    // Cola de llamados
    NSOperationQueue *queue;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if(!type)
    {
        type=@"promotion";
    }
    debug=[genericComponets getMode];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"perform"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.scrollView.delegate = self;
    self.scrollView.contentSize=CGSizeMake(self.view.bounds.size.width, 850);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.shareLabel.clipsToBounds = YES;
    self.shareLabel.layer.cornerRadius = 5.0f;
    
    self.textView.delegate=self;
    queue=[[NSOperationQueue alloc]init];
    
    [self setElement];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    NSString *function =@"offer";
    int id_el=0;
    
    
    NSMutableDictionary * dict2=[[NSMutableDictionary alloc] init];
    [dict2 setObject:[userDefaults objectForKey:@"id_movil"] forKey:@"id_movil"];
    [dict2 setObject:[userDefaults objectForKey:@"token_push"] forKey:@"token_push"];
    [dict2 setObject:@"ios" forKey:@"os"];
    [dict2 setObject:@"0.000" forKey:@"latitud"];
    [dict2 setObject:@"-0.0000" forKey:@"longitud"];
    
    // Se carga el elemento segun sea el caso
    if([type isEqualToString:@"promotion"])
    {
        function =@"offer";
        id_el=[promotion promotionId];
        
    }
    else if([type isEqualToString:@"event"])
    {
        function =@"event";
        id_el=[event eventId];
    }
    else if([type isEqualToString:@"store"])
    {
        function =@"store";
        id_el=[store storeId];
    }
    
    [dict2 setObject:[ NSString stringWithFormat:@"%@@visit",function] forKey:@"function"];
    [dict2 setObject:[NSString stringWithFormat:@"%d",id_el] forKey:[ NSString stringWithFormat:@"id_%@",function]];
    
    [self asynchroRequest:dict2];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //Metodo encagado de manejar el efeto de panl deslizable
    float scrollHeight = 226;
    if (self.view.frame.size.height < 568){
        scrollHeight = 187.5;
    }
   
    if(self.scrollView.bounds.origin.y >=scrollHeight){
        
        [self.topBar setClipsToBounds:YES];
        [self.topBar setFrame:CGRectMake(0, self.scrollView.bounds.origin.y, self.topBar.bounds.size.width,self.topBar.bounds.size.height)];
        
    }else{
        
        [self.topBar setClipsToBounds:NO];
        [self.topBar setFrame:CGRectMake(0,scrollHeight,self.topBar.frame.size.width,self.topBar.frame.size.height)];
       
    }
}

/*!
 * @brief Metodo que define una promocion para llenar la vista
 * @param promotionIn, Promocion para llenar el contnido
 * @return void
 */
-(void) setPromotion:(ModelPromotion *) promotionIn{
    
    promotion=promotionIn;
}
/*!
 * @brief Metodo que evento una promocion para llenar la vista
 * @param eventIn, Evento para llenar el contnido
 * @return void
 */
-(void) setEventObject:(ModelEvent *) eventIn{
    
    event=eventIn;
}
/*!
 * @brief Metodo que define una tienda para llenar la vista
 * @param storeIn, Tienda para llenar el contnido
 * @return void
 */
-(void) seStoreObject:(ModelStore *) storeIn{
    
    store=storeIn;
}
/*!
 * @brief Metodo llamado cuando presionan el boton de cerrar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)backButton:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}
/*!
 * @brief Metodo llamado cuando presionan el boton ir a tienda
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)showShop:(id)sender {
    if([type isEqualToString:@"promotion"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PromotionDetailViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
        [sfvc setType:@"store"];
        [sfvc seStoreObject:[promotion store]];
        [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:sfvc animated:YES completion:nil];
    }
    
}
/*!
 * @brief Metodo llamado cuando presionan el boton de compartir
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)sharingButton:(id)sender {
    
    NSString * typeRequest=@"";
    
    int reference=0;
    
    NSArray * activityItems = @[@"Gran promoción en el Centro Comercial Unico",[NSURL URLWithString:@"http://www.portal.unico.com.co"]];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    // construlle el texto de compartir seun sea el caso
    if([type isEqualToString:@"promotion"])
    {
        activityItems = @[[NSString stringWithFormat:@"%@ %@ en %@",[userDefaults objectForKey:@"pushLine"],[promotion promotionNames], [promotion promotionStore]],[NSURL URLWithString:[genericComponets shareURL]],self.backgroundImage.image];
        
        typeRequest=@"offer";
        reference=[promotion promotionId];
    }
    else if([type isEqualToString:@"store"])
    {
        activityItems = @[[NSString stringWithFormat:@"%@ %@",[userDefaults objectForKey:@"pushLine"],[store storeName]],[NSURL URLWithString:[genericComponets shareURL]],self.backgroundImage.image];
        
        typeRequest=@"store";
        reference=[store storeId];
    }
    else if([type isEqualToString:@"event"])
    {
        activityItems = @[[NSString stringWithFormat:@"%@ %@ desde el %@",[userDefaults objectForKey:@"pushLine"],[event eventName],[event startDate]],[NSURL URLWithString:[genericComponets shareURL]],self.backgroundImage.image];
        
        typeRequest=@"event";
        reference=[event eventId];
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
    
    [self networkCall:dict2];
}
/*!
 * @brief Metodo llamado cuando presionan el boton de like
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonLike:(id)sender {
    
    NSString * typeRequest=@"";
    
    int reference=0;
    
    if([type isEqualToString:@"promotion"])
    {
        typeRequest=@"offer";
        reference=[promotion promotionId];
    }
    else if([type isEqualToString:@"store"])
    {
        typeRequest=@"store";
        reference=[store storeId];
    }
    else if([type isEqualToString:@"event"])
    {
        typeRequest=@"event";
        reference=[event eventId];
    }
    // Hace llamado al servicio de conteo de likes
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary * dict2=@{@"function":[NSString stringWithFormat:@"%@@like",typeRequest],
                           @"id_movil":[userDefaults objectForKey:@"id_movil"],
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"os":@"ios",
                           @"ref":[NSString stringWithFormat:@"%d",reference]};
    
    [self networkCall:dict2];
}
/*!
 * @brief Metodo llamado cuando presionan el boton de como llegar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonRoute:(id)sender {
    
    [self performSegueWithIdentifier:@"detailToMap" sender:self];
}
/*!
 * @brief Metodo llamado cuando presionan el boton de abrir el menu
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)openMenu:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
    
}
/*!
 * @brief Metodo para definir el tipo de vista (promocion/tienda.evento)
 * @param nType, tipo de vista
 * @return void
 */
- (void) setType:(NSString *) nType
{
    type=nType;
}
/*!
 * @brief Metodo que retorna el tipo de vista
 * @return NSString, tipo de la vista
 */
- (NSString *) getType
{
    return type;
}
/*!
 * @brief Metodo que ajusta la interfaz segun el tipo de elemento
 * @return void
 */
- (void) setElement
{
    if([type isEqualToString:@"promotion"])
    {
        if(!promotion)
        {
            promotion = [[ModelPromotion alloc] init];
        }
        
        [self.storeName setTitle:[promotion promotionStore] forState:UIControlStateNormal];
        [self.promoName setTitle:[promotion promotionNames] forState:UIControlStateNormal];
        //self.backgroundImage.image = [UIImage imageNamed:[promotion promotionImage]];
        
        [self.backgroundImage setImageWithURL:[NSURL URLWithString:[promotion promotionImage]] placeholderImage:[UIImage imageNamed:[genericComponets getDefaultImagePromotion]]];
        
        self.labelDetails.text=[promotion promotionDiscount];
    
        self.shareLabel.text=[NSString stringWithFormat:@"%d Likes",[promotion promotionLikes]];
        [self.textView loadHTMLString:[NSString stringWithFormat:@"<div align='justify' style='color:#616161;font-family:Helvetica57-Condensed;font-size:1.2em;margin: 5px;width:260;'><br><br><br><span style='display:inline;font-weight:bold;font-style:uppercase;'>%@<br>Ubicación Local %@</span><br>%@<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><div>",[promotion promotionNames],[[promotion store]numlocal],[promotion promotionDescription]] baseURL:nil];
        
        if(!promotion.liked)
            self.buttonLike.enabled=YES;
        else
            self.buttonLike.enabled=NO;
    }
    else if([type isEqualToString:@"store"])
    {
        if(!store)
        {
            store = [[ModelStore alloc] init];
        }
        
        [self.storeName setTitle:[store storeName] forState:UIControlStateNormal];
        [self.storeName setEnabled:NO];
        [self.promoName setTitle:@"" forState:UIControlStateNormal];
        
        [self.backgroundImage setImageWithURL:[NSURL URLWithString:[store storeImage]] placeholderImage:[UIImage imageNamed:[genericComponets getDefaultImagePromotion]]];
        
        self.labelDetails.text=[NSString stringWithFormat:@"Tienda %@",[store storeName]];
        
        self.shareLabel.text=[NSString stringWithFormat:@"%d Likes",[store storeLikes]];
        
        [self.textView loadHTMLString:[NSString stringWithFormat:@"<div align='justify' style='color:#616161;font-family:Helvetica57-Condensed;font-size:1.2em;margin: 5px;'><br><br><br><span style='display:inline;font-weight:bold;font-style:uppercase;'>Ubicación Local %@</span><br>%@<br><br><br><br><br>  <br><br><br><br><br><br><br><br><br><br><div>",[store numlocal],[store storeDescription]] baseURL:nil];
        
        if(!store.liked)
            self.buttonLike.enabled=YES;
        else
            self.buttonLike.enabled=NO;
    }
    else if([type isEqualToString:@"event"])
    {
        if(!event)
        {
            event = [[ModelEvent alloc] init];
        }
        
        //[self.storeName setTitle:[event startDate] forState:UIControlStateNormal];
        [self.storeName setTitle:[event eventName] forState:UIControlStateNormal];
        [self.storeName setEnabled:NO];
        //[self.promoName setTitle:@"Inicio" forState:UIControlStateNormal];
        [self.promoName setTitle:@"" forState:UIControlStateNormal];
        
        [self.backgroundImage setImageWithURL:[NSURL URLWithString:[event eventImage]] placeholderImage:[UIImage imageNamed:[genericComponets getDefaultImagePromotion]]];
        
        self.labelDetails.text=[NSString stringWithFormat:@"%@",[event eventName]];
        
        
        NSString* lista=@"";
        if([[event promotionsName] count]>0)
        {
            lista=@"Promociones relacionadas:";
        }
        for(int i=0;i<[[event promotionsName] count];i++)
        {
            lista=[NSString stringWithFormat:@"%@<br>- %@",lista,[[event promotionsName] objectAtIndex:i]];
        }
        
        self.shareLabel.text=[NSString stringWithFormat:@"%d Likes",[event eventLikes]];
        [self.textView loadHTMLString:[NSString stringWithFormat:@"<div align='justify' style='color:#616161;font-family:Helvetica57-Condensed;font-size:1.2em;margin: 5px;'><br><br><br><b>Desde el:</b> %@ <br><b>Hasta el:</b> %@<br><br>%@<br><br>%@<br><br><br><br><br>  <br><br><br><br><br><br><br><br><br><br><div>",[event startDate],[event endDate],[event eventDescription],lista] baseURL:nil];
        self.buttonDoRouting.hidden=YES;
        self.buttonShare.frame=CGRectMake(112, self.buttonShare.frame.origin.y, self.buttonShare.frame.size.width,self.buttonShare.frame.size.height);
        self.buttonLike.frame=CGRectMake(175, self.buttonLike.frame.origin.y, self.buttonLike.frame.size.width,self.buttonLike.frame.size.height);
        
        if(!event.liked)
            self.buttonLike.enabled=YES;
        else
            self.buttonLike.enabled=NO;
    }
}


# pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"shopItself"]) {
        
        PromotionDetailViewController *vc = [segue destinationViewController];
        [vc setType:@"store"];
        [vc seStoreObject:[promotion store]];
    }
    else if ([[segue identifier] isEqualToString:@"detailToMap"]) {
        
        MapsViewController *vc = [segue destinationViewController];
        [vc setAutomaticRouting:[promotion store]];
    }
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:
    (UIWebViewNavigationType)inType {
    // Cancela los llamados locales del webview
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
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

#pragma mark - Network

/*!
 * @brief Metodo que realiza llamadas asincronas al servidor
 * @param dict2, Jsonc on los datos a ser enviados
 * @return void
 */
- (void) asynchroRequest:(NSDictionary *)dict2
{
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
        
        
        if(json)
        {
            if(debug)
            {
                 NSLog(@"Regsitro visitas %@",json);
            }
            if([json valueForKey:@"function"] && ([[json valueForKey:@"function"] isEqualToString:@"offer@visit"] || [[json valueForKey:@"function"] isEqualToString:@"event@ivisit"] || [[json valueForKey:@"function"] isEqualToString:@"store@ivisit"]))
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
                        NSLog(@"Registro de Visita");
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
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] rangeOfString:@"@like"].location != NSNotFound)
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Like");
            }
            //[self alertscreen:@"Error" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            if([type isEqualToString:@"promotion"])
            {
                [promotion setPromotionLikes:[[[json valueForKey:@"data"] valueForKey:@"likes"] intValue]];
            }
            else if([type isEqualToString:@"store"])
            {
                [store setStoreLikes:[[[json valueForKey:@"data"] valueForKey:@"likes"] intValue]];
            }
            else if([type isEqualToString:@"event"])
            {
                [event setEventLikes:[[[json valueForKey:@"data"] valueForKey:@"likes"] intValue]];
            }
            
            self.shareLabel.text=[NSString stringWithFormat:@"%@ Likes",[[json valueForKey:@"data"] valueForKey:@"likes"]];
            
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"points"] forKey:@"points"];
            [userDefaults synchronize];
            self.buttonLike.enabled=NO;
            
            if([type isEqualToString:@"promotion"])
            {
                promotion.liked=YES;
            }
            else if([type isEqualToString:@"store"])
            {
                store.liked=YES;
            }
            else if([type isEqualToString:@"event"])
            {
                event.liked=YES;
            }        
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] rangeOfString:@"@share"].location != NSNotFound)
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Like");
            }
           // [self alertscreen:@"Error" :[json valueForKey:@"msg"]];
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


@end
