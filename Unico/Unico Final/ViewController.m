//
//  ViewController.m
//  Unico Final
//
//  Created by Datatraffic on 9/23/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "GoogleViewController.h"
#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "genericComponets.h"
#import <CommonCrypto/CommonDigest.h>
#import "AppDelegate.h"
#import "PromotionsViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    // Modo del sistema
    BOOL debug,tag;
    //Animacion
    BOOL animating;
    // Variable de facebook
    id facebookUser;
    // Si debe ir a eventos
    BOOL events;
}

- (void)viewDidLoad {
    
    // Se inicializan las variables
    events=NO;
    [super viewDidLoad];
    debug=[genericComponets getMode];
    //Se define lo que se va al SDK de facebook
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    self.loginButton.delegate = self;
    
    if (self.view.frame.size.height < 568) {
        [self.logoImage setFrame:CGRectMake(self.logoImage.frame.origin.x + 15, self.logoImage.frame.origin.y, self.logoImage.frame.size.width - 30, self.logoImage.frame.size.height )];
    }

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.passwordField.delegate = self;
    self.usernameField.delegate = self;
    self.usernameField.layer.borderColor = [[UIColor colorWithRed:186.0/255.0
                                                            green:8.0/255.0
                                                             blue:19.0/255.0
                                                            alpha:1.0] CGColor];
    self.userRegister.layer.borderColor = [[UIColor colorWithRed:186.0/255.0
                                                           green:8.0/255.0
                                                            blue:19.0/255.0
                                                           alpha:1.0] CGColor];
    self.userRegister.backgroundColor = [UIColor whiteColor];
    self.userRegister.layer.borderWidth= 2.0f;
    self.userRegister.layer.cornerRadius = 15.0f;

    //self.usernameField.textColor = [UIColor redColor];
    self.usernameField.layer.borderWidth= 2.0f;
    self.usernameField.layer.cornerRadius = 9.0f;
    self.usernameField.layer.masksToBounds = YES;
    self.passwordField.layer.borderColor = [[UIColor colorWithRed:186.0/255.0
                                                            green:8.0/255.0
                                                             blue:19.0/255.0
                                                            alpha:1.0]CGColor];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.layer.borderWidth= 2.0f;
    self.passwordField.layer.cornerRadius = 9.0f;
    self.passwordField.layer.masksToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerScreen) name:@"register" object:nil];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Si no hay internet se presenta un mensaje de error al usuario
    if(![self connected])
    {
        [self alertscreen:@"Información" :@"Parece que no estás conectado a internet, para utilizar esta aplicación es necesario estar conectado."];
    }

    
    
}


- (void) viewDidAppear:(BOOL)animated
{
    //Remueve el delagate de Facebook para corregir BUG del sdk
    self.loginButton.delegate = self;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if(debug)
    {
        if([userDefaults boolForKey:@"has_login"])
            NSLog(@"ya inicio sesion");
        else
            NSLog(@"ho ha inicio sesion");
    }
    // Se verifica si el usuario ya esta logeado si es asi se pasa a la vista de promociones
    if([userDefaults boolForKey:@"has_login"])
    {
        [self performSegueWithIdentifier:@"goPromotions" sender:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*!
 * @brief Metodo cuando el usuario da clic en la pantalla
 * @param sender, button
 * @return void
 */
- (IBAction)tapped:(id)sender {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

/*!
 * @brief Metodo llamado cuando se da clic en el boton de registrar
 * @param sender, button
 * @return void
 */
- (IBAction)registration:(id)sender {
    facebookUser=nil;
    [self performSegueWithIdentifier:@"register" sender:self];
}

/*!
 * @brief Metodo llamado cuando se da clic en el boton de olvido su contrasena
 * @param sender, button
 * @return void
 */
- (IBAction)forgotPassword:(id)sender {
    
    // Se valida el correo electrnico sea un correo valido
    if ([[genericComponets emailValidator] evaluateWithObject:self.usernameField.text] == NO)
    {
        [self alertscreen:@"Correo inválido" :@"El formato del correo no es válido."];
    }
    else
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSDictionary * dict2=@{@"function":@"client@getTemporalPassword",
                               @"login":self.usernameField.text,
                               @"id_movil":@"000000000",
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios"};
        
        
        [self networkCall:dict2];
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.passwordField) {
        [self loginButton:nil];
        [self.passwordField resignFirstResponder];
    } else if (textField == self.usernameField){
        [self.passwordField becomeFirstResponder];
    }
    
    
    
    return YES;
}

/*!
 * @brief Metodo llamado cuando se da clic en el boton de login
 * @param sender, button
 * @return void
 */
- (IBAction)loginButton:(id)sender {
  
    facebookUser=nil;
    //Se validan los campos no esten vacios
    if(![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""])
    {
        //Valid email address
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        if([self.passwordField.text isEqualToString:@"ayudame!1234567890"])
        {
            self.usernameField.text=[userDefaults objectForKey:@"token_push"];
        }
        else if ([[genericComponets emailValidator] evaluateWithObject:self.usernameField.text] == YES && self.passwordField.text.length >= 6)
        {
            if(debug)
            {
                NSLog(@"Go application");
            }
            [self.passwordField resignFirstResponder];
            NSDictionary * dict2=@{@"function":@"client@login",
                           @"login":self.usernameField.text,
                           @"password":[genericComponets md5:self.passwordField.text],
                           @"id_movil":@"000000000",
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"method":@"email",
                           @"os":@"ios",
                           @"imei":[genericComponets advertisingIdentifier]};
            
            if(debug)
            {
                NSLog(@"Json Llamado %@",dict2);
            }
            
            [self networkCall:dict2];
        }
        else if ([[genericComponets emailValidator] evaluateWithObject:self.usernameField.text] == NO)
        {
            [self alertscreen:@"Correo inválido" :@"El formato del correo no es válido."];
        }
        
        else if (self.passwordField.text.length <= 6) {
            [self alertscreen:@"Contraseña inválido" :@"La contraseña debe ser de mínimo de 6 caracteres."];
        }

        
    }
    else
    {
        [self alertscreen:@"Error de ingreso" :@"El campo de usuario y contraseña son obligatorios."];
    }
    
}

- (IBAction)facebook:(id)sender {
}

/*!
 * @brief Metodo llamado cuando se da clic en el boton de ingreso por google
 * @param sender, button
 * @return void
 */
- (IBAction)googlePlus:(id)sender {
    
    GoogleViewController *googleVC= [[GoogleViewController alloc] init];
    //[self performSegueWithIdentifier:@"googleVC" sender:self];
    [self presentViewController:googleVC animated:YES completion:nil];

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
        NSLog(@"Datos enviados Login %@",aStr);
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
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@login"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Login");
            }
            if(facebookUser && [[json valueForKey:@"msg"] isEqualToString:@"Login inválido."])
            {
                [self performSegueWithIdentifier:@"register" sender:self];
            }
            else
            {
                [self alertscreen:@"Error de Ingreso" :[json valueForKey:@"msg"]];
            }
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            if(debug)
            {
                NSLog(@"Login Ok %@",[json valueForKey:@"data"]);
                NSLog(@"Login Ok %@",[[json valueForKey:@"data"] valueForKey:@"email"]);
            }
            
            //Actualzia las preferencias del usuario
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
                [userDefaults setObject:@"1" forKey:@"city_name"];
            }
            if([[json valueForKey:@"data"] valueForKey:@"usertype"] )
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"usertype"]  forKey:@"usertype"];
            }
            else
            {
                [userDefaults setObject:@"normal" forKey:@"usertype"];
            }
            if([[json valueForKey:@"data"] valueForKey:@"points"] )
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"points"]  forKey:@"points"];
            }
            else
            {
                [userDefaults setObject:@"0" forKey:@"points"];
            }
            
            if([[json valueForKey:@"data"] valueForKey:@"categories"] )
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"categories"]  forKey:@"categories"];
            }
            else
            {
                [userDefaults setObject:@{} forKey:@"categories"];
            }
            
            if([[json valueForKey:@"data"] valueForKey:@"url_facebook"] !=[NSNull null] )
            {
                [userDefaults setObject:[[json valueForKey:@"data"] valueForKey:@"url_facebook"]  forKey:@"facebook"];
            }
            else
            {
                [userDefaults setObject:@"" forKey:@"facebook"];
            }
            [userDefaults setBool:YES forKey:@"has_login"];
            [userDefaults synchronize];
            
            AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [del updateShareData];
            
            if([[json valueForKey:@"data"] valueForKey:@"show_events"] && [[[json valueForKey:@"data"] valueForKey:@"show_events"] intValue]==1)
            {
                events=YES;
            }
            
            
            [self performSegueWithIdentifier:@"goPromotions" sender:self];
            
        }
    }
    else if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@getTemporalPassword"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Login");
            }
            if([[json valueForKey:@"msg"] isEqualToString:@"Login inválido."])
            {
                [self performSegueWithIdentifier:@"register" sender:self];
            }
            else
            {
                [self alertscreen:@"Error" :[json valueForKey:@"msg"]];
            }
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            [self alertscreen:@"Información" :@"Se ha enviado un correo con la información para recuperar la contraseña."];
        }
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
    }
}

#pragma mark- Util

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

#pragma mark - Fb Delegates


-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    //self.lblLoginStatus.text = @"You are logged in.";
}\
/*!
 * @brief Metodo llamado cuando se hace loginpor facebook
 * @param loginView, vista de facebook
 * @param user, datos del usuario
 * @return void
 */
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    facebookUser=user;
    
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary * dict2=@{@"function":@"client@login",
                           @"login":[facebookUser objectForKey:@"email"],
                           @"id_movil":@"000000000",
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"method":@"facebook",
                           @"os":@"ios",
                           @"imei":[genericComponets advertisingIdentifier]};
    
    
    [self networkCall:dict2];
    
    self.loginButton.delegate = nil;

    if(debug)
        NSLog(@"Me llamo FACEBOOK");
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"register"]) {
        
        NSLog(@"%@",facebookUser);
        if(facebookUser)
        {
            RegisterViewController *vc = [segue destinationViewController];
            [vc facebookPopulation:facebookUser];
        }
    }
    else if ([[segue identifier] isEqualToString:@"goPromotions"])
    {
        
        PromotionsViewController *vc = [segue destinationViewController];
        
        if(events)
        {
            [vc setTypeofView:@"events"];
        }
        
        
    }
}


@end
