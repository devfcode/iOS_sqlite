//
//  MyCell.m
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/23.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.text11.text = self.model.bundle_id;
    self.text12.text = self.model.account_id;
    self.text13.text = self.model.phone_num;

    self.text21.text = self.model.passwords;
    self.text22.text = self.model.remark;
    self.text23.text = self.model.keychain_data;

    self.text31.text = self.model.files_data;
    self.text32.text = self.model.device_name;
    self.text33.text = self.model.idfa;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
