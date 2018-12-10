
#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

#import <sqlite3.h>

@interface RNSQLiteAG : NSObject <RCTBridgeModule> {
    sqlite3 *db;
}

@end

@implementation RNSQLiteAG

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(exec: (NSString*) appGroupKey
                  dbPath: (NSString*) dbPath
                  query: (NSString*) query
                  resolver:(RCTResponseSenderBlock)resolve
                  rejecter: (RCTResponseSenderBlock)reject)
{
    NSURL *appGroupFolder = [[NSFileManager defaultManager]
                             containerURLForSecurityApplicationGroupIdentifier: appGroupKey];
    
    
    NSString *_databasePath = [[NSString alloc]initWithString: [[appGroupFolder absoluteString] stringByAppendingString: dbPath]];
    NSLog(@"SQLITEAG databasePath %@", _databasePath);
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &db) == SQLITE_OK) {
        char *errMsg;
        
        if (sqlite3_exec(db, query.UTF8String, NULL, NULL, &errMsg) != SQLITE_OK) {
            return reject(@[@"SQLITEAG: Failed to update table:"]);
        }
        
        sqlite3_close(db);
    } else {
        return reject(@[@"SQLITEAG: Failed to open or create database"]);
    }
    
    
    return resolve(@[self]);
}

@end
