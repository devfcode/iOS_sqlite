//
//  MyCell.h
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/23.
//

#import <UIKit/UIKit.h>
#import "BackupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCell : UITableViewCell

@property(nonatomic,strong)BackupModel *model;

@property (weak, nonatomic) IBOutlet UILabel *text11;
@property (weak, nonatomic) IBOutlet UILabel *text21;
@property (weak, nonatomic) IBOutlet UILabel *text31;

@property (weak, nonatomic) IBOutlet UILabel *text12;
@property (weak, nonatomic) IBOutlet UILabel *text22;
@property (weak, nonatomic) IBOutlet UILabel *text32;

@property (weak, nonatomic) IBOutlet UILabel *text13;
@property (weak, nonatomic) IBOutlet UILabel *text23;
@property (weak, nonatomic) IBOutlet UILabel *text33;

@end

NS_ASSUME_NONNULL_END
