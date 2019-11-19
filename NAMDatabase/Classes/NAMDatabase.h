//
//  NAMDatabase.h
//  NAMLibrary
//
//  Created by Narlei A Moreira on 7/27/16.
//  Copyright © 2016 Narlei A Moreira. All rights reserved.
//

@import FMDB;
#import <Foundation/Foundation.h>

/**
 *  Database management Class
 */
@interface NAMDatabase : NSObject

/**
 *  Static Method
 *
 *  @return instancia estática
 */
+ (instancetype)sharedNAMDatabase;

/**
*  Initialize the NAMDatabase, call in AppDelegate
*  @param printPath Print the SQLite database path to debug in simulator
*/
- (void)initialize:(BOOL)printPath;

/**
 *  Database Path, default: Documents/database.sqlite
 */
@property (nonatomic, strong) NSString *databasePath;

/**
 *  FMDB database object
 */
@property (nonatomic, strong) FMDatabase *database;


#pragma mark - Create Database

/**
 * Create all tables descripted in `NAMDatabaseClasses.nam`
 */
- (void)createAllTables;

#pragma mark - Execute Commands

/**
 *  Executes DML stantments
 *
 *  @param query Sql
 *
 *  @return FMResultSet
 */
- (FMResultSet *)executeQuery:(NSString *)query;

/**
 *  Executes DDL stantments
 *
 *  @param sql Comando
 *
 *  @return `YES` sucesso e `NO` falha
 */
- (BOOL)executeUpdate:(NSString *)sql;

- (BOOL)executeStatements:(NSString *)sql;

@end
