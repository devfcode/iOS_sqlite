//
//  SQLiteUtil.h
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/22.
//

#import <Foundation/Foundation.h>
#import "BackupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SQLiteUtil : NSObject

+ (instancetype)sharedManager;

// 添加
-(BOOL)addModel:(BackupModel *)model;
// 查询
-(NSArray<BackupModel *>*)queryModel:(BackupModel *)model;
// 删除
-(void)deleteModel:(BackupModel *)model;

@end

NS_ASSUME_NONNULL_END
