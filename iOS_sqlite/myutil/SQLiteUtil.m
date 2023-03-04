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
    sqlite3 *_db;    // 句柄
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

// 打开数据库
- (void)openSqlDataBase {
    // _db是数据库的句柄,即数据库的象征,如果对数据库进行增删改查,就得操作这个示例
    
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"backup.sqlite"];
    NSLog(@"fileNamePath = %@",fileName);
    // 将 OC 字符串转换为 C 语言的字符串
    const char *cFileName = fileName.UTF8String;
    
    // 打开数据库文件(如果数据库文件不存在,那么该函数会自动创建数据库文件)
    int result = sqlite3_open(cFileName, &_db);
    
    if (result == SQLITE_OK) {  // 打开成功
        NSLog(@"成功打开数据库");
        [self createTable];
    } else {
        NSLog(@"打开数据库失败");
    }
}

- (void)createTable {
    // 创建表
    const char *sql = "CREATE TABLE IF NOT EXISTS app_data (id integer PRIMARY KEY AUTOINCREMENT,bundle_id text NOT NULL,account_id text NOT NULL,phone_num text,passwords text,remark text,keychain_data text,files_data text,device_name text,idfa text,os_index integer, UNIQUE(bundle_id,account_id) ON CONFLICT REPLACE);";
    char *errMsg = NULL;
    
    int result = sqlite3_exec(_db, sql, NULL, NULL, &errMsg);
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        printf("创表失败---%s----%s---%d",errMsg,__FILE__,__LINE__);
    }
}

// 添加
-(BOOL)addModel:(BackupModel *)model {
    // sql语句
    NSMutableString *sql = [NSMutableString string];
    [sql appendString:@"SELECT count(*) FROM app_data "];
    [sql appendFormat:@"where bundle_id = '%@' and account_id = '%@';",model.bundle_id,model.account_id];
    sqlite3_stmt *stmt = NULL;
    int exist = 0;
    // 进行查询前的准备工作
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {   // sql语句没有问题
        NSLog(@"sql语句没有问题");
        // 每调用一次sqlite3_step函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt) == SQLITE_ROW) {  // 找到一条记录
            // 取出数据
            exist = sqlite3_column_int(stmt, 0);   // 取出第0列字段的值
        }
    } else {
        NSLog(@"查询语句有问题");
        return NO;
    }
    
    int result = -1;
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
        char *errMsg = NULL;
        result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errMsg);
        
        if (result == SQLITE_OK) {
            NSLog(@"更新数据成功");
        } else {
            NSLog(@"更新数据失败 - %s",errMsg);
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
        char *errMsg = NULL;
        result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errMsg);
        
        if (result == SQLITE_OK) {
            NSLog(@"添加数据成功");
        } else {
            NSLog(@"添加数据失败 - %s",errMsg);
        }
    }
    return (result == SQLITE_OK);
}

// 查询
-(NSArray<BackupModel *>*)queryModel:(BackupModel *)model {
    // sql语句
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"SELECT * FROM app_data  where bundle_id = '%@';",model.bundle_id];
    
    sqlite3_stmt *stmt = NULL;
    
    NSMutableArray<BackupModel *> *backupMutableArray = [NSMutableArray array];
    // 进行查询前的准备工作
    if (sqlite3_prepare_v2(_db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {   // sql语句没有问题
        NSLog(@"sql语句没有问题");
        
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
    } else {
        NSLog(@"查询语句有问题");
        return nil;
    }
    return backupMutableArray;
}

// 删除
-(void)deleteModel:(BackupModel *)model {
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"delete from app_data where bundle_id = '%@' and account_id = '%@';",model.bundle_id,model.account_id];
    
    // 执行 sql 语句
    char *errMsg = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &errMsg);
    
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"删除数据失败 - %s",errMsg);
    }
}

@end
