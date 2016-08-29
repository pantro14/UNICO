//
//  SliderViewController.m
//  Unico Final
//
//  Created by Datatraffic on 10/16/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "SliderViewController.h"
#import "PromotionsViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController
{
    //Accion que debe tomar la vista
    BOOL shouldDismiss;
    //Tipo de Vista
    NSString* type;
}

- (void)viewDidLoad {
    
    if(!type)
    {
        type=@"normal";
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    shouldDismiss=NO;
    
    //Se cargan las imagenes a mostrar
    [self loadScrollerImages];
}

/*!
 * @brief Metodo para cargar las imagenes en scrollview
 * @return void
 */
-(void)loadScrollerImages
{
    
    int NumPages = 4;
    NSString* replace =@"";
    NSString* resolution=@"";
    //Si es tipo mapa define los parametros para estos
    if([type isEqualToString:@"map"])
    {
        replace=@"M";
        NumPages = 3;
    }
    
    //Valida la resolucion
    if (self.view.frame.size.height < 568)
    {
        resolution=@"R4";
    }
    self.slicerScroll.contentSize = CGSizeMake(NumPages * self.view.frame.size.width, 100);
    self.slicerScroll.pagingEnabled = YES;
    self.slicerScroll.delegate=self;
    
   
    //Carga las imagenes
    for (int i = 0; i < NumPages; i++) {
        
        NSString *nombreimagen=[NSString stringWithFormat:@"slide%d%@%@.png", i + 1,replace,resolution];
        UIImage *image = [UIImage imageNamed:nombreimagen];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //imageView.frame=CGRectMake(0, 0, 320,450);
        
        if (self.view.frame.size.height == 568) {
            
            imageView.frame=CGRectMake(0, 0, 320,450);
            
        }else{
            
            imageView.frame=CGRectMake(0, 0, 320,380);
        }
        
        CGRect frame = imageView.frame;
        //Hint close images horinzotally distance
        frame.origin.x = i * self.view.frame.size.width;
        imageView.frame = frame;
        [self.slicerScroll addSubview:imageView];
        
    }
    
    self.sliderPageControl.numberOfPages=NumPages;
    self.sliderPageControl.currentPage=0;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    
    // Calculating the page index. Not hard to understand it.
    int page = floor(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    
    // Set the page index as the current page to the page control.
    [self.sliderPageControl setCurrentPage:page];
    
}

- (IBAction)pageValueChange:(id)sender{
    // Get the index of the page.
    int pageIndex = [self.sliderPageControl currentPage];
    
    // We need to move the scroll to the correct page.
    // Get the scroll's frame.
    CGRect newFrame = [self.slicerScroll frame];
    
    // Calculate the x-coordinate of the frame where the scroll should go to.
    newFrame.origin.x = newFrame.size.width * pageIndex;
    
    // Scroll the frame we specified above.
    [self.slicerScroll scrollRectToVisible:newFrame animated:YES];
}

/*!
 * @brief Metodo para definir la accion cuando se da clic en continuar
 * @param action, Boolean
 * @return void
 */
-(void) setCloseAction:(BOOL) action
{
    shouldDismiss=action;
}

/*!
 * @brief Metodo llamado para definir el comportamietno de la vista, si es ayuda general o ayuda del mapa
 * @param nType, tipo que se desea
 * @return void
 */
-(void) setType:(NSString*) nType
{
    type=nType;
}

/*!
 * @brief Metodo llamado cuando se da clic al boton de continuar
 * @param sender, boton
 * @return void
 */
- (IBAction)touchButtonContinuar:(id)sender {
    
    if(!shouldDismiss)//[userDefaults setBool:NO forKey:@"show_events"];
    {
        [self performSegueWithIdentifier:@"goingToPromotions" sender:self];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Valida si debe ir a promociones o a eventos
    if ([[segue identifier] isEqualToString:@"goingToPromotions"])
    {
        
        PromotionsViewController *vc = [segue destinationViewController];
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        if([userDefaults boolForKey:@"show_events"])
        {
            NSLog(@"Registro Eventos");
            
            [userDefaults setBool:NO forKey:@"show_events"];
            
            [userDefaults synchronize];
            
            [vc setTypeofView:@"events"];
        }
        
        
    }
}

@end
