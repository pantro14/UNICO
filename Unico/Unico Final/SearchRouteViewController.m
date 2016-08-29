//
//  SearchRouteViewController.m
//  Unico Final
//
//  Created by Francisco Garcia on 11/4/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "SearchRouteViewController.h"
#import "SeachTableCellView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "genericComponets.h"
#import "ModelStore.h"

@interface SearchRouteViewController ()

@end

@implementation SearchRouteViewController{
    // Cola de llamados
    NSOperationQueue *queue;
    // Modo de la Vsita
    BOOL debug;
    // Texto de busqueda
    NSString* querySearch;
    // Contenedor de datos para la tabla
    NSMutableArray *container;
    // Texto activo
    NSString* textActived;
    // Tienda punto de inicio
    ModelStore* startPoint;
    // Tienda punto destino
    ModelStore* endPoint;
}

- (void)viewDidLoad {
    
    queue=[[NSOperationQueue alloc]init];
    
    debug=[genericComponets getMode];
    
    querySearch=@"";
    
    textActived=@"";
    
    container = [[NSMutableArray alloc] init];
    
    self.textEndPoint.delegate=self;
    
    self.textStartPoint.delegate=self;
    
    [super viewDidLoad];
    
    self.buttonSearchRout.clipsToBounds = YES;
    self.buttonSearchRout.layer.cornerRadius = 5.0;
    
    
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
    static NSString *CellIdentifier = @"SeachTableCellView";
    SeachTableCellView *cell = (SeachTableCellView *) [self.tableStores dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SeachTableCellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // Se agragan los reultaods a la tabla
    if([container count]>indexPath.row)
    {
        cell.labelStore.text = [[container objectAtIndex:indexPath.row] storeName];
        cell.labelLocal.text = [NSString stringWithFormat:@"Local %@ - Piso %d",[[container objectAtIndex:indexPath.row] numlocal],[[container objectAtIndex:indexPath.row] floor]] ;
        
        NSMutableArray* tmp =[[container objectAtIndex:indexPath.row] StoreCategories];
        [cell.imageStore setImage:[UIImage imageNamed:[NSString stringWithFormat:@"scicon%@.png",[tmp objectAtIndex:0 ] ]]];
        
        if([tmp count]>1)
        {
            cell.imageSecondCategory.hidden=false;
            [cell.imageSecondCategory setImage:[UIImage imageNamed:[NSString stringWithFormat:@"scicon%@SMALL.png",[tmp objectAtIndex:1 ] ]]];
        }
        else
        {
            cell.imageSecondCategory.hidden=true;
        }
        
        if([tmp count]>2)
        {
            cell.imageThirdCategory.hidden=false;
            [cell.imageThirdCategory setImage:[UIImage imageNamed:[NSString stringWithFormat:@"scicon%@SMALL.png",[tmp objectAtIndex:2 ] ]]];
        }
        else
        {
            cell.imageThirdCategory.hidden=true;
        }
        
        if([[[container objectAtIndex:indexPath.row] numlocal] isEqualToString:@"0"])
        {
            cell.labelLocal.text =@"Incia desde donde te encuentras.";
            //cell.labelLocal.font=[UIFont systemFontOfSize:36];
            [cell.imageStore setImage:[UIImage imageNamed:@"ubicate.png"]];
        }
        
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80
    ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([textActived isEqualToString:@"pInico"])
    {
        self.textStartPoint.text=[[container objectAtIndex:indexPath.row] storeName];
        startPoint=[container objectAtIndex:indexPath.row];
    }
    else if([textActived isEqualToString:@"pFin"])
    {
        self.textEndPoint.text=[[container objectAtIndex:indexPath.row] storeName];
        endPoint=[container objectAtIndex:indexPath.row];
    }
    
    textActived=@"";
    
    [self cleanListWithActual:NO];
    
    [self.tableStores reloadData];
    
    [self.view endEditing:YES];
    
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
            [self cleanListWithActual:YES];
            
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
    
    
    
    NSDictionary * dict2=@{@"function":@"store@index",
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
    if([json valueForKey:@"function"] && [[json valueForKey:@"function"] isEqualToString:@"store@index"] )
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
            // agregan los datos a contenedor y se refresca la tabla
            for(NSDictionary *storeDict in data){
                
                ModelStore *temp = [[ModelStore alloc] init];
                [temp populateWithJson:storeDict];
                    
                [container addObject:temp];
                
                cont++;
            }
            if(debug)
                NSLog(@"Num Result %d",cont);
            
            [self.tableStores reloadData];
            
            
        }
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
    }
}

#pragma mark - Text Delegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    //define el campo que se activo
    if([textField.placeholder isEqualToString:@"Seleccione Ubicación actual"])
    {
        textActived=@"pInico";
    }
    else if([textField.placeholder isEqualToString:@"Busca una Tienda"])
    {
        textActived=@"pFin";
    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    //realiza la busqueda de tiendas
    if([textActived isEqualToString:@"pInico"])
    {
        startPoint=nil;
    }
    else if([textActived isEqualToString:@"pFin"])
    {
        endPoint=nil;
    }
    
    if([string isEqualToString:@""])
    {
        querySearch=[textField.text substringToIndex:[textField.text length] - 1];
        
    }
    else
    {
       querySearch=[NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    
    
    [self loadMoreRowsByQuery:querySearch];
    
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
/*!
 * @brief Metodo que borra los datos de la tabla
 * @param actual, Si debe agragar o no el elmento de ubicacion actual
 * @return void
 */
- (void) cleanListWithActual:(BOOL) actual
{
    [self.tableStores scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    container=[[NSMutableArray alloc] init];
    
    if(actual)
    {
        ModelStore* m = [[ModelStore alloc] init];
        [m populateWithName:@"Ubicación actual" image:@"" description:@"" likes:0 id:0 latitude:0.0 longitude:0.0 floor:0 numlocal:@"0"];
        
        [container addObject:m];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // si el usuario toca la pantalla desaparece el taclado
    [self.view endEditing:YES];
}

/*!
 * @brief Metodo llamado cuando presionana el boton de buscar ruta
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonSearchRoute:(id)sender {
    
    if(!startPoint)
    {
        [self alertscreen:@"Información" :@"Por favor seleccione un punto de inicio."];
    }
    else if(!endPoint)
    {
        [self alertscreen:@"Información" :@"Por favor seleccione un punto de destino."];
    }
    else if([[endPoint numlocal] isEqualToString:[startPoint numlocal]])
    {
        [self alertscreen:@"Información" :@"El punto de inicio y destino deben ser diferentes."];
    }
    else
    {
        NSMutableArray* ma =[[NSMutableArray alloc] init];
        
        [ma insertObject:startPoint atIndex:0];
        [ma insertObject:endPoint atIndex:1];
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"doRouting" object:ma];
        }];
    }
    
}
/*!
 * @brief Metodo llamado cuando presionana el boton de cerrar
 * @param sender, Boton
 * @return IBAction
 */
- (IBAction)touchButtonClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
