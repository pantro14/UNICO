//
//  CazaOfertasViewController.m
//  Unico Final
//
//  Created by Francisco Garcia on 10/31/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "CazaOfertasViewController.h"
#import "MenuViewController.h"
#import "GenericSearchViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "genericComponets.h"
#import "ModelStore.h"


@interface CazaOfertasViewController ()

@end

@implementation CazaOfertasViewController
{
    //Tienda seleccionada
    ModelStore* store;
    // Modo de la vista
    BOOL debug;
    // Cola de las llamadas
    NSOperationQueue *queue;
}

- (void)viewDidLoad {
    
    queue=[[NSOperationQueue alloc]init];
    
    [super viewDidLoad];
    debug=[genericComponets getMode];
    
    self.textViewDescripcion.layer.cornerRadius=8.0f;
    self.textViewDescripcion.layer.masksToBounds=YES;
    self.textViewDescripcion.layer.borderColor=[[UIColor colorWithRed:186.0/255.0
                                                                green:8.0/255.0
                                                                 blue:19.0/255.0
                                                                alpha:1.0] CGColor];;
    self.textViewDescripcion.layer.borderWidth= 1.0f;
    
    self.textViewDescripcion.delegate = self;
    
    
    self.buttonSave.clipsToBounds = YES;
    self.buttonSave.layer.cornerRadius = 5.0f;
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height + 50);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"storeSelection" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ButtonsMethods

/*!
 * @brief Metodo cuando se presiona el boton de seleccion de un elemento
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonStores:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GenericSearchViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"GenericSearch"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [sfvc setType:@"store" andCaller:@"storeSelection"];
    [self presentViewController:sfvc animated:YES completion:nil];
 
}

/*!
 * @brief Metodo cuando se presiona el boton de menu
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonMenu:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [sfvc setViewCaller:@"cazaView"];
    [self presentViewController:sfvc animated:YES completion:nil];
}

/*!
 * @brief Metodo cuando se presiona el boton de guardar
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonSave:(id)sender {
    
    self.textTitle.text=[self.textTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.textDiscount.text=[self.textDiscount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.textViewDescripcion.text=[self.textViewDescripcion.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // Se validan los datos del formulario
    if([self.textTitle.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"Debe ingresar un título para la promoción. "];
    }
    else if([self.textDiscount.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"Debe ingresar el descuento de la promoción."];
    }
    else if(!store)
    {
        [self alertscreen:@"Error" :@"Debe seleccionar una tienda."];
    }
    else if([self.textViewDescripcion.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"Debe ingresar la descripción de la promoción."];
    }
    else
    {
    
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        
        NSDictionary * data=@{@"stitle":self.textTitle.text,
                              @"sdescription":self.textViewDescripcion.text,
                              @"nstore":[NSString stringWithFormat:@"%d",store.storeId],
                              @"soffertypedetails":self.textDiscount.text};
        
        
        
        NSDictionary * dict2=@{@"function":@"offer@insert",
                               @"id_movil":[userDefaults objectForKey:@"id_movil"],
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios",
                               @"latitud":@"0.000",
                               @"longitud":@"-0.0000",
                               @"data":data};
        
        [self networkCall:dict2];
        [self.view endEditing:YES];
    }
    
}

#pragma mark - Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //Si se esta editando una campo se mueve al vista para que le teclado no la tape
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            self.scrollView.contentOffset = CGPointMake(0, textView.frame.origin.y-35 );
                            
                        } completion:nil];
    
    
    return YES;
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //Si se toca la pantalla desaparece el tecaldo
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    //Si se esta editando una campo se mueve al vista para que le teclado no la tape
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            
                            self.scrollView.contentOffset = CGPointMake(0, 0 );
                            
                        } completion:nil];
    [self.view endEditing:YES];
}

#pragma mark - msegueHandler

/*!
 * @brief Metodo que es llamado cuando se envia una notificacion desde otra vista
 * @param notice, informacion del mensaje enviado
 * @return void
 */
-(void)yourNotificationHandler:(NSNotification *)notice{
    // Se valida de que elemetno viene el mensaje
    if([notice.name isEqualToString:@"storeSelection"])
    {
        
        store=notice.object;

        [self.buttonStore setTitle:store.storeName forState:UIControlStateNormal];
    }
}

#pragma mark - Network

/*!
 * @brief Metodo para hacer las llamadas de RED
 * @param dict, diccionario con el json de la peticion
 * @return void
 */
-(void) networkCall:(NSDictionary *) dict{
    
    [queue cancelAllOperations];
    
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
        [self alertscreen:@"Error" :@"No pudimos traer la información solicitada."];
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    [queue addOperation:operation];
}

/*!
 * @brief Metodo encargado de manejar la respeusta al servicio
 * @param json, Json con la respuesta
 * @return void
 */
-(void) handlerResponse:(NSDictionary *)json
{
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"offer@insert"]  )
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
            store=nil;
            
            [self.buttonStore setTitle:@"Tienda" forState:UIControlStateNormal];
            
            self.textTitle.text=@"";
            
            self.textViewDescripcion.text=@"";
            
            self.textDiscount.text=@"";
            
            [UIView animateWithDuration:0.2 delay:0
                                options:UIViewAnimationOptionTransitionCurlDown animations:^{
                                    
                                    
                                    self.scrollView.contentOffset = CGPointMake(0, 0 );
                                    
                                } completion:nil];
            [self.view endEditing:YES];
            
            [self alertscreen:@"Información" :@"Gracias por Participar tu promoción a sido creada."];
        }
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
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


@end
