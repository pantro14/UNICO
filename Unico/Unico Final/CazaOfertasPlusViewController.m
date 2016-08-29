//
//  CazaOfertasPlusViewController.m
//  Unico Final
//
//  Created by Francisco Garcia on 11/1/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "CazaOfertasPlusViewController.h"
#import "GenericSearchViewController.h"
#import "MenuViewController.h"
#import "genericComponets.h"
#import "UIImage+Resize.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "ModelBrand.h"
#import "ModelEvent.h"
#import "ModelStore.h"

@interface CazaOfertasPlusViewController ()

@end

@implementation CazaOfertasPlusViewController
{
    // Tienda seleccionada
    ModelStore* store;
    // Marca seleccionada
    ModelBrand* brand;
    // Evento seleccionado
    ModelEvent* event;
    // Array con los datos del picker
    NSMutableArray *pickerData;
    // Tipo de picker
    NSString *pickerSelection;
    // Imagen que se va hacer post
    UIImage* imagePost;
    // Cola de llamados de red
    NSOperationQueue *queue;
    // Modo de la vista
    BOOL debug;
    // Valor de ajsute del tamano de la ventana
    float screenAdjust;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.view.frame.size.height < 568) {
        screenAdjust = 4;
    }else if (self.view.frame.size.height > 568){
        screenAdjust = 6;
    }else{
        screenAdjust = 10;
    }
    [self.imagePromotion setFrame:CGRectMake(self.imagePromotion.frame.origin.x,self.imagePromotion.frame.origin.y, 70, 70)];
    debug=[genericComponets getMode];
    
    queue=[[NSOperationQueue alloc]init];
    
    pickerSelection=@"";
    pickerData=[[NSMutableArray alloc]init];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + (self.view.bounds.size.height/screenAdjust));
    
    self.imagePromotion.layer.cornerRadius = self.imagePromotion.frame.size.width / 2;
    self.imagePromotion.clipsToBounds = YES;

    self.textViewDescription.layer.cornerRadius=8.0f;
    self.textViewDescription.layer.masksToBounds=YES;
    self.textViewDescription.layer.borderColor=[[UIColor colorWithRed:186.0/255.0
                                                                green:8.0/255.0
                                                                 blue:19.0/255.0
                                                                alpha:1.0] CGColor];;
    self.textViewDescription.layer.borderWidth= 1.0f;
    
    self.textViewDescription.delegate = self;
    
    
    self.buttonSave.clipsToBounds = YES;
    self.buttonSave.layer.cornerRadius = 5.0f;
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.pickerView setDelegate:self];
    self.pickerView.dataSource = self;
    
    self.datePicker.minimumDate = [NSDate date];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourNotificationHandler:) name:@"SelectionPlus" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.textViewDescription.text.length == 0){
        [self.textViewDescription resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //Si se esta editando una campo se mueve al vista para que le teclado no la tape
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            
                            self.scrollView.contentOffset = CGPointMake(0, 0 );
                            
                        } completion:nil];
    [self.view endEditing:YES];
    self.pickerView.hidden = YES;
    self.toolbar.hidden=YES;
    self.datePicker.hidden=YES;
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //Si se toca la pantalla desaparece el tecaldo
    [self.view endEditing:YES];
    self.pickerView.hidden = YES;
    self.toolbar.hidden=YES;
    self.datePicker.hidden=YES;
}

#pragma mark - Buttons

/*!
 * @brief Metodo cuando se presiona el boton de seleccion de un elemento
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonStore:(UIButton*)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 delay:0
                        options:UIViewAnimationOptionTransitionCurlDown animations:^{
                            
                            self.scrollView.contentOffset = CGPointMake(0, ((UIButton*) sender ).frame.origin.y-35 );
                            
                        } completion:nil];
    
    NSString* type=@"store";
    
    // Se verifica que elemento fue seleccionado
    if(sender.tag==1)
    {
        pickerSelection = @"discounttype";
        pickerData = [[NSMutableArray alloc] init];
        [pickerData addObjectsFromArray:[genericComponets getTypeOfferArray]];
        [self.view endEditing:YES];
        self.pickerView.hidden = NO;
        self.toolbar.hidden=NO;
        [self.pickerView reloadAllComponents];
    }
    else if(sender.tag==2)
    {
        type=@"store";
        [self showSelectionViewByType:type];
    }
    else if(sender.tag==3)
    {
        type=@"brand";
        [self showSelectionViewByType:type];
    }
    else if(sender.tag==4)
    {
        pickerSelection = @"category";
        pickerData = [[NSMutableArray alloc] init];
        [pickerData addObjectsFromArray:[genericComponets getCategoriesArray]];
        [self.view endEditing:YES];
        self.pickerView.hidden = NO;
        self.toolbar.hidden=NO;
        [self.pickerView reloadAllComponents];
    }
    else if(sender.tag==5)
    {
        type=@"event";
        [self showSelectionViewByType:type];
    }
    else if(sender.tag==6)
    {
        pickerSelection = @"startDate";
        self.datePicker.minimumDate = [NSDate date];
        [self.view endEditing:YES];
        self.datePicker.hidden = NO;
        self.toolbar.hidden=NO;
    }
    else if(sender.tag==7)
    {
        pickerSelection = @"endDate";
        [self.view endEditing:YES];
        self.datePicker.hidden = NO;
        self.toolbar.hidden=NO;
    }
    
}

#pragma mark - msegueHandler

/*!
 * @brief Metodo que es llamado cuando se envia una notificacion desde otra vista
 * @param notice, informacion del mensaje enviado
 * @return void
 */
-(void)yourNotificationHandler:(NSNotification *)notice{
    
    // Se valida de que elemetno viene el mensaje 
    if([notice.name isEqualToString:@"SelectionPlus"])
    {
        NSString *className = NSStringFromClass([notice.object class]);
        
        if([className isEqualToString:@"ModelStore"])
        {
            store=notice.object;
            
            [self.buttonStore setTitle:store.storeName forState:UIControlStateNormal];
        }
        else if([className isEqualToString:@"ModelEvent"])
        {
            event=notice.object;
            
            [self.buttonEvent setTitle:event.eventName forState:UIControlStateNormal];
        }
        else if([className isEqualToString:@"ModelBrand"])
        {
            brand=notice.object;
            
            [self.buttonBrand setTitle:brand.brandName forState:UIControlStateNormal];
        }
    }
}
#pragma mark - Pickers

- (IBAction)touchButtonMenu:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [sfvc setViewCaller:@"cazaView"];
    [self presentViewController:sfvc animated:YES completion:nil];
}

- (IBAction)touchButtonPhoto:(id)sender {
    
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Close"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Tomar Foto", @"Foto existente", nil]
     showInView:self.view];
}

/*!
 * @brief Metodo cuando se presiona el boton de terminar la eleccion del picker
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchButtonDone:(id)sender {

    self.pickerView.hidden = YES;
    self.toolbar.hidden = YES;
    
    [self.pickerView resignFirstResponder];
    
    self.datePicker.hidden = YES;
    [self.datePicker resignFirstResponder];
    
    //Se valida que picker termino la edicion segun el tipo de este
    if([pickerSelection isEqualToString:@"discounttype"])
    {
        [self.buttonTypeDiscount setTitle:[pickerData objectAtIndex:[self.pickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
        
        if([[pickerData objectAtIndex:[self.pickerView selectedRowInComponent:0]] isEqualToString:@"% DESCUENTO"])
        {
            [self.textDiscount setKeyboardType:UIKeyboardTypeNumberPad];
        }
        else
        {
            [self.textDiscount setKeyboardType:UIKeyboardTypeDefault];
        }
        self.textDiscount.text=@"";
    }
    else if([pickerSelection isEqualToString:@"category"])
    {
        [self.buttonCategory setTitle:[pickerData objectAtIndex:[self.pickerView selectedRowInComponent:0]] forState:UIControlStateNormal];
    }
    else if([pickerSelection isEqualToString:@"startDate"])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.datePicker.minimumDate=[self.datePicker date];
        [self.buttonStartDate setTitle:[formatter stringFromDate:[self.datePicker date]] forState:UIControlStateNormal];
        [self.buttonEndDate setTitle:@"YYYY-MM-DD" forState:UIControlStateNormal];
    }
    else if([pickerSelection isEqualToString:@"endDate"])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [self.buttonEndDate setTitle:[formatter stringFromDate:[self.datePicker date]] forState:UIControlStateNormal];
    }
}

/*!
 * @brief Metodo cuando se presiona el boton de guardar
 * @param sender, boton
 * @return IBAction
 */
- (IBAction)touchbuttonSave:(id)sender {
    
    self.textTitle.text=[self.textTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.textDiscount.text=[self.textDiscount.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.textViewDescription.text=[self.textViewDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // Se validan los datos de envio
    if([self.textTitle.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"El título de la promoción es obligatorio."];
    }
    else if([self.textDiscount.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"El descuento de la promoción es obligatorio."];
    }
    else if([self.buttonTypeDiscount.titleLabel.text isEqualToString:@"Tipo"])
    {
        [self alertscreen:@"Error" :@"Debes seleccionar un tipo de descuento."];
    }
    else if([self.buttonStore.titleLabel.text isEqualToString:@"Tienda"])
    {
        [self alertscreen:@"Error" :@"Debes seleccionar una tienda."];
    }
    else if([self.buttonBrand.titleLabel.text isEqualToString:@"Marca"])
    {
        [self alertscreen:@"Error" :@"Debes seleccionar una marca."];
    }
    else if([self.buttonCategory.titleLabel.text isEqualToString:@"Categoria"])
    {
        [self alertscreen:@"Error" :@"Debes seleccionar una categoría."];
    }
    else if([self.buttonStartDate.titleLabel.text isEqualToString:@"YYYY-MM-DD"])
    {
        [self alertscreen:@"Error" :@"Debes seleccionar una fecha de inicio de la promoción."];
    }
    else if([self.buttonEndDate.titleLabel.text isEqualToString:@"YYYY-MM-DD"])
    {
        [self alertscreen:@"Error" :@"Debes seleccionar una fecha de finalización de la promoción."];
    }
    else if([self.textViewDescription.text isEqualToString:@""])
    {
        [self alertscreen:@"Error" :@"La descripción de la promoción es obligatoria."];
    }
    else if(!imagePost)
    {
        [self alertscreen:@"Error" :@"La foto de la promoción es obligatoria."];
    }
    else
    {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];

        NSMutableDictionary * data=[[NSMutableDictionary alloc] init];
        
        [data setObject:self.textTitle.text forKey:@"stitle"];
        [data setObject:self.textDiscount.text forKey:@"soffertypedetails"];
        [data setObject:[NSString stringWithFormat:@"%d",store.storeId] forKey:@"nstore"];
        [data setObject:self.textViewDescription.text forKey:@"sdescription"];
        
        if(event)
        {
            [data setObject:[NSString stringWithFormat:@"%d",event.eventId] forKey:@"nevent"];
        }
        
        [data setObject:@"3" forKey:@"nofferpriority"];
        [data setObject:[genericComponets fixTypeOffer:self.buttonTypeDiscount.titleLabel.text] forKey:@"noffertype"];
        [data setObject:[genericComponets fixCategories:self.buttonCategory.titleLabel.text] forKey:@"ncategory"];
        
        [data setObject:self.buttonStartDate.titleLabel.text forKey:@"tstart"];
        [data setObject:self.buttonEndDate.titleLabel.text forKey:@"tend"];
        
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

- (IBAction)touch:(id)sender {
}

#pragma Pickers delagates

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}


// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica57-Condensed" size:17]];
        tView.textAlignment=NSTextAlignmentCenter;
        tView.numberOfLines=3;
    }
    // Fill the label text here
    tView.text=pickerData[row];
    return tView;
}

#pragma mark - SheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto]; break;
        case 1:
            [self selectPhoto];break;
    }
}
/*!
 * @brief Metodo que invoca el actionActivity de camara o seleccion de foto
 * @return void
 */
-(void)takePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

/*!
 * @brief  Metodo que invoca el actionActivity de  seleccion de foto cuando no hay camara
 * @return IBAction
 */
-(void)selectPhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

/*!
 * @brief Metodo llamado cuando el usuario selecciono o tomo una foto
 * @param picker, the image picker
 * @param info, diccionario con la informacion de la foto
 * @return void
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image=[self fixOrientation:image];
    //Si la foto no cumple con el tamano adecuado se rechaza
    if(image.size.width<640 || image.size.height<510)
    {
        [self alertscreen:@"Error" :@"La imagen debe tener mínimo 640 de ancho por 510 de alto."];
    }
    else
    {
        // Se recorta la imagen para cumple con el estandar
        imagePost=[image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(640,510) interpolationQuality:kCGInterpolationHigh];
        imagePost=[imagePost croppedImage:CGRectMake((imagePost.size.width -640)/2, (imagePost.size.height -510)/2, 640, 510)];
        
        CGFloat scaleSize = 0.1f;
        
         UIImage *image = [UIImage imageWithCGImage:imagePost.CGImage
                                                  scale:scaleSize
                                            orientation:imagePost.imageOrientation];
        
        imagePost=image;
        // Resize the image from the camera
        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(self.imagePromotion.frame.size.width, self.imagePromotion.frame.size.height) interpolationQuality:kCGInterpolationHigh];
        // Crop the image to a square (yikes, fancy!)
        UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -self.imagePromotion.frame.size.width)/2, (scaledImage.size.height -self.imagePromotion.frame.size.height)/2, self.imagePromotion.frame.size.width, self.imagePromotion.frame.size.height)];
        // Show the photo on the screen
        self.imagePromotion.image = croppedImage;
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }

}

#pragma mark - Util

/*!
 * @brief Metodo que muestra la vista de busqueda generica segun el tipo
 * @param type, Tipo de la busqueda
 * @return void
 */
-(void) showSelectionViewByType:(NSString*) type
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GenericSearchViewController *sfvc = [storyboard instantiateViewControllerWithIdentifier:@"GenericSearch"];
    [sfvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [sfvc setType:type andCaller:@"SelectionPlus"];
    [self presentViewController:sfvc animated:YES completion:nil];
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
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:final constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData: UIImageJPEGRepresentation(imagePost,0.8f) name:@"ImageUploadForm" fileName:@"ImageUploadForm.png" mimeType:@"image/png"];
    }];
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
        if(debug)
        {
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
            event=nil;
            brand=nil;
            imagePost=nil;
            //Se reinician los campos
            [self.buttonStore setTitle:@"Tienda" forState:UIControlStateNormal];
            [self.buttonBrand setTitle:@"Marca" forState:UIControlStateNormal];
            [self.buttonCategory setTitle:@"Categoria" forState:UIControlStateNormal];
            [self.buttonEndDate setTitle:@"YYYY-MM-DD" forState:UIControlStateNormal];
            [self.buttonEvent setTitle:@"Evento" forState:UIControlStateNormal];
            [self.buttonStartDate setTitle:@"YYYY-MM-DD" forState:UIControlStateNormal];
            [self.buttonTypeDiscount setTitle:@"Tipo" forState:UIControlStateNormal];
            self.imagePromotion.image=[UIImage imageNamed:@"dummy1.png"];
            
            self.textTitle.text=@"";
            self.textDiscount.text=@"";
            self.textViewDescription.text=@"";
            
            
            [UIView animateWithDuration:0.2 delay:0
                                options:UIViewAnimationOptionTransitionCurlDown animations:^{
                                    
                                    
                                    self.scrollView.contentOffset = CGPointMake(0, 0 );
                                    
                                } completion:nil];
            [self.view endEditing:YES];
            
            [self alertscreen:@"Información" :@"La promoción ha sido creada exitosamente."];
        }
        
    }
    else
    {
        [self alertscreen:@"Error de Comunicación" :@"La repuesta no corresponde a la petición"];
    }
}

/*!
 * @brief Metodo que arregla la orientacion de la imagen tomada
 * @param image, imagen tomada
 * @return UIImage
 */
- (UIImage *)fixOrientation:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
