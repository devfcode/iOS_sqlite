//
//  BackupModel.m
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/22.
//

#import "BackupModel.h"

@implementation BackupModel

-(BackupModel *)initWithDict:(NSDictionary *)dict {
    [self setValuesForKeysWithDictionary:dict];
    return self;
}

//防崩 setValuesForKeysWithDictionary找不到json中value在属性中所对应的值时,走这个方法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@ 没有对应的值!",value);
}

@end
