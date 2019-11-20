//
//  NAMObjectModel.m
//  NAMLibrary
//
//  Created by Narlei A Moreira on 7/26/16.
//  Copyright © 2016 Narlei A Moreira. All rights reserved.
//

#import "FMDatabaseQueue.h"
#import "NAMDatabase.h"
#import "NAMEncrypt.h"
#import "NAMObjectModel.h"
#import <objc/runtime.h>

@implementation NAMObjectModel

#pragma mark - DataBase

#pragma mark Instanciadores

+ (id)initWithDataBaseDictionary:(NSDictionary *)pDicDatabase {
    NSArray *arrayKeys = [pDicDatabase allKeys];
    id object = [[self.class alloc] init];
    for (NSString *key in arrayKeys) {
        if ([object respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
            @try {
                if ([pDicDatabase objectForKey:key] && !([[pDicDatabase objectForKey:key] isKindOfClass:[NSNull class]])) {
                    [object setValue:[pDicDatabase objectForKey:key] forKey:key];
                }
            } @catch (NSException *exception) {
                NSLog(@"Sent Set Property [%@] to Class [%@]", key, [self class]);
            } @finally {
            }
        }
    }
    return object;
}

+ (NSArray *)ignoredProperties {
    return @[@"searchTerm"];
}

+ (NSArray *)primaryKeys {
    return @[@"identifier"];
}

+ (NSString *)tableName {
    return [NSString stringWithFormat:@"%@", [self class]];
}

#pragma mark Retrieve de Dados

// Get Espefific Object
+ (NSDictionary *)getObjectFromTable:(NSString *)pTableName idKey:(NSString *)pIdKey withId:(id)pID returnParsed:(BOOL)pParsed {
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE %@ = %@", pTableName, pIdKey, pID];

    FMResultSet *rs = [[NAMDatabase sharedNAMDatabase] executeQuery:sqlSelect];
    @try {
        while ([rs next]) {
            if (pParsed) {
                return [self.class initWithDataBaseDictionary:[rs resultDictionary]];
            }
            return [rs resultDictionary];
        }
    } @catch (NSException *exception) {
        return nil;
    }

    return nil;
}

// Get All Objects
+ (NSArray *)getAllObjectsFromTable:(NSString *)pTableName where:(NSString *)pWhere returnParsed:(BOOL)pParsed {
    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM \"%@\" WHERE %@ ", pTableName, pWhere];

    return [self getAllObjectsWithSQl:sqlSelect returnParsed:pParsed];
}

+ (NSArray *)getAllObjectsWithSQl:(NSString *)pSql returnParsed:(BOOL)pParsed {
    FMResultSet *rs = [[NAMDatabase sharedNAMDatabase] executeQuery:pSql];
    NSMutableArray *arrayReturn = [NSMutableArray new];
    @try {
        while ([rs next]) {
            if (pParsed) {
                [arrayReturn addObject:[self.class initWithDataBaseDictionary:[rs resultDictionary]]];
            } else {
                [arrayReturn addObject:[rs resultDictionary]];
            }
        }
    } @catch (NSException *exception) {
        return nil;
    } @finally {
        return arrayReturn;
    }

    return arrayReturn;
}

#pragma mark - Retrieve de Dados tratados

+ (id)getObjectWithId:(id)key {
    return [self getObjectFromTable:[self tableName] idKey:@"identifier" withId:[NSString stringWithFormat:@"'%@'", key] returnParsed:YES];
}

+ (NSArray *)getAllDataWhere:(NSString *)pWhere {
    return [self getAllObjectsFromTable:[self tableName] where:pWhere returnParsed:YES];
}

#pragma mark - Save Data

- (void)saveData {
    NSDictionary *dicData = [self dictionaryData];
    [self saveDataWithValues:dicData
                     inTable:[self.class tableName]
                  onComplete:^(FMDatabase *database) {
    }];
}

// Create/Update
- (void)saveDataWithValues:(NSDictionary *)dicParameters inTable:(NSString *)pTableName onComplete:(void (^)(FMDatabase *database))onComplete {
    NSString *stringInsertFields = @"";
    for (NSString *key in [dicParameters allKeys]) {
        stringInsertFields = [NSString stringWithFormat:@"%@, \"%@\"", stringInsertFields, key];
    }
    NSString *stringInsertValues = @"";
    for (NSString *key in [dicParameters allKeys]) {
        stringInsertValues = [NSString stringWithFormat:@"%@, :%@", stringInsertValues, key];
    }
    stringInsertFields = [stringInsertFields substringFromIndex:1];
    stringInsertValues = [stringInsertValues substringFromIndex:1];

    [[NAMDatabase sharedNAMDatabase].database close];

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NAMDatabase sharedNAMDatabase] databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL ok = [db executeUpdate:[NSString stringWithFormat:@"INSERT OR REPLACE INTO \"%@\" (%@) VALUES (%@)", pTableName, stringInsertFields, stringInsertValues] withParameterDictionary:dicParameters];
        if (!ok) {
            NSLog(@"ERROR_DB %@", [db lastError]);
        } else {
            onComplete(db);
        }
        [db close];
    }];
}

// Deleta

- (void)deleteData {
    NSString *pWhere = [NSString stringWithFormat:@"identifier = '%@'", self.identifier];
    [self.class deleteDataFromTable:[self.class tableName] where:pWhere];
}

+ (void)deleteObjectWithId:(id)key {
    NSString *pWhere = [NSString stringWithFormat:@"identifier = '%@'", key];
    [self deleteDataFromTable:[self tableName] where:pWhere];
}

+ (void)deleteAllDataWhere:(NSString *)pWhere {
    [self deleteDataFromTable:[self tableName] where:pWhere];
}

+ (void)deleteDataFromTable:(NSString *)pTable where:(NSString *)pWhere {
    [[NAMDatabase sharedNAMDatabase].database close];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NAMDatabase sharedNAMDatabase] databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL ok = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM \"%@\" WHERE %@", pTable, pWhere]];
        if (!ok) {
            NSLog(@"ERROR_DB %@", [db lastError]);
        }
    }];
}

- (void)deleteDataWithValues:(NSDictionary *)dicParameters inTable:(NSString *)pTableName onComplete:(void (^)(FMDatabase *database))onComplete {
    NSString *stringInsertFields = @"";
    for (NSString *key in [dicParameters allKeys]) {
        stringInsertFields = [NSString stringWithFormat:@"%@, %@", stringInsertFields, key];
    }
    NSString *stringInsertValues = @"";
    for (NSString *key in [dicParameters allKeys]) {
        stringInsertValues = [NSString stringWithFormat:@"%@, :%@", stringInsertValues, key];
    }
    stringInsertFields = [stringInsertFields substringFromIndex:1];
    stringInsertValues = [stringInsertValues substringFromIndex:1];

    [[NAMDatabase sharedNAMDatabase].database close];

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NAMDatabase sharedNAMDatabase] databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"pragma table_info('%@')", pTableName]];
        NSMutableArray *arrayPk = [NSMutableArray new];
        while ([rs next]) {
            if ([rs intForColumn:@"pk"] > 0) {
                NSString *primaryKey = [rs stringForColumn:@"name"];
                NSString *value = [dicParameters objectForKey:primaryKey];
                NSString *type = [rs stringForColumn:@"type"];
                NSString *sqlCommand = @"";
                if ([[type lowercaseString] isEqualToString:@"text"] || [[type lowercaseString] isEqualToString:@"char"]) {
                    sqlCommand = [NSString stringWithFormat:@"%@ = '%@'", primaryKey, value];
                } else {
                    sqlCommand = [NSString stringWithFormat:@"%@ = %@", primaryKey, value];
                }
                [arrayPk addObject:sqlCommand];
            }
        }
        NSString *where = @" 1 != 0";
        int countPk = 0;
        for (NSString *strSQl in arrayPk) {
            if (countPk == 0) {
                where = [NSString stringWithFormat:@" %@ ", strSQl];
            } else {
                where = [NSString stringWithFormat:@"%@ AND %@", where, strSQl];
            }
            countPk++;
        }

        NSString *sql = [NSString stringWithFormat:@"DELETE FROM \"%@\" WHERE %@", pTableName, where];
        [db executeUpdate:sql];
        onComplete(db);
    }];
}

#pragma mark Data Utils

- (NSDictionary *)dictionaryData {
    NSMutableDictionary *dicAllValues = [NSMutableDictionary new];
    NSDictionary *dicProperties = [self classPropsForClassHierarchy:[self class] onDictionary:[NSMutableDictionary new]];

    NSArray *arrayKeys = [dicProperties allKeys];

    for (NSString *key in arrayKeys) {
        NSString *valueFromKey = [dicProperties objectForKey:key];
        if ([valueFromKey isEqualToString:@"NSMutableArray"] || [valueFromKey isEqualToString:@"NSArray"]) {
            continue;
        } else {
            if (![[[self class] ignoredProperties] containsObject:key] && ![[key substringToIndex:1] isEqualToString:@"_"] && ![[key substringToIndex:2] isEqualToString:@"__"]) {
                if ([self valueForKey:key]) {
                    [dicAllValues setObject:[self valueForKey:key] forKey:key];
                }
            }
        }
    }
    return dicAllValues;
}

#pragma mark - Helpers

- (NSString *)getUniqueKey {
    CFUUIDRef uuidObj = CFUUIDCreate(nil); // create a new UUID
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    float rndValue = (((float)arc4random() / 0x100000000) * (10000000 - 0) + 0);
    NSString *uuidStringEncripted = [NAMEncrypt sha256:[NSString stringWithFormat:@"%@%f", uuidString, rndValue]];
    float rndValue2 = (((float)arc4random() / 0x100000000) * (100099999990000 - 99) + 99);
    NSString *uniqueKey = [NAMEncrypt sha256:[NSString stringWithFormat:@"%@%@%@%f", uuidString, [NSDate date], uuidStringEncripted, rndValue2]];

    uniqueKey = [uniqueKey uppercaseString];
    uniqueKey = [uniqueKey substringToIndex:15];

    return uniqueKey;
}

+ (NSString *)sqlGenerateTable {
    NSDictionary *dicProperties = [[NAMObjectModel new] classPropsForClassHierarchy:[self class] onDictionary:[NSMutableDictionary new]];

    NSArray *arrayKeys = [dicProperties allKeys];

    NSString *sqlCommand = [NSString stringWithFormat:@"DROP TABLE IF EXISTS `%@`;\n CREATE TABLE `%@` (", [self tableName], [self tableName]];
    NSString *sqlFields = @"";
    NSDictionary *dicTypes = @{ @"NSString": @"TEXT", @"NSNumber": @"NUMERIC" };

    for (NSString *key in arrayKeys) {
        NSString *valueType = [dicProperties objectForKey:key];
        if ([valueType isEqualToString:@"NSMutableArray"] || [valueType isEqualToString:@"NSArray"]) {
            continue;
        } else {
            if (![[[self class] ignoredProperties] containsObject:key] && ![[key substringToIndex:1] isEqualToString:@"_"] && ![[key substringToIndex:2] isEqualToString:@"__"]) {
                NSString *typeProperty = @"TEXT";
                for (NSString *keyType in [dicTypes allKeys]) {
                    if ([keyType isEqualToString:valueType]) {
                        typeProperty = [dicTypes objectForKey:keyType];
                        break;
                    }
                }

                sqlFields = [NSString stringWithFormat:@"%@`%@` %@,\n", sqlFields, key, typeProperty];
            }
        }
    }
    if (sqlFields.length > 0) {
        // Tira vírgula do início
        //        sqlFields = [sqlFields substringFromIndex:1];
        NSString *sqlPrimaryKeys = [NSString stringWithFormat:@"PRIMARY KEY(%@)", [[self primaryKeys] componentsJoinedByString:@","]];

        sqlCommand = [NSString stringWithFormat:@"%@\n %@ \n %@);", sqlCommand, sqlFields, sqlPrimaryKeys];
        return sqlCommand;
    }
    return @"";
}

#pragma mark - Properties Helper

- (NSDictionary *)classPropsForClassHierarchy:(Class)klass onDictionary:(NSMutableDictionary *)results {
    if (klass == NULL) {
        return nil;
    }
    // stop if we reach the NSObject class as is the base class
    if (klass == [NSObject class]) {
        return [NSDictionary dictionaryWithDictionary:results];
    } else {
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(klass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if (propName) {
                const char *propType = getPropertyType(property);
                if (propType) {
                    NSString *propertyName = [NSString stringWithUTF8String:propName];
                    NSString *propertyType = [NSString stringWithUTF8String:propType];
                    [results setObject:propertyType forKey:propertyName];
                }
            }
        }
        free(properties);
        // go for the superclass
        return [self classPropsForClassHierarchy:[klass superclass] onDictionary:results];
    }
}

static const char * getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    // printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search
             online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l",
             unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

@end
