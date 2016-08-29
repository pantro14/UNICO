//
//  RegisterViewController.m
//  Unico Final
//
//  Created by Datatraffic on 10/2/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "genericComponets.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController{
    BOOL hideCheck;
    // Modo de la vista
    BOOL debug;
    // Array con los datos del picker
    NSMutableArray *pickerData;
    //El valor de la ciudad
    NSString *displayCity;
    //Indica si aceptaron los terminos
    BOOL accepted;
    //Informacion de Facebook
    id facebookInfo;
}

- (void)viewDidLoad {
    
    // Se inicializan todos los valores
    hideCheck = YES;
    displayCity = @"city";
    accepted = NO;
    debug=YES;
    [self setNeedsStatusBarAppearanceUpdate];
    self.scrollView.delegate = self;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.pickerSelection.backgroundColor = [UIColor whiteColor];
    [self.pickerSelection setDelegate:self];
    self.pickerSelection.dataSource = self;
    self.name.delegate=self;
    self.lastName.delegate=self;
    self.email.delegate=self;
    self.cedula.delegate=self;
    self.password.delegate=self;
    self.repassword.delegate=self;
    
    [super viewDidLoad];
    self.registerButtonProp.backgroundColor = [UIColor colorWithRed:186.0/255.0
                                                              green:8.0/255.0
                                                               blue:19.0/255.0
                                                              alpha:1.0];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 600);
    
    //Si viene informacion de facebook se carga
    if(facebookInfo)
    {
        self.name.text=[facebookInfo objectForKey:@"first_name"];
        self.name.enabled=NO;
        self.lastName.text=[facebookInfo objectForKey:@"last_name"];
        self.lastName.enabled=NO;
        self.email.text=[facebookInfo objectForKey:@"email"];
        self.email.enabled=NO;
        [self.genderButton setTitle:[genericComponets fixGenderFB:[facebookInfo objectForKey:@"gender"]] forState:UIControlStateNormal];
        self.password.enabled=NO;
        self.password.placeholder=@"No requerida facebook Login";
        self.repassword.enabled=NO;
        self.repassword.placeholder=@"No requerida facebook Login";
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-18];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-100];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
   
    NSLog(@"%@ %@",minDate,maxDate);
    
    [self.datePicker setMaximumDate:minDate];
    [self.datePicker setMinimumDate:maxDate];
    
    // Touch event para label de "Terminos y Condiciones"
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTerminosPopup)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_terminos addGestureRecognizer:tapGestureRecognizer];
    _terminos.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Buttons Actions

/*!
 * @brief Metodo llamado cuando tocan el boton de registo
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)registerButton:(id)sender {
    
    self.name.text=[self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.lastName.text=[self.lastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.email.text=[self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.cedula.text=[self.cedula.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Se valida que todos los datos se ingresen
    if([self.name.text isEqualToString:@""] || self.name.text.length <3)
    {
        [self alertscreen:@"Error de Registro" :@"Por favor ingresar un nombre válido."];
    }
    else if([self.lastName.text isEqualToString:@""] || self.lastName.text.length <3)
    {
        [self alertscreen:@"Error de Registro" :@"Por favor ingresar un apellido válido."];
    }
    else if([[genericComponets emailValidator] evaluateWithObject:self.email.text] == NO)
    {
        [self alertscreen:@"Error de Registro" :@"Por favor ingresar un email válido."];
    }
    else if([self.cityButton.titleLabel.text isEqualToString:@"Ciudad"])
    {
        [self alertscreen:@"Error de Registro" :@"Por favor seleccione una ciudad."];
    }
    /*else if([self.genderButton.titleLabel.text isEqualToString:@"Genero"])
    {
        [self alertscreen:@"Error de Registro" :@"Por favor seleccione si genero."];
    }
    else if([self.dateOfBirthButton.titleLabel.text isEqualToString:@"Fecha"])
    {
        [self alertscreen:@"Error de Registro" :@"Por favor seleccione una fecha de Nacimiento."];
    }*/
    else if(self.cedula.text.length >0 && (self.cedula.text.length <5 || self.cedula.text.length > 12))
    {
        [self alertscreen:@"Error de Registro" :@"Por favor ingresar una cédula válida."];
    }
    else if(([self.password.text isEqualToString:@""] || [self.repassword.text isEqualToString:@""]) && !facebookInfo)
    {
        [self alertscreen:@"Error de Registro" :@"Por favor ingresar una contraseña válida."];
    }
    else if([self.password.text length] <6 && !facebookInfo)
    {
        [self alertscreen:@"Error de Registro" :@"Por favor ingresar una contraseña válida, debe tener mínimo 6 caracteres."];
    }
    else if((![self.password.text isEqualToString:self.repassword.text])&& !facebookInfo)
    {
        [self alertscreen:@"Error de Registro" :@"Las contraseñas no coinciden."];
    }
    else if(accepted)
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
        
                        
        [dict setObject:self.email.text forKey:@"email"];
        [dict setObject:self.name.text forKey:@"name"];
        [dict setObject:self.lastName.text forKey:@"last_name"];
        [dict setObject:@"1" forKey:@"id_document_type"];
        
        if ([self.cedula.text isEqualToString:@""]) {
            [dict setObject:@"0" forKey:@"document"];
        } else {
            [dict setObject:self.cedula.text forKey:@"document"];
        }
        
        [dict setObject:[genericComponets fixCity:self.cityButton.titleLabel.text] forKey:@"id_mall"];
        
        [dict setObject:[genericComponets fixGender:self.genderButton.titleLabel.text] forKey:@"sex"];
        
        NSString *nacimiento = self.dateOfBirthButton.titleLabel.text;
        [dict setObject:([nacimiento isEqualToString:@"No definido"] || [nacimiento isEqualToString:@"Fecha"]? [NSNull null] : nacimiento) forKey:@"ts_birthday"];
        
        if(facebookInfo)
        {
            [dict setObject:[facebookInfo objectForKey:@"link"] forKey:@"facebook"];
        }
        else
        {
            [dict setObject:[genericComponets md5:self.password.text] forKey:@"user_password"];
            [dict setObject:[genericComponets md5:self.repassword.text] forKey:@"password_confirm"];
        }
        
        // Se hace el llamado al servicio de registro
        NSDictionary * dict2=@{@"function":@"client@register",
                               @"id_movil":@"000000000",
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios",
                               @"imei":[genericComponets advertisingIdentifier],
                               @"basicInfo":dict};
        
        [self networkCall:dict2];
    }
    else
    {
        
        [self alertscreen:@"Error de Registro" :@"Por favor debe aceptar los términos y condiciones"];
    }
}

- (IBAction)tapped:(id)sender {
 //   [self.view resignFirstResponder];
}

/*!
 * @brief Metodo llamado cuando tocan el boton cerrar la vista
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)backToLogin:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*!
 * @brief Metodo llamado cuando tocan el check box de terminos
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)tappedCheck:(id)sender {
    
    if(accepted)
    {
        [sender setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"checkboxChecked.png"] forState:UIControlStateNormal];
    }
    accepted=!accepted;
    
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
        NSLog(@"Json envio REgistro %@",aStr);
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
        [self alertscreen:@"Error" :@"Ocurrio un problema de comunicación."];
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
    //Se valida el servicio que es llamado
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@register"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Registro");
            }
            [self alertscreen:@"Error de Registro" :[json valueForKey:@"msg"]];
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            if(debug)
            {
                NSLog(@"Register Ok %@",[json valueForKey:@"data"]);
                NSLog(@"REgister Ok %@",[[json valueForKey:@"data"] valueForKey:@"email"]);
            }
            
            //Se actualizan las preferencias del usuario
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[json valueForKey:@"id_movil"] forKey:@"id_movil"];
            if([[json valueForKey:@"data"] valueForKey:@"email"])
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"email"] forKey:@"email"];
            }
            else
            {
                [userDefaults setObject:@"" forKey:@"email"];
            }
            
            if([[json valueForKey:@"data"] valueForKey:@"name"])
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"name"] forKey:@"name"];
            }
            else
            {
                [userDefaults setObject:@"" forKey:@"name"];
            }
            
            if([[json valueForKey:@"data"] valueForKey:@"last_name"])
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"last_name"] forKey:@"lastName"];
            }
            else
            {
                [userDefaults setObject:@"" forKey:@"lastName"];
            }
            
            if([[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"nreference"])
            {
                [userDefaults setObject:[[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"nreference"]  forKey:@"city_id"];
            }
            else
            {
                [userDefaults setObject:@"1" forKey:@"city_id"];
            }
            
            if([[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"sname"])
            {
                [userDefaults setObject:[[[json valueForKey:@"data"] valueForKey:@"mall"] objectForKey:@"sname"]  forKey:@"city_name"];
            }
            else
            {
                [userDefaults setObject:@"Cali" forKey:@"city_name"];
            }
            
            if([[json valueForKey:@"data"] valueForKey:@"usertype"] )
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"usertype"]  forKey:@"usertype"];
            }
            else
            {
                [userDefaults setObject:@"normal" forKey:@"usertype"];
            }
            
            if([[json valueForKey:@"data"] valueForKey:@"url_facebook"]!=[NSNull null]  )
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"url_facebook"]  forKey:@"facebook"];
            }
            else
            {
                [userDefaults setObject:@"" forKey:@"facebook"];
            }
            
            
            [userDefaults setObject:@"0" forKey:@"points"];
            [userDefaults setObject:@{} forKey:@"categories"];
            [userDefaults setBool:YES forKey:@"has_login"];
            
            if([[json valueForKey:@"data"] valueForKey:@"show_events"] && [[[json valueForKey:@"data"] valueForKey:@"show_events"] intValue]==1)
            {
                if(debug)
                {
                    NSLog(@"Ingreso a eventos");
                }
                [userDefaults setBool:YES forKey:@"show_events"];
                
            }
            else
            {
                [userDefaults setBool:NO forKey:@"show_events"];
            }
            
            [userDefaults synchronize];
            // Se rediriege al usuario a la seleccion del categorias
            [self performSegueWithIdentifier:@"categorySelection" sender:self];
            
        }
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
    }
}

#pragma mark - Pickers

/*!
 * @brief Metodo llamado cuando tocan el boton de finalizacion de seleccion
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)donePicker:(id)sender {
    
    self.pickerSelection.hidden = YES;
    self.toolBarPicker.hidden = YES;
    
    [self.pickerSelection resignFirstResponder];
    
    hideCheck=YES;
    self.datePicker.hidden = YES;
    [self.datePicker resignFirstResponder];
    // Se verifica que picker fue seleccionado
    if([displayCity isEqualToString:@"city"])
    {
        [self.cityButton setTitle:[pickerData objectAtIndex:[self.pickerSelection selectedRowInComponent:0]] forState:UIControlStateNormal];
    }
    else if([displayCity isEqualToString:@"gender"])
    {
        [self.genderButton setTitle:[pickerData objectAtIndex:[self.pickerSelection selectedRowInComponent:0]] forState:UIControlStateNormal];
    }
    else if([displayCity isEqualToString:@"date"])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [self.dateOfBirthButton setTitle:[formatter stringFromDate:[self.datePicker date]] forState:UIControlStateNormal];
    }
}

/*!
 * @brief Metodo llamado cuando tocan el boton de finalizacion de seleccion para limpiar
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)cleanPicker:(id)sender {
    
    self.pickerSelection.hidden = YES;
    self.toolBarPicker.hidden = YES;
    
    [self.pickerSelection resignFirstResponder];
    
    hideCheck=YES;
    self.datePicker.hidden = YES;
    [self.datePicker resignFirstResponder];
    // Se verifica que picker fue seleccionado
    if([displayCity isEqualToString:@"city"])
    {
        //
    }
    else if([displayCity isEqualToString:@"gender"])
    {
        [self.genderButton setTitle:@"No definido" forState:UIControlStateNormal];
    }
    else if([displayCity isEqualToString:@"date"])
    {
        [self.dateOfBirthButton setTitle:@"No definido" forState:UIControlStateNormal];
    }
}

/*!
 * @brief Metodo llamado cuando tocan el boton seleccionar una ciudad
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)citySelection:(id)sender {
    displayCity = @"city";
    pickerData = [[NSMutableArray alloc] init];
    [pickerData addObjectsFromArray:[genericComponets getCitiesArray]];
    self.datePicker.hidden=YES;
    
        [self.view endEditing:YES];
        self.pickerSelection.hidden = NO;
        self.toolBarPicker.hidden=NO;
        [self.pickerSelection reloadAllComponents];
        hideCheck = NO;
        //pickerData = ;
    
    [self showingClearButton:YES];
}

/*!
 * @brief Metodo llamado cuando tocan el boton seleccionar un genero
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)genderSelection:(id)sender {
    displayCity = @"gender";
    pickerData = [[NSMutableArray alloc] init];
     [pickerData addObjectsFromArray:[genericComponets getGenderArray]];
    self.datePicker.hidden=YES;
    
    [self.view endEditing:YES];
    self.pickerSelection.hidden = NO;
    self.toolBarPicker.hidden=NO;
    [self.pickerSelection reloadAllComponents];
    hideCheck = NO;
    
    [self showingClearButton:NO];
}

/*!
 * @brief Metodo llamado cuando tocan el boton de seleccionar una fecha de nacimiento
 * @param sender, boton seleccionado
 * @return IBAction
 */
- (IBAction)dateOfBirthSelection:(id)sender {
    displayCity=@"date";
    
    [self.view endEditing:YES];
    self.toolBarPicker.hidden = NO;
    self.datePicker.hidden = NO;
    self.pickerSelection.hidden = YES;
    hideCheck = NO;
    
    [self showingClearButton:NO];
}

- (void)showingClearButton:(bool)hide {
    NSMutableArray *toolbarButtons = [self.toolBarPicker.items mutableCopy];
    
    if(hide) {
        [toolbarButtons removeObject:self.clearButton];
    } else if(![toolbarButtons containsObject:self.clearButton]) {
        [toolbarButtons insertObject:self.clearButton atIndex:0];
    }
    
    [self.toolBarPicker setItems:toolbarButtons animated:NO];
}

#pragma Pickers delagates

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


-(UIStatusBarStyle)preferredStatusBarStyle{
    //Se cambia el color de la barra superior
    return UIStatusBarStyleLightContent;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    //Se implementa el metodo para que el sistema avance al dar clic en siguiente/next
    NSInteger nextTag = textField.tag + 1;
    
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    
    if(nextTag==7)
    {
        [UIView animateWithDuration:0.2 delay:0
                            options:UIViewAnimationOptionTransitionCurlDown animations:^{
                                
                                
                                self.scrollView.contentOffset = CGPointMake(0, 0 );
                                
                            } completion:nil];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - Util

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //Mueve el scroll view para que el teclado no tape los campos de texto
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                           
                            self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y-35 );
                            
                        } completion:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //Si el usuario toca la pantalla y estaba editando, oculta el teclado
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            
                            self.scrollView.contentOffset = CGPointMake(0, 0 );
                            
                        } completion:nil];
    [self.view endEditing:YES];
    self.datePicker.hidden=YES;
    self.pickerSelection.hidden = YES;
    self.toolBarPicker.hidden=YES;
}

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

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //Mueve el scroll view para que el teclado no tape los campos de texto
    [self.view endEditing:YES];
    self.datePicker.hidden=YES;
    self.pickerSelection.hidden = YES;
    self.toolBarPicker.hidden=YES;

}

# pragma mark - Other Methos

/*!
 * @brief Metodo llamado el login es realizado por facebook
 * @param userInfo, diccionario con los datos de facebook
 * @return void
 */
- (void) facebookPopulation:(id) userInfo
{
    if(debug)
        NSLog(@"fb %@",userInfo);
    
    facebookInfo=userInfo;
    
}

- (IBAction)momentoButton:(id)sender {
    [self.momentoUnicoPopup setHidden:YES];
}

- (void)showTerminosPopup {
    [_terminosCondicionesPopup setHidden:NO];
}

- (IBAction)closeTerminos:(id)sender {
    [_terminosCondicionesPopup setHidden:YES];
}



@end
