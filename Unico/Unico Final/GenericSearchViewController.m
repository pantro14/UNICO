//
//  GenericSearchViewController.m
//  Unico Final
//
//  Created by Francisco Garcia on 11/8/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "GenericSearchViewController.h"
#import "GenericSearchTableViewCell.h"
#import "genericComponets.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "ModelEvent.h"
#import "ModelStore.h"
#import "ModelBrand.h"

@interface GenericSearchViewController ()

@end

@implementation GenericSearchViewController{
    
    // cola de peticiones
    NSOperationQueue *queue;
    // Modo de la vista
    BOOL debug;
    //  Texto de busqueda
    NSString* querySearch;
    //  Array contenedor
    NSMutableArray *container;
    // Tipo de la vista
    NSString* type;
    // Mensaje a ser llamado
    NSString* caller;

}

- (void)viewDidLoad {
    
    queue=[[NSOperationQueue alloc]init];
    
    debug=[genericComponets getMode];
    
    querySearch=@"";
    
    if(!type)
    {
        type=@"event";
    }
    
    container = [[NSMutableArray alloc] init];
    
    self.textSearch.delegate=self;
    
    [super viewDidLoad];
    
    //Segun el tipo se coloca el titulo de la vista
    if([type isEqualToString:@"brand"])
    {
        self.labelTitle.text=@"Realiza la Búsqueda de marcas";
    }
    else if([type isEqualToString:@"store"])
    {
        self.labelTitle.text=@"Realiza la Búsqueda de tiendas";
    }
    else if([type isEqualToString:@"event"])
    {
        self.labelTitle.text=@"Realiza la Búsqueda de eventos";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"GenericSearchCellView";
    GenericSearchTableViewCell *cell = (GenericSearchTableViewCell *) [self.tableResults dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"GenericSearchCellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // Se muestra el contenido segun el tipo de la vista
    if([container count]>indexPath.row)
    {
        if([type isEqualToString:@"store"])
        {
            cell.labelResult.text = [[container objectAtIndex:indexPath.row] storeName];
            
        }
        else if([type isEqualToString:@"event"])
        {
            cell.labelResult.text = [[container objectAtIndex:indexPath.row] eventName];
            
        }
        else if([type isEqualToString:@"brand"])
        {
            cell.labelResult.text = [[container objectAtIndex:indexPath.row] brandName];
            
        }
        if(indexPath.row%2==0)
        {
            cell.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Manejo de seleccion
    
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        id object = [container objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:caller object:object];
    }];
    
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
            // se limpia la lista de resultados
            [self cleanListWithActual];
            
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
    
    [queue addOperation:operation];
}

/*!
 * @brief Metodo llamado cuando se quieren cargar mas resultados
 * @param query, texto de busqueda
 * @return void
 */
- (void) loadMoreRowsByQuery:(NSString*)query
{
    querySearch=query;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSDictionary * dict=@{@"property":@"nreference",
                          @"direction":@"ASC"};
    
    NSMutableArray* dictU=[[NSMutableArray alloc] init];
    
    [dictU addObject:@{@"field":@"nmall",@"value":[userDefaults objectForKey:@"city_id"],@"type":@"numeric",@"comparison":@"eq"}];
    
    if(![query isEqualToString:@""])
    {
        [dictU addObject:@{@"field":@"sname",@"value":query,@"type":@"string"}];
    }
    // se hace el llamado al servicio de busqueda
    NSDictionary * dict2=@{@"function":[NSString stringWithFormat:@"%@@index",type ],
                           @"id_movil":[userDefaults objectForKey:@"id_movil"],
                           @"token_push":[userDefaults objectForKey:@"token_push"],
                           @"os":@"ios",
                           @"latitud":@"0.000",
                           @"longitud":@"-0.0000",
                           @"page":@"1",
                           @"limit":[genericComponets getStoresPerLoad],
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
    // Se verifica que metodo fue llamado
    if([json valueForKey:@"function"] && ([[json valueForKey:@"function"] isEqualToString:@"store@index"]  || [[json valueForKey:@"function"] isEqualToString:@"event@index"] || [[json valueForKey:@"function"] isEqualToString:@"brand@index"]))
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
            
            for(NSDictionary *genDict in data){
                
                id temp;
                if([type isEqualToString:@"store"])
                {
                    temp= [[ModelStore alloc] init];
                    
                }
                else if([type isEqualToString:@"event"])
                {
                    temp= [[ModelEvent alloc] init];
                    
                }
                else if([type isEqualToString:@"brand"])
                {
                    temp= [[ModelBrand alloc] init];
                    
                }
                //Se cargan los datos
                [temp populateWithJson:genDict];
                
                [container addObject:temp];
                
                cont++;
            }
            if(debug)
            {
                NSLog(@"Filas resultados %d",cont);
            }
            if(cont>0)
            {
                self.tableResults.hidden=NO;
            }
            else
            {
                self.tableResults.hidden=YES;
            }
            //Se refresca la tabla
            [self.tableResults reloadData];
            
            
        }
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
    }
}

#pragma mark - Text Delegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    // Se captura el texto buscado
    if([string isEqualToString:@""])
    {
        querySearch=[textField.text substringToIndex:[textField.text length] - 1];
        
    }
    else if(![string isEqualToString:@"\n"])
    {
        querySearch=[NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    
    [self loadMoreRowsByQuery:querySearch];
    
    return YES;
}

#pragma mark - Util

/*!
 * @brief Metodo llamado para definir el tipo y metodo a llamar
 * @param nType, tipo de elemento a contener
 * @param nCaller, mensaje a ser lamado despues de la seleccion
 * @return IBAction
 */
- (void) setType:(NSString*)nType andCaller:(NSString*) nCaller
{
    type=nType;
    caller=nCaller;
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
 * @brief Metodo que borra toda la tabla
 * @return void
 */
- (void) cleanListWithActual
{
    [self.tableResults scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    container=[[NSMutableArray alloc] init];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // si el usuario hace scroll desaparece el teclado
    [self.view endEditing:YES];
}

/*!
 * @brief Metodo llamado cuando dan clic al boton de cerrar
 * @param sender, Boton seleccionado
 * @return IBAction
 */
- (IBAction)touchButtonClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
