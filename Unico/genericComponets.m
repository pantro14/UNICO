//
//  genericComponets.m
//  Unico Final
//
//  Created by Francisco Garcia on 10/20/14.
//  Copyright (c) 2014 prem.dayal. All rights reserved.
//

#import "genericComponets.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/ASIdentifierManager.h>

@implementation genericComponets

/*!
 * @brief Metodo que retorna la direccion donde estan ubicado los servicios
 * @return NSString, direccion donde estan ubicados los servicios
 */
+ (NSString *) getRequestUrl
{
    //return @"http://64.76.57.248/unico/public/api/1.0/movil"; // Producción
    //return @"http://25.140.183.218/unico/public/api/1.0/movil"; // Local de David Home
    //return @"http://64.76.57.228:100/unico/dev/public/api/1.0/movil"; // Ambiente Desarrollo
    return @"http://64.76.57.228:100/unico/qa/public/api/1.0/movil"; // Ambiente Calidad
    //return @"http://64.76.57.228:100/unico/qa2/public/api/1.0/movil"; // Ambiente Calidad 2
}

/*!
 * @brief Metodo que retorna el nombre de la imagen por default cuando falla al traerla desde internet
 * @return NSString, nombre de la imagen
 */
+ (NSString *) getDefaultImagePromotion
{
    return @"defaultDetalleOferta";
}

/*!
 * @brief Metodo que retorna el texto de error cuando un servicio no responde
 * @return NSString, texto de error
 */
+ (NSString *) getErrorMessage
{
    return @"El servicio no está disponible en este momento, por favor intentar más tarde.";
}

/*!
 * @brief Metodo que retorna un texto encriptado en MD5
 * @param input, texto a ser encriptado
 * @return NSString, texto encriptado
 */
+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

/*!
 * @brief Metodo que retorna si la aplicacion esta en modo debug o no
 * @return BOOL, Si esta en debug o no
 */
+ (BOOL) getMode
{
    return YES;
}

/*!
 * @brief Metodo que retorna el numero de tiendas a traer por peticion al hacer la busqueda
 * @return NSString, numero de tiendas acargar
 */
+ (NSString *) getStoresPerLoad
{
    return  @"10";
    
}

/*!
 * @brief Metodo que retorna el numero de promociones/Eventos a traer por peticion
 * @return NSString, numero de promociones/eventos acargar
 */
+ (NSString *) getPromotionsPerLoad
{
    return  @"10";
    
}

/*!
 * @brief Metodo que retorna el numero la lista de ciudades
 * @return NSArray, lista de ciudades
 */
+ (NSArray *) getCitiesArray
{
    return @[@"Barranquilla",@"Cali",@"Dosquebradas", @"Pasto",@"Villavicencio",@"Yumbo"];
}

/*!
 * @brief Metodo que retorna la lista de categorias
 * @return NSString, lista de categorias
 */
+ (NSArray *) getCategoriesArray
{
    return @[@"Ropa Mujer",@"Ropa Hombre",@"Infantil",@"Calzado/Marroquinería",@"Deporte",@"Ropa Interior/Vestido Baño",@"Hogar/Tecnología/Variedades",@"Supermercado/Droguería/Óptica",@"Servicios/Financieros",@"Entretenimiento/Comidas"];
}

/*!
 * @brief Metodo que retorna el id de una categoria dado su nombre.
 * @param inCategoria, nombre de la categoria
 * @return NSString, numero de la categoria
 */
+ (NSString *) fixCategories:(NSString *) inCategory
{
    if([inCategory isEqualToString:@"Ropa Mujer"])
    {
        return @"1";
    }
    else if([inCategory isEqualToString:@"Ropa Hombre"] )
    {
        return @"2";
    }
    else if([inCategory isEqualToString:@"Infantil"])
    {
        return @"3";
    }
    else if([inCategory isEqualToString:@"Calzado/Marroquinería"] )
    {
        return @"4";
    }
    else if([inCategory isEqualToString:@"Deporte"])
    {
        return @"5";
    }
    else if([inCategory isEqualToString:@"Ropa Interior/Vestido Baño"] )
    {
        return @"6";
    }
    else if([inCategory isEqualToString:@"Hogar/Tecnología/Variedades"])
    {
        return @"7";
    }
    else if([inCategory isEqualToString:@"Supermercado/Droguería/Óptica"] )
    {
        return @"8";
    }
    else if([inCategory isEqualToString:@"Servicios/Financieros"])
    {
        return @"9";
    }
    else if([inCategory isEqualToString:@"Entretenimiento/Comidas"] )
    {
        return @"10";
    }
    
    return @"1";
}

/*!
 * @brief Metodo que retorna la lista de tipos de ofertas
 * @return NSArray, lista de tipo de ofertas
 */
+ (NSArray *) getTypeOfferArray
{
    return @[@"XxY",@"% DESCUENTO",@"OTROS"];
}

/*!
 * @brief Metodo que retorna el id de un tipo de oferta dado su nombre.
 * @param inTypeOffer, nombre del tipo de oferta
 * @return NSString, numero del tipo de oferta
 */
+ (NSString *) fixTypeOffer:(NSString *) inTypeOffer
{
    if([inTypeOffer isEqualToString:@"XxY"])
    {
        return @"2";
    }
    else if([inTypeOffer isEqualToString:@"% DESCUENTO"] )
    {
        return @"1";
    }
    else if([inTypeOffer isEqualToString:@"OTROS"])
    {
        return @"3";
    }
    
    return @"1";
}

/*!
 * @brief Metodo que retorna la lista de generos
 * @return NSArray, lista de generos
 */
+ (NSArray *) getGenderArray
{
    return @[@"Masculino", @"Femenino"];
}

/*!
 * @brief Metodo que retorna el id de una ciudad dado su nombre.
 * @param inCity, nombre de la ciudad
 * @return NSString, numero de la ciudad
 */
+ (NSString *) fixCity:(NSString *) inCity
{
    
    if([inCity isEqualToString:@"Barranquilla"] || [inCity isEqualToString:@"BARRANQUILLA"])
    {
        return @"2";
    }
    else if([inCity isEqualToString:@"Cali"] || [inCity isEqualToString:@"CALI"])
    {
        return @"1";
    }
    else if([inCity isEqualToString:@"Dosquebradas"] || [inCity isEqualToString:@"DOSQUEBRADAS"])
    {
        return @"4";
    }
    else if([inCity isEqualToString:@"Pasto"] || [inCity isEqualToString:@"PASTO"])
    {
        return @"5";
    }
    else if([inCity isEqualToString:@"Villavicencio"] || [inCity isEqualToString:@"VILLAVICENCIO"])
    {
        return @"6";
    }
    else if([inCity isEqualToString:@"Yumbo"] || [inCity isEqualToString:@"YUMBO"])
    {
        return @"3";
    }
    
    return @"1";
}

/*!
 * @brief Metodo que retorna el id de un genero dado su nombre.
 * @param inGender, nombre del genero
 * @return NSString, numero del genero
 */
+ (NSString *) fixGender:(NSString *) inGender
{
    //@"Masculino", @"Femenino"]
    if([inGender isEqualToString:@"Masculino"])
    {
        return @"M";
    }
    else if([inGender isEqualToString:@"Femenino"])
    {
        return @"F";
    }
    else if([inGender isEqualToString:@"No definido"] || [inGender isEqualToString:@"Genero"])
    {
        return @"N";
    }
    
    return @"M";
}

/*!
 * @brief Metodo que retorna la fecha de nacimiento.
 * @param inBirthday, fecha de nacimiento
 * @return NSString, fecha de nacimiento
 */
+ (NSString *) fixBirthday:(NSString *) inBirthday
{
    if([inBirthday isEqualToString:@"No definido"])
    {
        return [NSNull null];
    }
    
    return inBirthday;
}

/*!
 * @brief Metodo que ajusta el genero de facebook al estandar de la aplicacion
 * @param inGender, nombre del genero Facebook
 * @return NSString, nombre ajustado
 */
+ (NSString *) fixGenderFB:(NSString *) inGender
{
    //@"Masculino", @"Femenino"]
    if([inGender isEqualToString:@"male"])
    {
        return @"Masculino";
    }
    else if([inGender isEqualToString:@"female"])
    {
        return @"Femenino";
    }
    
    return @"Masculino";
}

/*!
 * @brief Metodo que retorna la expresion regular para validar el correo electronico.
 * @return NSPredicate,expresion regular
 */
+(NSPredicate*) emailValidator
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
}

/*!
 * @brief Metodo que retorna la url que se incluira al momento de compartir ofertas/tiendas/eventos
 * @return NSString, url
 */
+(NSString*) shareURL
{
    return @"http://www.unico.com.co";
}

/*!
 * @brief Metodo que retorna el link de itunes para descargar la aplicacion
 * @return NSString, link
 */
+(NSString*) getItunesLink
{
    return @"https://itunes.apple.com/us/app/unico-outlet/id948327267?mt=8";
}

#pragma mark - Maps Methods

/*!
 * @brief Metodo que retorna las coordenadas donde va la imagen del mapa por ciudad
 * @param cityId, id de la ciudad
 * @param nFloor, Piso
 * @return NSMutableArray, Array con coordenadas
 */
+ (NSMutableArray*) getMapCoordinatesByCity:(int)cityId andFloor:(int) nFloor
{
    NSMutableArray* data=[[NSMutableArray alloc] init];
    if(cityId==1)
    {
        if(nFloor==1)
        {
            [data insertObject:[NSString stringWithFormat:@"%f",3.46639] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.49913] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",3.46337] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.50322] atIndex:3];
        }
        else
        {
            [data insertObject:[NSString stringWithFormat:@"%f",3.46650] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.49895] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",3.46326] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.50340] atIndex:3];
        }
        [data insertObject:[NSString stringWithFormat:@"%d",2] atIndex:4];
    }
    else if(cityId==2)
    {
        if(nFloor==1)
        {
            [data insertObject:[NSString stringWithFormat:@"%f",10.99156] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-74.80989] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",10.98743] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-74.81487] atIndex:3];
        }
        else
        {
            [data insertObject:[NSString stringWithFormat:@"%f",10.99156] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-74.80989] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",10.98743] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-74.81487] atIndex:3];
        }
        [data insertObject:[NSString stringWithFormat:@"%d",1] atIndex:4];
    }
    else if(cityId==3)
    {
        if(nFloor==1)
        {
            [data insertObject:[NSString stringWithFormat:@"%f",3.58202] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.486679] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",3.58057] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.48870] atIndex:3];
        }
        else
        {
            [data insertObject:[NSString stringWithFormat:@"%f",3.58202] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.486679] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",3.58057] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.48870] atIndex:3];
        }
        [data insertObject:[NSString stringWithFormat:@"%d",2] atIndex:4];
    }
    else if(cityId==4)
    {
        if(nFloor==1)
        {
            [data insertObject:[NSString stringWithFormat:@"%f",4.83015] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-75.67650] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",4.82769] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-75.67976] atIndex:3];
        }
        else
        {
            [data insertObject:[NSString stringWithFormat:@"%f",4.83015] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-75.67650] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",4.82769] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-75.67976] atIndex:3];
        }
        [data insertObject:[NSString stringWithFormat:@"%d",1] atIndex:4];
    }
    else if(cityId==5)
    {
        if(nFloor==1)
        {
            [data insertObject:[NSString stringWithFormat:@"%f",1.20667] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-77.25780] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",1.20491] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-77.26119] atIndex:3];
        }
        else
        {
            [data insertObject:[NSString stringWithFormat:@"%f",1.20666] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-77.25779] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",1.20492] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-77.26119] atIndex:3];
        }
        [data insertObject:[NSString stringWithFormat:@"%d",2] atIndex:4];
    }
    else if(cityId==6)
    {
        if(nFloor==1)
        {
            [data insertObject:[NSString stringWithFormat:@"%f",4.13023] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-73.62159] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",4.12759] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-73.62682] atIndex:3];
        }
        else
        {
            [data insertObject:[NSString stringWithFormat:@"%f",4.13023] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-73.62159] atIndex:1];
            [data insertObject:[NSString stringWithFormat:@"%f",4.12759] atIndex:2];
            [data insertObject:[NSString stringWithFormat:@"%f",-73.62682] atIndex:3];
        }
        [data insertObject:[NSString stringWithFormat:@"%d",2] atIndex:4];
    }
    else
    {
        if(nFloor==1)
        {
            [data insertObject:[NSString stringWithFormat:@"%f",3.46363] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.50339] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",3.46610] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.49938] atIndex:0];
        }
        else
        {
            [data insertObject:[NSString stringWithFormat:@"%f",3.46359] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.50332] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",3.46609] atIndex:0];
            [data insertObject:[NSString stringWithFormat:@"%f",-76.49925] atIndex:0];
        }
    }
    
    return data;
}

/*!
 * @brief Metodo que retorna las imagenes a colocar para una ruta
 * @param type, tipo de punto que se desea mostrar
 * @return NSString, nombre de la imagen
 */
+(NSString *) getMapRoutingIconByType:(NSString *) type
{
    if([type isEqualToString:@"START"])
    {
        return @"flechaRuta@2X.png";
    }
    else if([type isEqualToString:@"UP"])
    {
        return @"sube@2X.png";
    }
    else if([type isEqualToString:@"DOWN"])
    {
        return @"baja@2X.png";
    }
    else if([type isEqualToString:@"END"])
    {
        return @"banderaRuta@2X.png";
    }
    
    return @"banderaRuta@2X.png";
}

/*!
 * @brief Metodo que retorna el nombre de las imagenes del mapa por ciudad
 * @param cityId, id de la ciudad
 * @param nFloor, Piso
 * @return NSString, nombre de la imagen
 */
+ (NSString *) getMapImageByCity:(int) cityId andFloor:(int) floor
{
    if(cityId==1)
    {
        if(floor==1)
            return @"calipiso1.png";
        else
            return @"calipiso2.png";
    }
    else if(cityId==2)
    {
        if(floor==1)
            return @"barranquilla.png";
        else
            return @"barranquilla.png";
    }
    else if(cityId==3)
    {
        if(floor==1)
            return @"yumbopiso1.png";
        else
            return @"yumbopiso2.png";
    }
    else if(cityId==4)
    {
        if(floor==1)
            return @"dosquebradas.png";
        else
            return @"dosquebradas.png";
    }
    else if(cityId==5)
    {
        if(floor==1)
            return @"pastopiso1.png";
        else
            return @"pastopiso2.png";
    }
    else if(cityId==6)
    {
        if(floor==1)
            return @"villavicenciopiso1.png";
        else
            return @"villavicenciopiso2.png";
    }
    else
    {
        if(floor==1)
            return @"cali_1.tif";
        else
            return @"cali_1.tif";
    }
}

/*!
 * @brief Metodo que retorna el numero de puntos a mostrar en el mapa
 * @return NSString, numero de puntos
 */
+ (NSString *) getNumberPromotionsMap
{
    return  @"100";
    
}

/*!
 * @brief Metodo que retorna el key de google maps
 * @return NSString, key
 */
+ (NSString *) getGoogleApiKey
{
    return  @"AIzaSyAPj_Inzxiu0NwGGXqiY-Sv924VBD3zZzM";
    
}

/*!
 * @brief Metodo que retorna la imagen del cluster de promociones en el mapa
 * @return NSString, nombre de la imagen
 */
+ (NSString *) getClusterImage
{
    
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        return  @"cluster@2X.png";
    } else {
        return  @"cluster.png";
    }
    
    
}

/*!
 * @brief Metodo que retorna el nombre de las imagenes del mapa por categoria
 * @param category, categoria
 * @param type, tipo
 * @return NSString, nombre de la imagen
 */
+ (NSString *) getMapImageByCategory:(int) category andType:(int) type
{
    NSString* image=@"";
    
    if(category==1)
    {
        image=@"ropaMujer%@%@.png";
    }
    else if(category==2)
    {
        image=  @"ropaHombre%@%@.png";
    }
    else if(category==3)
    {
        image=  @"infantil%@%@.png";
    }
    else if(category==4)
    {
        image=  @"calzado%@%@.png";
    }
    else if(category==5)
    {
        image=  @"deportes%@%@.png";
    }
    else if(category==6)
    {
        image=  @"vestidosBano%@%@.png";
    }
    else if(category==7)
    {
        image=  @"tecnologia%@%@.png";
    }
    else if(category==8)
    {
        image=  @"supermercados%@%@.png";
    }
    else if(category==9)
    {
        image=  @"financiero%@%@.png";
    }
    else if(category==10)
    {
        image=  @"entretenimiento%@%@.png";
    }
    else
    {
        image=  @"calzadoCAZAOFERTAS%@%@.png";
    }
    
    //Valida que resolucion de imagen se va usar
    NSString* resolution=@"";
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        resolution=@"@2X";
    }
    
    if(type==1)
    {
        image=[NSString stringWithFormat:image,@"PREMIUM",resolution];
    }
    else if(type==2)
    {
        image=[NSString stringWithFormat:image,@"ANCLA",resolution];
    }
    else if(type==4)
    {
        image=[NSString stringWithFormat:image,@"CAZAOFERTAS",resolution];
    }
    else
    {
        image=[NSString stringWithFormat:image,@"",resolution];
    }
    
    return image;
    
}


/*!
 * @brief Metodo que retorna el identificador unico del dispositivo
 * @return NSString, identificador
 */
+ (NSString *) advertisingIdentifier
{
    if (!NSClassFromString(@"ASIdentifierManager")) {
        SEL selector = NSSelectorFromString(@"uniqueIdentifier");
        if ([[UIDevice currentDevice] respondsToSelector:selector]) {
            return [[UIDevice currentDevice] performSelector:selector];
        }
    }
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

@end
