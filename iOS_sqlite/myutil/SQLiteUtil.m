//
//  SQLiteUtil.m
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/22.
//

#import "SQLiteUtil.h"
#import <sqlite3.h>

@interface SQLiteUtil()
{
    sqlite3 *db_handle;    // 句柄
}

@end

@implementation SQLiteUtil

+ (instancetype)sharedManager {
    static SQLiteUtil *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
        [staticInstance openSqlDataBase];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(void)dealloc {
    sqlite3_close(db_handle);
}

// 打开数据库
- (void)openSqlDataBase {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"backup.sqlite"];
    NSLog(@"fileNamePath = %@",fileName);
    // 将 OC 字符串转换为 C 语言的字符串
    const char *cFileName = fileName.UTF8String;
    
    int result = sqlite3_open(cFileName, &db_handle);
    if (result != SQLITE_OK) {  // 打开成功
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, sqlite3_errmsg(db_handle));
        return;
    }
    [self createTable];
}

- (void)createTable {
    // 创建表
    const char *sql = "CREATE TABLE IF NOT EXISTS app_data (id integer PRIMARY KEY AUTOINCREMENT,bundle_id text NOT NULL,account_id text NOT NULL,phone_num text,passwords text,remark text,keychain_data text,files_data text,device_name text,idfa text,os_index integer, UNIQUE(bundle_id,account_id) ON CONFLICT REPLACE);";
    char *error = NULL;
    
    int result = sqlite3_exec(db_handle, sql, NULL, NULL, &error);
    if (result != SQLITE_OK) {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
        sqlite3_free(error);
    }
}

// 添加
-(BOOL)addModel:(BackupModel *)model {
    char *error = NULL;
    int result;
    // sql语句
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT count(*) FROM app_data "];
    [sql appendFormat:@"where bundle_id = '%@' and account_id = '%@';",model.bundle_id,model.account_id];
    
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db_handle, sql.UTF8String, -1, &stmt, NULL) != SQLITE_OK) {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, sqlite3_errmsg(db_handle));
        return NO;
    }
    sqlite3_step(stmt);
    int exist = sqlite3_column_int(stmt, 0);
    
    if(exist) {//存在就修改
        NSMutableString *sql = [NSMutableString string];
        [sql appendString:@"update app_data set "];
        //        if(model.account_id) {
        //            [sql appendFormat:@"account_id = '%@' ",model.account_id];
        //        }
        if(model.phone_num) {
            [sql appendFormat:@"phone_num = '%@', ",model.phone_num];
        }
        if(model.passwords) {
            [sql appendFormat:@"passwords = '%@', ",model.passwords];
        }
        if(model.remark) {
            [sql appendFormat:@"remark = '%@', ",model.remark];
        }
        if(model.keychain_data) {
            [sql appendFormat:@"keychain_data = '%@', ",model.keychain_data];
        }
        if(model.files_data) {
            [sql appendFormat:@"files_data = '%@', ",model.files_data];
        }
        if(model.device_name) {
            [sql appendFormat:@"device_name = '%@', ",model.device_name];
        }
        if(model.idfa) {
            [sql appendFormat:@"idfa = '%@', ",model.idfa];
        }
        if(model.os_index) {
            [sql appendFormat:@"os_index = %d ",model.os_index.intValue];
        }
        [sql appendFormat:@"where bundle_id = '%@' and account_id = '%@';",model.bundle_id,model.account_id];
        
        
        // 执行 sql 语句
        result = sqlite3_exec(db_handle, sql.UTF8String, NULL, NULL, &error);
        
        if (result != SQLITE_OK) {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
            sqlite3_free(error);
        }
    }else { // 不存在就添加
        NSMutableString *sql = [NSMutableString string];
        // INSERT INTO t_students (name,age) VALUES ('%@',%d);
        [sql appendFormat:@"INSERT INTO app_data "];
        NSMutableString *keys = [NSMutableString string];
        NSMutableString *values = [NSMutableString string];
        [keys appendString:@"("];
        [values appendString:@"("];
        if(model.bundle_id) {
            [keys appendString:@"bundle_id"];
            [values appendFormat:@"'%@'",model.bundle_id];
        }
        if(model.account_id) {
            [keys appendString:@",account_id"];
            [values appendFormat:@",'%@'",model.account_id];
        }
        if(model.phone_num) {
            [keys appendString:@",phone_num"];
            [values appendFormat:@",'%@'",model.phone_num];
        }
        if(model.passwords) {
            [keys appendString:@",passwords"];
            [values appendFormat:@",'%@'",model.passwords];
        }
        if(model.remark) {
            [keys appendString:@",remark"];
            [values appendFormat:@",'%@'",model.remark];
        }
        if(model.keychain_data) {
            [keys appendString:@",keychain_data"];
            [values appendFormat:@",'%@'",model.keychain_data];
        }
        if(model.files_data) {
            [keys appendString:@",files_data"];
            [values appendFormat:@",'%@'",model.files_data];
        }
        if(model.device_name) {
            [keys appendString:@",device_name"];
            [values appendFormat:@",'%@'",model.device_name];
        }
        if(model.idfa) {
            [keys appendString:@",idfa"];
            [values appendFormat:@",'%@'",model.idfa];
        }
        if(model.os_index) {
            [keys appendString:@",os_index"];
            [values appendFormat:@",%d",model.os_index.intValue];
        }
        [keys appendString:@")"];
        [values appendString:@")"];
        [sql appendString:keys];
        [sql appendString:@" VALUES "];
        [sql appendString:values];
        [sql appendString:@";"];
        
        // 执行 sql 语句
        result = sqlite3_exec(db_handle, sql.UTF8String, NULL, NULL, &error);
        
        if (result != SQLITE_OK) {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
            sqlite3_free(error);
        }
    }
    return (result == SQLITE_OK);
}

// 查询
-(NSArray<BackupModel *>*)queryModel:(BackupModel *)model {
    // sql语句
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT * FROM app_data  where bundle_id = '%@';",model.bundle_id];
    
    NSMutableArray<BackupModel *> *backupMutableArray = [NSMutableArray array];
    sqlite3_stmt *stmt = NULL;
    // 进行查询前的准备工作
    if (sqlite3_prepare_v2(db_handle, [sql UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, sqlite3_errmsg(db_handle));
        return [backupMutableArray copy];
    }
    
    // 每调用一次sqlite3_step函数，stmt就会指向下一条记录
    while (sqlite3_step(stmt) == SQLITE_ROW) {  // 找到一条记录
        // 取出数据
        const unsigned char *bundle_id_c = sqlite3_column_text(stmt, 1);
        const unsigned char *account_id_c = sqlite3_column_text(stmt, 2);
        const unsigned char *phone_num_c = sqlite3_column_text(stmt, 3);
        const unsigned char *passwords_c = sqlite3_column_text(stmt, 4);
        const unsigned char *remark_c = sqlite3_column_text(stmt, 5);
        const unsigned char *keychain_data_c = sqlite3_column_text(stmt, 6);
        const unsigned char *files_data_c = sqlite3_column_text(stmt, 7);
        const unsigned char *device_name_c = sqlite3_column_text(stmt, 8);
        const unsigned char *idfa_c = sqlite3_column_text(stmt, 9);
        int os_index_c = sqlite3_column_int(stmt, 10);
        //            printf("%s,%s,%s,%s,%s,%s,%s,%s,%s,%d\n",
        //                        bundle_id_c,
        //                        account_id_c,
        //                        phone_num_c,
        //                        passwords_c,
        //                        remark_c,
        //                        keychain_data_c,
        //                        files_data_c,
        //                        device_name_c,
        //                        idfa_c,
        //                        os_index_c);
        
        if(bundle_id_c) {
            BackupModel * model = [[BackupModel alloc] init];
            model.bundle_id = [NSString stringWithUTF8String:(const char *)bundle_id_c];
            model.account_id = [NSString stringWithUTF8String:(const char *)account_id_c];
            model.phone_num = [NSString stringWithUTF8String:(const char *)phone_num_c];
            model.passwords = [NSString stringWithUTF8String:(const char *)passwords_c];
            model.remark = [NSString stringWithUTF8String:(const char *)remark_c];
            model.keychain_data = [NSString stringWithUTF8String:(const char *)keychain_data_c];
            model.files_data = [NSString stringWithUTF8String:(const char *)files_data_c];
            model.device_name = [NSString stringWithUTF8String:(const char *)device_name_c];
            model.idfa = [NSString stringWithUTF8String:(const char *)idfa_c];
            model.os_index = [NSNumber numberWithInt:os_index_c];
            
            [backupMutableArray addObject:model];
        }
    }
    
    return [backupMutableArray copy];
}

// 删除
-(void)deleteModel:(BackupModel *)model {
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"delete from app_data where bundle_id = '%@' and account_id = '%@';",model.bundle_id,model.account_id];
    
    // 执行 sql 语句
    char *error = NULL;
    int result = sqlite3_exec(db_handle, sql.UTF8String, NULL, NULL, &error);
    
    if (result != SQLITE_OK) {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
        sqlite3_free(error);
    }
}

@end
