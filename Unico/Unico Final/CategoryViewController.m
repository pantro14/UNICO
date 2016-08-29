//
//  CategoryViewController.m
//  Unico Final
//
//  Created by Datatraffic on 10/7/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "CategoryViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "genericComponets.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController
{
    // Lista de las Categorias
    NSMutableArray *categories;
    // Tipo de visualizacion
    BOOL typeCategorias;
    //Tipo de Menu
    BOOL typeMenu;
    // Modo de la Vista
    BOOL debug;
    // Array de categorias en formato json
    NSMutableArray * dictU;
    // Caller a ser llamado
    NSString* caller;
}

- (void)viewDidLoad {
    
    // Carga los iconos en al interfaz segun el tamano de la pantalla
    if (self.view.frame.size.height < 568){
        
    
    for (int i=0; i<[self.categoriesButtons count]; i++)
    {
        [[self.categoriesButtons objectAtIndex:i] setFrame:CGRectMake(((UIButton*)[self.categoriesButtons objectAtIndex:i]).frame.origin.x + 12, ((UIButton*)[self.categoriesButtons objectAtIndex:i]).frame.origin.y, ((UIButton*)[self.categoriesButtons objectAtIndex:i]).frame.size.height * 0.76, ((UIButton*)[self.categoriesButtons objectAtIndex:i]).frame.size.height)];
        
    }
    
    }
    
    // Pone la imagen de backgorund
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    // Se obtiene le modo del sistema
    debug=[genericComponets getMode];
    // Inicializa el arreglo de categotias
    categories = [[NSMutableArray alloc] init];
    [categories insertObject:@"NO" atIndex:0];
    [categories insertObject:@"NO" atIndex:1];
    [categories insertObject:@"NO" atIndex:2];
    [categories insertObject:@"NO" atIndex:3];
    [categories insertObject:@"NO" atIndex:4];
    [categories insertObject:@"NO" atIndex:5];
    [categories insertObject:@"NO" atIndex:6];
    [categories insertObject:@"NO" atIndex:7];
    [categories insertObject:@"NO" atIndex:8];
    [categories insertObject:@"NO" atIndex:9];
    typeCategorias=YES;
    typeMenu=NO;
    caller=@"closeCategories";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*!
 * @brief Metodo establecer que categorias estan seleccionadas
 * @param input, Array con la lsita de categorias seleccioandas
 * @return void
 */
- (void) setStateCatgories:(NSMutableArray *) input
{
    
    if(input)
    {
        categories=input;
    }
    else
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSDictionary * catUser=[userDefaults objectForKey:@"categories"];
        categories = [[NSMutableArray alloc] init];
        [categories insertObject:@"NO" atIndex:0];
        [categories insertObject:@"NO" atIndex:1];
        [categories insertObject:@"NO" atIndex:2];
        [categories insertObject:@"NO" atIndex:3];
        [categories insertObject:@"NO" atIndex:4];
        [categories insertObject:@"NO" atIndex:5];
        [categories insertObject:@"NO" atIndex:6];
        [categories insertObject:@"NO" atIndex:7];
        [categories insertObject:@"NO" atIndex:8];
        [categories insertObject:@"NO" atIndex:9];
        
        for(NSDictionary *promDict in catUser){
            [categories replaceObjectAtIndex:([[promDict objectForKey:@"nreference"] intValue]-1) withObject:@"YES"];
        }
        
    }
    
    // Actualzia la interfaz con la informacion
    for (int i=0; i<[categories count]; i++)
    {
        if([[categories objectAtIndex:i] isEqualToString:@"YES"])
        {
            [[self.categoriesButtons objectAtIndex:i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d_pressed.png",(i+1)]] forState:UIControlStateNormal];
        }
        else
        {
            [[self.categoriesButtons objectAtIndex:i] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d.png",(i+1)]] forState:UIControlStateNormal];
        }
        
    }
}

/*!
 * @brief Metodo que retorna las categorias seleccionadas
 * @return NSMutableArray
 */
- (NSMutableArray *) getStateCategories
{
    return [categories mutableCopy];
}

/*!
 * @brief Metodo que define el tipo de comportamiento de la vista (Tipo Perfilamiento o tipo filtro)
 * @param nType, Tipo de Vista
 * @return void
 */
- (void) changeBehaviorTipo:(BOOL) nType
{
    
    typeMenu=nType;
    
    if(!typeMenu)
    {
        //self.categoriesTitle.hidden=YES;
        self.categoriesTitle.text=@"Filtro por Categorías";
        typeCategorias=NO;
        self.buttonCancel.hidden=NO;
        self.buttonOk.frame=CGRectMake(84, self.buttonOk.frame.origin.y, self.buttonOk.frame.size.width,self.buttonOk.frame.size.height);
    }
}

/*!
 * @brief Metodo para definir el mensaje a ser llamado cuando termine la ejecucion de la vista
 * @param nCaller, nombre del mensaje
 * @return void
 */
- (void) setCaller:(NSString*) nCaller
{
    caller=nCaller;
}

/*!
 * @brief Metodo llamado cuando seleccionan una categoria
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchCategory:(id)sender {
    
    if(debug)
    {
        NSLog(@"presionado %d %@",[sender tag],[categories objectAtIndex:([sender tag]-1)]);
    }
    // valoda si selecciono o deseselecciono la categoria
    if([[categories objectAtIndex:([sender tag]-1)] isEqualToString:@"YES"])
    {
        [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d.png",[sender tag]]] forState:UIControlStateNormal];
         [categories replaceObjectAtIndex:([sender tag]-1) withObject:@"NO"];
    }
    else
    {
        [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon%d_pressed.png",[sender tag]]] forState:UIControlStateNormal];
         [categories replaceObjectAtIndex:([sender tag]-1) withObject:@"YES"];
    }
    
}

/*!
 * @brief Metodo llamado cuando precionan el boton Close
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)close:(id)sender {
    
    if(typeCategorias)
    {
        [self performSegueWithIdentifier:@"goingOut" sender:self];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:caller object:nil];
        }];
    }
    
}

/*!
 * @brief Metodo llamado cuando precionan el boton Ok
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)okButton:(id)sender {
    
    if(typeCategorias)
    {
        dictU=[[NSMutableArray alloc] init];
        
        for (int i=0; i<[categories count]; i++)
        {
            
            if([[categories objectAtIndex:i] isEqualToString:@"YES"])
            {
                [dictU addObject:@{@"nreference":[NSString stringWithFormat:@"%d",(i+1)]}];
            }
        }
        
        //Para el caso de perfilamiento se hace el llamdo al servicio de actualizacion de datos
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSDictionary * dict2=@{@"function":@"client@updatePreferences",
                               @"id_movil":[userDefaults objectForKey:@"id_movil"],
                               @"token_push":[userDefaults objectForKey:@"token_push"],
                               @"os":@"ios",
                               @"basicInfo":@{@"categories":dictU}};
        
        [self networkCall:dict2];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
        
            [[NSNotificationCenter defaultCenter] postNotificationName:caller object:[categories mutableCopy]];
        }];
    }

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
    
    NSDictionary * final=@{@"information":aStr};
    
    if(debug)
    {
        NSLog(@"peticion Categorias %@",aStr);
    }
    
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
    
    [operation start];
}

/*!
 * @brief Metodo encargado de manejar la respeusta al servicio
 * @param json, Json con la respuesta
 * @return void
 */
-(void) handlerResponse:(NSDictionary *)json
{
    // Se calida que servicio fue llamado
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"client@updatePreferences"])
    {
        if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==1)
        {
            if(debug)
            {
                NSLog(@"Error de Registro");
            }
            
            [self alertscreen:@"Error de Registro" :[json valueForKey:@"msg"]];
            
            // Realiza la accion segun sea el caso
            if(!typeMenu)
            {
                [self performSegueWithIdentifier:@"goingOut" sender:self];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else if([json valueForKey:@"error"] && [[json valueForKey:@"error"] intValue]==0)
        {
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dictU forKey:@"categories"];
            [userDefaults synchronize];
            
            // Realiza la accion segun sea el caso
            if(!typeMenu)
            {
                [self performSegueWithIdentifier:@"goingOut" sender:self];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
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
