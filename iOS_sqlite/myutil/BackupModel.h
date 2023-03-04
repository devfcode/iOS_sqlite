//
//  BackupModel.h
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackupModel : NSObject

@property(nonatomic,copy)NSString *bundle_id;       // 所备份的应用标识符

@property(nonatomic,copy)NSString *account_id;      // 账户id
@property(nonatomic,copy)NSString *passwords;       // 密码
@property(nonatomic,copy)NSString *phone_num;       // 手机号
@property(nonatomic,copy)NSString *remark;          // 备注

@property(nonatomic,copy)NSString *keychain_data;   // Keychain 数据
@property(nonatomic,copy)NSString *files_data;      // 文件数据
@property(nonatomic,copy)NSString *device_name;     // 设备名字
@property(nonatomic,copy)NSString *idfa;            // 广告标识
@property(nonatomic,strong)NSNumber *os_index;      // 设备信息的序列号

-(BackupModel *)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
