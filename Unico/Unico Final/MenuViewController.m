//
//  MenuViewController.m
//  Unico Final
//
//  Created by Datatraffic on 10/10/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "MenuViewController.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "CategoryViewController.h"
#import "PromotionsViewController.h"
#import "CategoryViewController.h"
#import "SliderViewController.h"
#import "SVProgressHUD.h"
#import "genericComponets.h"

@interface MenuViewController ()

@end

@implementation MenuViewController{
    BOOL debug;
    NSMutableArray *pickerData;
    BOOL shouldUpdate;
    BOOL isPromotion;
    NSString* caller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    shouldUpdate=NO;
    isPromotion=NO;
    self.scrollView.contentSize=CGSizeMake(self.view.bounds.size.width, 450);
    self.scrollView.delegate=self;
    debug=[genericComponets getMode];
    _helpClose.hidden = YES;
    _faqClose.hidden = YES;
    _aboutUsClose.hidden = YES;
    if(!caller)
    {
        caller=@"";
    }
    //Otros
    
    self.buttonShareUnico2.clipsToBounds = YES;
    self.buttonShareUnico2.layer.cornerRadius = 5.0;
    
    self.customToolBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMenuFooter.png"]];
    
    //Elementos Myacount
    
    self.labelPoints.clipsToBounds = YES;
    self.labelPoints.layer.cornerRadius = 10.0f;
    
    self.buttonSave.clipsToBounds = YES;
    self.buttonSave.layer.cornerRadius = 5.0;
    
    self.buttonSavePass.clipsToBounds = YES;
    self.buttonSavePass.layer.cornerRadius = 5.0f;
    
    self.buttonUpdateCategories.clipsToBounds = YES;
    self.buttonUpdateCategories.layer.cornerRadius = 5.0f;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.mcEmailText.text=[userDefaults objectForKey:@"email"];
    self.mcNombreText.text=[userDefaults objectForKey:@"name"];
    self.mcApellidoText.text=[userDefaults objectForKey:@"lastName"];
    self.textNamePqrs.text=[NSString stringWithFormat:@"%@ %@",[userDefaults objectForKey:@"name"],[userDefaults objectForKey:@"lastName"]];
    [self.buttonCity setTitle:[userDefaults objectForKey:@"city_name"] forState:UIControlStateNormal];
    self.labelPoints.text=[NSString stringWithFormat:@"%@ Puntos",[userDefaults objectForKey:@"points"]];

    if(![[userDefaults objectForKey:@"facebook"] isEqualToString:@""])
    {
        self.textOldPassword.enabled=NO;
        self.textOldPassword.placeholder=@"Secreta Facebook";
        self.textNewPassword.enabled=NO;
        self.textNewPassword.placeholder=@"Secreta Facebook";
        self.textRePassword.enabled=NO;
        self.textRePassword.placeholder=@"Secreta Facebook";
        self.buttonSavePass.enabled=NO;
    }
    self.pickerCity.delegate=self;
    
    self.textNewPassword.delegate=self;
    self.textOldPassword.delegate=self;
    self.textRePassword .delegate=self;
    self.mcApellidoText .delegate=self;
    self.mcNombreText .delegate=self;
    
    // Elements Help
    self.buttonTutorial.clipsToBounds = YES;
    self.buttonTutorial.layer.cornerRadius = 5.0;
    
    // Elements PQRS
    self.textViewComment.layer.cornerRadius=8.0f;
    self.textViewComment.layer.masksToBounds=YES;
    self.textViewComment.layer.borderColor=[[UIColor colorWithRed:186.0/255.0
                                                                green:8.0/255.0
                                                                 blue:19.0/255.0
                                                                alpha:1.0] CGColor];;
    self.textViewComment.layer.borderWidth= 1.0f;
    
    //self.textViewComment.text = @"Escribe aqui tu comentario.";
    //self.textViewComment.textColor = [UIColor lightGrayColor];
    self.textViewComment.delegate = self;
    
    self.buttonSend.clipsToBounds = YES;
    self.buttonSend.layer.cornerRadius = 5.0;
    
    self.textSubject.delegate=self;
    
    // Elements About
    
    [self.webAbout loadHTMLString:[NSString stringWithFormat:@"<div align='justify' style='width:260;'>%@<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><div>",@""] baseURL:nil];
    
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 * @brief Metodo llamado cuando dan clic al boton a abrir una seccion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)openSectionMenu:(id)sender {
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    [UIView animateWithDuration:0.3 delay:0
     
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            
                            // Se anima el ocultar los otros botones
                            if([sender tag]==1)
                            {
                                _myAccountClose.hidden = NO;
                            }
                            else
                            {
                                _myAccount.alpha=0;
                            }
                            
                            _buttonSet.alpha=0;
                            
                            if([sender tag]==2)
                            {
                                _helpClose.hidden = NO;
                                self.scrollView.scrollEnabled = NO;
                            }
                            else
                            {
                                _helpView.alpha=0;
                            }
                            
                            if([sender tag]==3)
                            {
                                _faqClose.hidden = NO;
                            }
                            else
                            {
                                _faqView.alpha=0;
                            }
                            
                            if([sender tag]==4)
                            {
                                _aboutUsClose.hidden = NO;
                                self.scrollView.scrollEnabled = NO;
                            }
                            else
                            {
                                _aboutView.alpha=0;
                            }
                            
                            
                        } completion:^(BOOL finished){
                            _buttonSet.hidden = YES;

                            if([sender tag]!=1)
                            {
                                _myAccount.hidden = YES;
                            }
                            if([sender tag]!=2)
                            {
                                _helpView.hidden = YES;
                            }
                            
                            if([sender tag]!=3)
                            {
                                _faqView.hidden = YES;
                            }
                            
                            if([sender tag]!=4)
                            {
                                _aboutView.hidden = YES;
                            }
                            
                            [UIView animateWithDuration:0.2 delay:0
                             
                                                options:UIViewAnimationOptionTransitionCurlDown animations:^{
                                                    // Se anima el mostar el contenido de la seccion
                                                    if([sender tag]==1)
                                                    {
                                                        _myAccount.frame=CGRectMake(0, 0, self.view.frame.size.width,600);
                                                    }
                                                    
                                                    if([sender tag]==2)
                                                    {
                                                        _helpView.frame=CGRectMake(0, 0, self.view.frame.size.width,600);
                                                    }
                                                    
                                                    if([sender tag]==3)
                                                    {
                                                        _faqView.frame=CGRectMake(0, 0, self.view.frame.size.width,600);
                                                    }
                                                    
                                                    if([sender tag]==4)
                                                    {
                                                        _aboutView.frame=CGRectMake(0, 0, self.view.frame.size.width,600);
                                                    }
                                                    
                                                    
                                                } completion:^(BOOL finished){
                                                    
                                                    [UIView animateWithDuration:0.3 delay:0
                                                     
                                                                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                                                                            if([sender tag]==1)
                                                                            {
                                                                                _mcElementView.frame=CGRectMake(0, 44, self.view.frame.size.width,600);
                                                                            }
                                                                            
                                                                            if([sender tag]==2)
                                                                            {
                                                                                _hElementView.frame=CGRectMake(0, 44, self.view.frame.size.width,600);
                                                                            }
                                                                            if([sender tag]==3)
                                                                            {
                                                                                _pElementView.frame=CGRectMake(0, 44, self.view.frame.size.width,600);
                                                                            }
                                                                            
                                                                            if([sender tag]==4)
                                                                            {
                                                                                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                                                                                
                                                                                NSDictionary * dict2=@{@"function":@"content@index",
                                                                                                       @"id_movil":[userDefaults objectForKey:@"id_movil"],
                                                                                                       @"token_push":[userDefaults objectForKey:@"token_push"],
                                                                                                       @"os":@"ios",
                                                                                                       @"limit":@"1",
                                                                                                       @"page":@"1",
                                                                                                       @"sort":@{@"property":@"nreference", @"direction":@"ASC"},
                                                                                                       @"filter":@[@{@"field":@"stag", @"value":@"#QUIENES SOMOS", @"type":@"string", @"compare":@"0"}]
                                                                                                       };
                                                                                
                                                                                [self networkCall:dict2];
                                                                                _aElementView.frame=CGRectMake(0, 44, self.view.frame.size.width,600);
                                                                            }
                                                                            
                                                                        } completion:nil];}];
                        }];
}

/*!
 * @brief Metodo llamado cuando dan clic al boton de cerrar una seccion
 * @param sender, Boton seleccionado
 * @return IBAction
 */

- (IBAction)closeSectionMenu:(id)sender {
    
    [self.view endEditing:YES];
    
    self.scrollView.scrollEnabled = YES;

    // Se mueve la vista a offset 0
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    [UIView animateWithDuration:0.3 delay:0
     
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            // dependiendo de la seccion se anima su cierre
                            if([sender tag]==1)
                            {
                                _mcElementView.frame=CGRectMake(0, 900, self.view.frame.size.width,300);
                                _myAccountClose.hidden = YES;
                            }
                            
                            if([sender tag]==2)
                            {
                                _hElementView.frame=CGRectMake(0, 900, self.view.frame.size.width,300);
                                _helpClose.hidden = YES;
                            }
                            
                            if([sender tag]==3)
                            {
                                _pElementView.frame=CGRectMake(0, 900, self.view.frame.size.width,300);
                                _faqClose.hidden = YES;
                            }
                            
                            if([sender tag]==4)
                            {
                                _aElementView.frame=CGRectMake(0, 900, self.view.frame.size.width,300);
                                _aboutUsClose.hidden = YES;
                            }
                            
                        } completion:^(BOOL finished){
                            [UIView animateWithDuration:0.3 delay:0
                             
                                                options:UIViewAnimationOptionTransitionCurlDown animations:^{
                                                    // se hace aparecer los otros botones
                                                    if([sender tag]==1)
                                                    {
                                                        _myAccount.frame=CGRectMake(0, 0, self.view.frame.size.width,44);
                                                    }
                                                    
                                                    if([sender tag]==2)
                                                    {
                                                        _helpView.frame=CGRectMake(0, 220, self.view.frame.size.width,44);
                                                    }
                                                    
                                                    if([sender tag]==3)
                                                    {
                                                        _faqView.frame=CGRectMake(0, 264, self.view.frame.size.width,44);
                                                    }
                                                    
                                                    if([sender tag]==4)
                                                    {
                                                        _aboutView.frame=CGRectMake(0, 308, self.view.frame.size.width,44);
                                                    }
                                                    
                                                } completion:^(BOOL finished){
                                                    _buttonSet.hidden = NO;
                                                    _myAccount.hidden = NO;
                                                    _helpView.hidden = NO;
                                                    _faqView.hidden = NO;
                                                    _aboutView.hidden = NO;
                                                    
                                                    [UIView animateWithDuration:0.3 delay:0
                                                     
                                                                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                                            // se hace aparecer los otros botones
                                                                            _buttonSet.alpha=1;
                                                                            _myAccount.alpha=1;
                                                                            _faqView.alpha=1;
                                                                            _helpView.alpha=1;
                                                                            _aboutView.alpha=1;
                                                                            
                                                                        } completion:nil];}];
                            
                        }];

}


#pragma mark - ButtonsAction

/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a mapa
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)mapTapped:(id)sender {
    
    if(debug)
        NSLog(@"Map");
    
    if([caller isEqualToString:@"mapView"])
    {
        if(!shouldUpdate)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self performSegueWithIdentifier:@"goToMapFromMenu" sender:self];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"goToMapFromMenu" sender:self];
    }
}

/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a promocion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)promotionTapped:(id)sender {
    
    if(debug)
        NSLog(@"Promocion");
    
    if([caller isEqualToString:@"promotionView"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        isPromotion=YES;
        [self performSegueWithIdentifier:@"goToPromFromMenu" sender:self];
    }
}

/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a cazaofertas
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)houseOfOffersTapped:(id)sender {
    
    if(debug)
        NSLog(@"house");
    
    if([caller isEqualToString:@"cazaView"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        if([[userDefaults objectForKey:@"usertype"] isEqualToString:@"normal"])
        {
            // Descompetar esta linie para habilitar el formulario de usuario final
            //[self performSegueWithIdentifier:@"goToCazaFromMenu" sender:self];
            [self alertscreen:@"Información" :@"Esta opción será habilitada próximamente para que te conviertas en un caza-ofertas."];
        }
        else if([[userDefaults objectForKey:@"usertype"] isEqualToString:@"supervisor"])
        {
            [self performSegueWithIdentifier:@"goToCazaPlusFromMenu" sender:self];
        }
    }
    
}

/*!
 * @brief Metodo llamado cuando dan clic al boton de ir a evento
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)eventTapped:(id)sender {
    
    if(debug)
        NSLog(@"eventos");
    
    if([caller isEqualToString:@"eventView"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        isPromotion=NO;
        
        [self performSegueWithIdentifier:@"goToPromFromMenu" sender:self];
    }
}

/*!
 * @brief Metodo llamado cuando dan clic al boton de compartir aplicacion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)shareTapped:(id)sender {
    
    // se Presenta el dialogo de compartir
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSArray * activityItems = @[[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"shareApp"] ],[NSURL URLWithString:[genericComponets getItunesLink]]];
    
    
    NSArray * applicationActivities = nil;
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact,
                                    UIActivityTypePostToWeibo, UIActivityTypePrint];
    
    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    activityController.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityController animated:YES completion:nil];
    
    // Se llama el servicio de conteo de compartir
    NSDictionary * dict2=@{@"function":@"app@share",
                           @"id_movil":[userDefaults objectForKey:@"id_movil"],
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"os":@"ios"};
    
    [self networkCall:dict2];
    
}

- (IBAction)dismissMenu:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(shouldUpdate)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMenu" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeMenuMap" object:nil];
        }
    }];
}

/*!
 * @brief Metodo llamado cuando se da clic a terminar de escoger ciudad
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)donePicker:(id)sender {
    
    // Se remueve de al interfaz el picker
    [self.buttonCity setTitle:[pickerData objectAtIndex:[self.pickerCity selectedRowInComponent:0]] forState:UIControlStateNormal];
    self.pickerCity.hidden = YES;
    self.toolBar.hidden=YES;
    
}

/*!
 * @brief Metodo llamado cuando se da clic al boton de ciudad
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonCity:(id)sender {
    
    // Se le presenta el picker de ciudad al usuario
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            self.scrollView.contentOffset = CGPointMake(0, ((UIButton*) sender ).frame.origin.y-35 );
                            
                        } completion:nil];
    
    pickerData = [[NSMutableArray alloc] init];
    [pickerData addObjectsFromArray:[genericComponets getCitiesArray]];
    self.pickerCity.hidden = NO;
    self.toolBar.hidden=NO;
    [self.pickerCity reloadAllComponents];
}

/*!
 * @brief Metodo llamado cuando se da clic al boton de guardar clave
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSavePass:(id)sender {
    
    //Se valida que las claves ingresadas sean correctas
    if([self.textOldPassword.text isEqualToString:@""] || [self.textNewPassword.text isEqualToString:@""] || [self.textRePassword.text isEqualToString:@""])
    {
        [self alertscreen:@"Error de actualización" :@"Ninguna de las contraseñas pueden ser vacias."];
    }
    else if(self.textNewPassword.text.length<6)
    {
        [self alertscreen:@"Error de actualización" :@"La contraseña debe ser mayor a 6 caracteres."];
    }
    else if(![self.textNewPassword.text isEqualToString:self.textRePassword.text])
    {
        [self alertscreen:@"Error de actualización" :@"Las contraseñas nuevas no coinciden."];
    }
    else
    {
        [self.view endEditing:YES];
        
        self.pickerCity.hidden = YES;
        self.toolBar.hidden=YES;
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        // Se llama el metodo de actualziacion de clave
        NSDictionary * dict2=@{@"function":@"client@updatePassword",
                               @"id_movil":[userDefaults objectForKey:@"id_movil"],
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios",
                               @"old":[genericComponets md5:self.textOldPassword.text],
                               @"new":[genericComponets md5:self.textNewPassword.text ],
                               @"confirm":[genericComponets md5:self.textRePassword.text ]};
        
        [self networkCall:dict2];
    }
}

/*!
 * @brief Metodo llamado cuando se da clic al boton de guardar clave
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSave:(id)sender {
    
    self.mcNombreText.text=[self.mcNombreText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.mcApellidoText.text=[self.mcApellidoText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //Se valida que los datos no vengan vacios
    if([self.mcNombreText.text isEqualToString:@""] || self.mcNombreText.text.length <3)
    {
        [self alertscreen:@"Error de Aactualizacion" :@"Por favor ingresar un nombre válido."];
    }
    else if([self.mcApellidoText.text isEqualToString:@""] || self.mcApellidoText.text.length <3)
    {
        [self alertscreen:@"Error de Registro" :@"Por favor ingresar un apellido válido."];
    }
    else if([self.buttonCity.titleLabel.text isEqualToString:@"Ciudad"])
    {
        [self alertscreen:@"Error de Registro" :@"Por favor seleccione una ciudad."];
    }
    else
    {
        [self.view endEditing:YES];
        
        self.pickerCity.hidden = YES;
        self.toolBar.hidden=YES;
        //Se llama el servicio de actulizacion de datos
        NSDictionary * dict=@{@"name":self.mcNombreText.text,
                              @"last_name":self.mcApellidoText.text,
                              @"id_mall":[genericComponets fixCity:self.buttonCity.titleLabel.text]};
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSDictionary * dict2=@{@"function":@"client@update",
                               @"id_movil":[userDefaults objectForKey:@"id_movil"],
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios",
                               @"basicInfo":dict};

        [self networkCall:dict2];

    }
    
    
}

/*!
 * @brief Metodo llamado cuando se da clic al boton cambiar preferencias
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonUpdateCategories:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"categories"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
    [sfvc setStateCatgories:nil];
    [sfvc changeBehaviorTipo:YES];
    
}

/*!
 * @brief Metodo llamado cuando se da clic al boton de cerrar sesion
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSignOut:(id)sender {
    
    //Se pregunta si quiere cerrar sesion
    UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"Información"
                                                    message:@"Está seguro de cerrar sesión?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar"
                                          otherButtonTitles:@"Sí", nil];
    [aView show];
}


#pragma mark - PickerDelegate

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //Si el usuario hace drag del scroll view, se esconden los controles.
    [self.view endEditing:YES];
    self.pickerCity.hidden = YES;
    self.toolBar.hidden=YES;
}

#pragma mark - Network Calls

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
        NSLog(@"Json envio Menu %@",aStr);
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
                NSLog(@"Json %@",json);
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
    
    [operation start];
}

/*!
 * @brief Metodo encargado de manejar la respeusta al servicio
 * @param json, Json con la respuesta
 * @return void
 */
-(void) handlerResponse:(NSDictionary *)json
{
    if(debug)
    {
        NSLog(@"Json %@",json);
    }
    // Se valida que metodo fue llamado
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@update"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de actualizacion datos");
            }
            [self alertscreen:@"Error de actualización" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {   
            
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            // Se actualiza los datos del usuario en las preferencias
            [userDefaults setObject:self.mcNombreText.text forKey:@"name"];
            [userDefaults setObject:self.mcApellidoText.text forKey:@"lastName"];
            [userDefaults setObject:[genericComponets fixCity:self.buttonCity.titleLabel.text] forKey:@"city_id"];
            [userDefaults setObject:self.buttonCity.titleLabel.text forKey:@"city_name"];
            
            [userDefaults synchronize];
            
            [self alertscreen:@"Información" :@"Actualización exitosa."];
            
            shouldUpdate=YES;
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@updatePassword"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de actualización password");
            }
            [self alertscreen:@"Error de actualización" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            // Se limpia la interfaz del usuario luego de actualizar la clave
            self.textOldPassword.text=@"";
            self.textNewPassword.text=@"";
            self.textRePassword.text=@"";
            [self alertscreen:@"Información" :@"La Contraseña ha sido cambiada."];
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@logout"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error al cerrar");
            }
            [self alertscreen:@"Error al cerrar sesión" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            // Se cierra sesion del usuario
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setBool:NO forKey:@"has_login"];
            [userDefaults synchronize];
            
            [self performSegueWithIdentifier:@"goToLogin" sender:self];
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"pqrs@storeMovil"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error al cerrar");
            }
            [self alertscreen:@"Error al enviar comentario" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            // Se confirma que el envio del PQRS fue exitoso
            self.textViewComment.text=@"";
            self.textSubject.text=@"";
            [self alertscreen:@"Información" :@"Se envió correctamente tu comentario."];
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"content@index"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error al cerrar");
            }
            [self alertscreen:@"Error al enviar comentario" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            NSDictionary *data=[json valueForKey:@"data"];
            
            // Se saca la informacion del Quienes somos par amostrarsela al usuario
            for(NSDictionary* d in data)
            {
                if([[d objectForKey:@"stag"] isEqualToString:@"#QUIENES SOMOS"])
                {
                    [self.webAbout loadHTMLString:[NSString stringWithFormat:@"<div align='justify' style='width:260;'>%@<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><div>",[d objectForKey:@"stagcontentios"] ] baseURL:nil];
                }
            }
            
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"app@share"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error al cerrar");
            }
            //[self alertscreen:@"Error al enviar comentario" :[json valueForKey:@"msg"]];
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

# pragma mark - Util

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    //Si el usuario da clic en que si desea cerrar sesion se hace logout del usuario
    if([title isEqualToString:@"Sí"])
    {
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSDictionary * dict2=@{@"function":@"client@logout",
                               @"id_movil":[userDefaults objectForKey:@"id_movil"],
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios"};
        
        [self networkCall:dict2];
    }
}

#pragma mark -segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Prepara el segue a la vista de promociones o eventos
    if ([[segue identifier] isEqualToString:@"goToPromFromMenu"]) {
        
        PromotionsViewController *vc = [segue destinationViewController];
        if(isPromotion)
        {
            [vc setTypeofView:@"promotions"];
        }
        else
        {
            [vc setTypeofView:@"events"];
        }
            
        
    }
}

#pragma mark - Tutorial

/*!
 * @brief Metodo llamado cuando se da clic al boton de ver tutorial
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonTutorial:(id)sender {
   
    //Se muestra el tutorial al usuario
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SliderViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"sliderTutorial"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:sfvc animated:YES completion:nil];
    [sfvc setCloseAction:YES];
    
}

#pragma mark - PQRS

/*!
 * @brief Metodo llamado cuando dan clic al boton de enviar PQRS
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonSendPqrs:(id)sender {
    
    self.textSubject.text=[self.textSubject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.textViewComment.text=[self.textViewComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Se hace la validacion de los campos obligatorios
    if([self.textSubject.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"El asunto es obligatorio."];
    }
    else if([self.textViewComment.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"Debes ingresar un comentario."];
    }
    else
    {
        [self.view endEditing:YES];
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        //Se hace el llamdo al servicio de envio de PQRS
        
        NSDictionary * dict2=@{@"function":@"pqrs@storeMovil",
                               @"id_movil":[userDefaults objectForKey:@"id_movil"],
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios",
                               @"subject":self.textSubject.text,
                               @"message":self.textViewComment.text};
        
        [self networkCall:dict2];
    }
    
}

#pragma mark - Delegates

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
     //Cuando el usuario selecciona una campo se mueve los elementos para que el tecaldo no los cubra.

    if(textView==self.textViewComment)
    {
        [UIView animateWithDuration:0.2 delay:0
                            options:UIViewAnimationOptionTransitionCurlDown animations:^{
                                
                                self.scrollView.contentOffset = CGPointMake(0, self.textViewComment.frame.origin.y+30 );
                                
                            } completion:nil];
        
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //Cuando el usuario selecciona una campo se mueve los elementos para que el tecaldo no los cubra.
    
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y+30 );
                            
                        } completion:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Cuando el usuario toca la pantalla hace dismiss del teclado
    
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            
                            self.scrollView.contentOffset = CGPointMake(0, 0 );
                            
                        } completion:nil];
    [self.view endEditing:YES];
    
    self.pickerCity.hidden = YES;
    self.toolBar.hidden=YES;
}

#pragma mark - another methods

/*!
 * @brief Metodo llamado ara definir que vista llamo el menu
 * @param ncaller, Boton seleccionado
 * @return void
 */
-(void) setViewCaller:(NSString*) ncaller
{
    caller=ncaller;
}
@end
