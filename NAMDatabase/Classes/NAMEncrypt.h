//
//  NAMEncrypt.h
//  NAMLibrary
//
//  Created by Narlei A Moreira on 7/27/16.
//  Copyright © 2016 Narlei A Moreira. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  Classe de encriptação de Dados
 */
@interface NAMEncrypt : NSObject

/**
 *  Encripta para sha256
 *
 *  @param string Valor a ser encriptado
 *
 *  @return valor já encriptado
 */
+ (NSString *)sha256:(NSString *)string;

@end
