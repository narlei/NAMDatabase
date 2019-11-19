//
//  NAMDatabase.m
//  NAMLibrary
//
//  Created by Narlei A Moreira on 7/27/16.
//  Copyright © 2016 Narlei A Moreira. All rights reserved.
//

#import "NAMDatabase.h"
#import "NAMObjectModel.h"
#import <objc/runtime.h>

@implementation NAMDatabase
{
}

+ (instancetype)sharedNAMDatabase {
    static NAMDatabase *_sharedNAMDatabase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedNAMDatabase = [[NAMDatabase alloc] init];
    });

    return _sharedNAMDatabase;
}

#pragma mark - Abertura e Fechamento

- (FMDatabase *)database {
    [self _initializeDatabase];
    if (![_database open]) {
        NSLog(@"Database cannot be opened");
    }

    return _database;
}

- (void)closeDatabase {
    @try {
        if (_database) {
            if (![_database close]) {
                NSLog(@"Erro fechando DB");
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Erro fechando DB");
    }
}

- (void)_initializeDatabase {
    if (_database) {
        return;
    }

    if (![self _createDataBase]) {
        return;
    }

    if ([[NSFileManager defaultManager] fileExistsAtPath:self.databasePath]) {
        _database = [FMDatabase databaseWithPath:self.databasePath];
        [_database setLogsErrors:YES];
        [_database setTraceExecution:NO];
        [_database setShouldCacheStatements:YES];
    }
}

- (BOOL)_createDataBase {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *databasePath = [self databasePath];
    success = [fileManager fileExistsAtPath:databasePath];
    if (success) {
        NSLog(@"Already Exists: %@", databasePath);
        //        [self updateDatabase];
        return YES;
    } else {
        NSLog(@"Not Exists");
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.sqlite"];
        if ([fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil]) {
            NSLog(@"Copied Succefull %@", databasePath);
            return YES;
        } else {
            NSLog(@"Error Copying");
            return NO;
        }
    }
    return NO;
}

- (NSString *)databasePath {
    if (_databasePath.length == 0) {
        _databasePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"database.sqlite"];
    }
    return _databasePath;
}

#pragma mark - Execução de comandos

- (FMResultSet *)executeQuery:(NSString *)query {
    FMResultSet *rs;
    if ([self.database goodConnection]) {
        rs = [self.database executeQuery:query];
    } else {
    }

    return rs;
}

- (BOOL)executeUpdate:(NSString *)sql {
    if ([self.database goodConnection]) {
        return [self.database executeUpdate:sql];
    } else {
        return NO;
    }
}

- (BOOL)executeStatements:(NSString *)sql {
    if ([self.database goodConnection]) {
        return [self.database executeStatements:sql];
    } else {
        return NO;
    }
}

- (void)createAllTables {
    int numClasses;
    Class *classes = NULL;

    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);

    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class c = classes[i];
            NSBundle *b = [NSBundle bundleForClass:c];
            if (b == [NSBundle mainBundle] && [c isSubclassOfClass:[NAMObjectModel class]]) {
                NSLog(@"%s", class_getName(c));
                NSString *sqlCreate = [c sqlGenerateTable];
                [[NAMDatabase sharedNAMDatabase] executeStatements:sqlCreate];
            }
        }
        free(classes);
    }
}

#pragma mark - Load Json

- (NSDictionary *)loadJsonFromBundle:(NSString *)pJsonFileName firstKey:(NSString *)pFirstKey {
    NSString *filePath = [[NSString alloc] init];
    NSData *jsonData = [[NSData alloc] init];
    NSDictionary *dicJson = [[NSDictionary alloc] init];

    filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pJsonFileName];

    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    jsonData = [myJSON dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

    if (pFirstKey) {
        dicJson = [jsonObjects objectForKey:pFirstKey];
    } else {
        dicJson = jsonObjects;
    }

    return dicJson;
}

@end
