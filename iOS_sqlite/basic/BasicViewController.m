//
//  BasicViewController.m
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/22.
//

#import "BasicViewController.h"
#include <sqlite3.h>

@interface BasicViewController ()
{
    sqlite3 *db_handle;    // 句柄
}

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"基础用法";
    [self openSqlDataBase];
}

// 打开数据库
- (BOOL)openSqlDataBase {
    // db_handle是数据库的句柄,即数据库的象征,如果对数据库进行增删改查,就得操作这个示例
    
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    NSLog(@"fileNamePath = %@",fileName);
    // 将 OC 字符串转换为 C 语言的字符串
    const char *cFileName = fileName.UTF8String;
    
    // 打开数据库文件(如果数据库文件不存在,那么该函数会自动创建数据库文件)
    int result = sqlite3_open(cFileName, &db_handle);
    
    if (result != SQLITE_OK) {  // 打开成功
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, sqlite3_errmsg(db_handle));
        return NO;
    }
    [self createTable];
    return YES;
}

- (void)createTable {
    char *error = NULL;
    // 创建表
    const char *sql = "CREATE TABLE IF NOT EXISTS t_students (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL);";
    
    int result = sqlite3_exec(db_handle, sql, NULL, NULL, &error);
    if (result != SQLITE_OK) {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
        sqlite3_free(error);
    }
}

- (IBAction)insertAction:(UIButton *)sender {
    char *error = NULL;
    for (int i = 0; i < 20; i++) {
        NSString *name = [NSString stringWithFormat:@"韩雪--%d",arc4random_uniform(100)];
        int age = arc4random_uniform(20) + 10;
        
        // 拼接 sql 语句
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_students (name,age) VALUES ('%@',%d);",name,age];
        
        // 执行 sql 语句
        int result = sqlite3_exec(db_handle, sql.UTF8String, NULL, NULL, &error);
        
        if (result == SQLITE_OK) {
            NSLog(@"插入数据成功 - %@",name);
        } else {
            fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
            sqlite3_free(error);
        }
    }
}

- (IBAction)updateAction:(UIButton *)sender {
    char *error = NULL;
    // 拼接 sql 语句
    NSString *name = @"Dio";
    int age = 15;
    NSString *sql = [NSString stringWithFormat:@"update t_students set name = '%@' where age > %d;",name,age];
    
    // 执行 sql 语句
    int result = sqlite3_exec(db_handle, sql.UTF8String, NULL, NULL, &error);
    
    if (result == SQLITE_OK) {
        NSLog(@"更新数据成功");
    } else {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
        sqlite3_free(error);
    }
}

- (IBAction)queryAction:(UIButton *)sender {
    // sql语句
    const char *sql="SELECT id,name,age FROM t_students WHERE age < 20;";
    
    sqlite3_stmt *stmt = NULL;
    
    if (sqlite3_prepare_v2(db_handle, sql, -1, &stmt, NULL) != SQLITE_OK) {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, sqlite3_errmsg(db_handle));
        return;
    }
    
    // 每调用一次sqlite3_step函数，stmt就会指向下一条记录
    while (sqlite3_step(stmt) == SQLITE_ROW) {  // 找到一条记录
        // 取出数据
        int ID = sqlite3_column_int(stmt, 0);   // 取出第0列字段的值
        const unsigned char *name = sqlite3_column_text(stmt, 1);   // 取出第1列字段的值
        int age = sqlite3_column_int(stmt, 2);  // 取出第2列字段的值
        printf("%d %s %d\n",ID,name,age);
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    char *error = NULL;
    // 拼接 sql 语句
    int age = 30;
    NSString *sql = [NSString stringWithFormat:@"delete from t_students where age > %d;",age];
    
    // 执行 sql 语句
    int result = sqlite3_exec(db_handle, sql.UTF8String, NULL, NULL, &error);
    
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, error);
        sqlite3_free(error);
    }
}

- (IBAction)queryTable:(UIButton *)sender {
    // sql语句
    const char *sql="SELECT * FROM t_students;";
    
    sqlite3_stmt *stmt = NULL;
    // 进行查询前的准备工作
    if (sqlite3_prepare_v2(db_handle, sql, -1, &stmt, NULL) != SQLITE_OK) {   // sql语句没有问题
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, sqlite3_errmsg(db_handle));
        return;
    }
    NSLog(@"sql语句没有问题");
    
    // 每调用一次sqlite3_step函数，stmt就会指向下一条记录
    while (sqlite3_step(stmt) == SQLITE_ROW) {  // 找到一条记录
        // 取出数据
        int ID = sqlite3_column_int(stmt, 0);   // 取出第0列字段的值
        const unsigned char *name = sqlite3_column_text(stmt, 1);   // 取出第1列字段的值
        int age = sqlite3_column_int(stmt, 2);  // 取出第2列字段的值
        printf("%d %s %d\n",ID,name,age);
    }
}

-(void)dealloc {
    sqlite3_close(db_handle);
}

@end
