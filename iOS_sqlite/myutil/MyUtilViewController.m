//
//  MyUtilViewController.m
//  iOS_sqlite
//
//  Created by Dio Brand on 2023/2/22.
//

#import "MyUtilViewController.h"
#import "SQLiteUtil.h"
#import "MyCell.h"

static int num = 100;
static NSString *cellID = @"mycellid";
@interface MyUtilViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *account_id_tf;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong) NSArray<BackupModel *> *dataArr;

@end

@implementation MyUtilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"自定义工具";
    self.account_id_tf.delegate = self;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
}

- (IBAction)addActioin:(UIButton *)sender {
    BackupModel *model = [BackupModel new];
    model.bundle_id = @"com.tencent.xin";
    model.account_id = [NSString stringWithFormat:@"wxid%d",num++];
    model.phone_num = [NSString stringWithFormat:@"1389738%d", arc4random() % 1000];
    model.passwords = [NSString stringWithFormat:@"TFG%dTYFDNCX", arc4random() % 10000];
    model.remark = @"自动化脚本注册";
    model.keychain_data = @"keychain";
    model.files_data = @"filedata";
    model.device_name = @"iPhone";
    model.idfa = [[NSUUID UUID] UUIDString];
    model.os_index = [NSNumber numberWithInt:arc4random() % 5000];
    [[SQLiteUtil sharedManager] addModel:model];
}

- (IBAction)delAction:(UIButton *)sender {
    if(self.account_id_tf.text) {
        BackupModel *model = [BackupModel new];
        model.bundle_id = @"com.tencent.xin";
        model.account_id = self.account_id_tf.text;
        [[SQLiteUtil sharedManager] deleteModel:model];
    }
}

- (IBAction)queryAction:(UIButton *)sender {
    BackupModel *model = [BackupModel new];
    model.bundle_id = @"com.tencent.xin";
    self.dataArr = [[SQLiteUtil sharedManager] queryModel:model];
    
    [self.myTableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *cell = (MyCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
