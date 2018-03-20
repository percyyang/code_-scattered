//
//  GTSQL.m
//  GoodType
//
//  Created by Senchor on 2017/10/11.
//  Copyright © 2017年 Senchor. All rights reserved.
//

#define GoodTypeSQL [[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GoodTypeSQL.sqlite"]

#import "GTSQL.h"

@implementation GTSQL

+ (instancetype)shareManager {
    static GTSQL *shareManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (FMDatabase *)db {
    if (!_db) {
        _db = [FMDatabase databaseWithPath:GoodTypeSQL];
        [self createUserInfo];
        NSLog(@"数据库地址:%@",GoodTypeSQL);
    }
    return _db;
}

/// 关闭数据库
-(void)closeDB {
    BOOL isClose = [self.db close];
    if (isClose) {
        NSLog(@"关闭成功");
    }else{
        NSLog(@"关闭失败");
    }
}

- (BOOL)deleteDatabase:(NSString *)database
{
    [self.db open];
    BOOL success =  [self.db executeUpdate:[NSString stringWithFormat:@"delete from %@",database]];
    
    if (success) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark --------------- 用户个人数据库 --------------------
// 创建数据库表格
- (void)createUserInfo
{
    _db = [FMDatabase databaseWithPath:GoodTypeSQL];
    
    NSString *userinfos = [NSString stringWithFormat:@"create table if not exists userinfos (id integer primary key autoincrement, iphoneNumber text, parentId text, password text, userName text, isMaster integer, userID text, sex text, height text, birthday text, targetWeight text, photoData text, photoImagePath text, weightUnitStr text, rulerUnit text, deviceArray blob, token text)"];
    
    NSString *historyRecord = [NSString stringWithFormat:@"create table if not exists HistoryRecordTables (id integer primary key autoincrement, userName text, userID text, historyRecordID text, serverTime text, weightTimeStamp double, weight float, temperature float, bmi float, fatRate float, muscle float, moisture float, boneMass float, subcutaneousFat float, BMR float, proteinRate float, visceralFat float, physicalAge float, adc float, weightOriPoint int, weightKgPoint int, weightLbPoint int, weightStPoint int)"];
    
    NSString *deviceTables = [NSString stringWithFormat:@"create table if not exists DeviceTables (id integer primary key autoincrement, userID text, deviceName text, type integer, deviceAddress text, acNumber integer, deviceNewName text, deviceType integer)"];
    
    NSString *rulerHistorySQL = [NSString stringWithFormat:@"create table if not exists RulerTables (id integer primary key autoincrement, userID text, rulerTimeStamp double, serverRulerDataID text, serverRulerTime text, fromDevice text, appVersion text, rulerUnit text, rulerShoulder text, rulerBicep text, rulerChest text, rulerWaist text, rulerHip text, rulerThight text, rulerCalf text)"];
    
    if ([self.db open]) {
        NSLog(@"数据库打开---成功");
        
        BOOL dbBOOLA = [self.db executeUpdate:userinfos];
        BOOL dbBOOLB = [self.db executeUpdate:historyRecord];
        BOOL dbBOOLC = [self.db executeUpdate:deviceTables];
        BOOL dbBOOLD = [self.db executeUpdate:rulerHistorySQL];
        NSLog(@"%@-%@-%@-%@",dbBOOLA ? @"成功" : @"失败",
              dbBOOLB ? @"成功" : @"失败",
              dbBOOLC ? @"成功" : @"失败",
              dbBOOLD ? @"成功" : @"失败");
        
        [self.db close];
    }else {
        NSLog(@"数据库打开---失败");
    }
}

/// 插入新用户
- (BOOL)insertdbWithUserInfo:(GTUserInfo *)userInfo {
    
    NSMutableArray *allUser = [self queryUserAll:userInfo.iphoneNumber];
    if (allUser.count > 0) {
        for (GTUserInfo *nowUser in allUser) {
            NSString *userINFOString = [NSString stringWithFormat:@"%@",userInfo.userID];
            NSString *nowUserInfoString = [NSString stringWithFormat:@"%@",nowUser.userID];
            if ([userINFOString isEqualToString:nowUserInfoString]) {
                NSLog(@"数据库已经有这个用户");
                return NO;
            }
        }
    }
    
    
    // 将设备数组转为NSData
    NSData *deviceData = [NSKeyedArchiver archivedDataWithRootObject:userInfo.deviceArray];
    
    if([self.db open]) {
        BOOL result = [self.db executeUpdate:@"insert into userinfos (iphoneNumber, parentId, password, userName, isMaster, userID, sex, height, birthday, targetWeight , photoData, photoImagePath, weightUnitStr, rulerUnit, deviceArray, token) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                       userInfo.iphoneNumber,
                       userInfo.parentId,
                       userInfo.password,
                       userInfo.userName,
                       userInfo.isMaster,
                       userInfo.userID,
                       userInfo.sex,
                       userInfo.height,
                       userInfo.birthday,
                       userInfo.targetWeight,
                       UIImagePNGRepresentation(userInfo.photoImage),
                       userInfo.photoImagePath,
                       userInfo.weightUnitStr,
                       userInfo.rulerUnit,
                       deviceData,
                       userInfo.token
                       ];
        if (result) {
            return YES;
        }else {
            NSLog(@"插入新用户---失败");
            return NO;
        }
    }
    return NO;
}

/// 查询全部用户
- (NSMutableArray *)queryUserAll:(NSString *)iponeNumber {
    
    [self.db open];
    NSMutableArray *mutableArr = [[NSMutableArray alloc] init];
    @synchronized(self) {
        
        FMResultSet *rs = [self.db executeQuery:@"select * from userinfos where iphoneNumber = ?", iponeNumber];
        
        while (rs.next) {
            GTUserInfo *userInfo = [[GTUserInfo alloc] init];
            userInfo.iphoneNumber = [rs stringForColumn:@"iphoneNumber"];
            userInfo.parentId     = [rs stringForColumn:@"parentId"];
            userInfo.userName     = [rs stringForColumn:@"userName"];
            userInfo.isMaster     = [rs objectForColumn:@"isMaster"];
            userInfo.userID       = [rs stringForColumn:@"userID"];
            userInfo.password     = [rs stringForColumn:@"password"];
            userInfo.sex          = [rs stringForColumn:@"sex"];
            userInfo.height       = [rs stringForColumn:@"height"];
            userInfo.birthday     = [rs stringForColumn:@"birthday"];
            userInfo.targetWeight = [rs stringForColumn:@"targetWeight"];
            userInfo.photoImage   = [UIImage imageWithData:[rs dataForColumn:@"photoData"]];
            userInfo.photoImagePath = [rs stringForColumn:@"photoImagePath"];
            userInfo.weightUnitStr = [rs stringForColumn:@"weightUnitStr"];
            userInfo.rulerUnit     = [rs stringForColumn:@"rulerUnit"];
            userInfo.deviceArray   = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"deviceArray"]];
            userInfo.token         = [rs stringForColumn:@"token"];
            
            [mutableArr addObject:userInfo];
        }
    }
    return mutableArr;
}


/// 用UserID查询用户数据
- (GTUserInfo *)queryUserDataTheID:(NSString *)userID {
    
    [self.db open];
    FMResultSet *rs = [self.db executeQuery:@"select * from userinfos where userID = ?", userID];
    
    GTUserInfo *userInfo = [[GTUserInfo alloc] init];
    
    while (rs.next) {
        userInfo.iphoneNumber = [rs stringForColumn:@"iphoneNumber"];
        userInfo.parentId     = [rs stringForColumn:@"parentId"];
        userInfo.userName     = [rs stringForColumn:@"userName"];
        userInfo.isMaster     = [rs objectForColumn:@"isMaster"];
        userInfo.userID       = [rs stringForColumn:@"userID"];
        userInfo.password     = [rs stringForColumn:@"password"];
        userInfo.sex          = [rs stringForColumn:@"sex"];
        userInfo.height       = [rs stringForColumn:@"height"];
        userInfo.birthday     = [rs stringForColumn:@"birthday"];
        userInfo.targetWeight = [rs stringForColumn:@"targetWeight"];
        userInfo.photoImage   = [UIImage imageWithData:[rs dataForColumn:@"photoData"]];
        userInfo.photoImagePath = [rs stringForColumn:@"photoImagePath"];
        userInfo.weightUnitStr = [rs stringForColumn:@"weightUnitStr"];
        userInfo.rulerUnit     = [rs stringForColumn:@"rulerUnit"];
        userInfo.deviceArray   = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"deviceArray"]];
        userInfo.token         = [rs stringForColumn:@"token"];
    }
    return userInfo;

}

/// 用手机号查询用户数据
- (GTUserInfo *)queryUserDataTheIPhoneNumber:(NSString *)IPhoneNumber {
    
    [self.db open];

    FMResultSet *rs = [self.db executeQuery:@"select * from userinfos where iphoneNumber = ?;", IPhoneNumber];
    
    GTUserInfo *userInfo = [[GTUserInfo alloc] init];
    
    while (rs.next) {
        userInfo.iphoneNumber = [rs stringForColumn:@"iphoneNumber"];
        userInfo.parentId     = [rs stringForColumn:@"parentId"];
        userInfo.userName     = [rs stringForColumn:@"userName"];
        userInfo.isMaster     = [rs objectForColumn:@"isMaster"];
        userInfo.userID       = [rs stringForColumn:@"userID"];
        userInfo.password     = [rs stringForColumn:@"password"];
        userInfo.sex          = [rs stringForColumn:@"sex"];
        userInfo.height       = [rs stringForColumn:@"height"];
        userInfo.birthday     = [rs stringForColumn:@"birthday"];
        userInfo.targetWeight = [rs stringForColumn:@"targetWeight"];
        userInfo.photoImage   = [UIImage imageWithData:[rs dataForColumn:@"photoData"]];
        userInfo.photoImagePath = [rs stringForColumn:@"photoImagePath"];
        userInfo.weightUnitStr= [rs stringForColumn:@"weightUnitStr"];
        userInfo.rulerUnit     = [rs stringForColumn:@"rulerUnit"];
        userInfo.deviceArray   = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"deviceArray"]];
        userInfo.token         = [rs stringForColumn:@"token"];
    }
    return userInfo;
}

/// 返回主用户信息
- (GTUserInfo *)masterInfo {
    [self.db open];
    
    FMResultSet *rs = [self.db executeQuery:@"select * from userinfos where isMaster = ?;",@1];
    
    GTUserInfo *userInfo = [[GTUserInfo alloc] init];
    
    while (rs.next) {
        userInfo.iphoneNumber = [rs stringForColumn:@"iphoneNumber"];
        userInfo.parentId     = [rs stringForColumn:@"parentId"];
        userInfo.userName     = [rs stringForColumn:@"userName"];
        userInfo.isMaster     = [rs objectForColumn:@"isMaster"];
        userInfo.userID       = [rs stringForColumn:@"userID"];
        userInfo.password     = [rs stringForColumn:@"password"];
        userInfo.sex          = [rs stringForColumn:@"sex"];
        userInfo.height       = [rs stringForColumn:@"height"];
        userInfo.birthday     = [rs stringForColumn:@"birthday"];
        userInfo.targetWeight = [rs stringForColumn:@"targetWeight"];
        userInfo.photoImage   = [UIImage imageWithData:[rs dataForColumn:@"photoData"]];
        userInfo.photoImagePath = [rs stringForColumn:@"photoImagePath"];
        userInfo.weightUnitStr= [rs stringForColumn:@"weightUnitStr"];
        userInfo.rulerUnit      = [rs stringForColumn:@"rulerUnit"];
        userInfo.deviceArray   = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"deviceArray"]];
        userInfo.token         = [rs stringForColumn:@"token"];
    }
    return userInfo;
}

// 更新用户数据
- (BOOL)updataWithUserInfo:(GTUserInfo *)userinfo
{
    // 将设备数组转为NSData
    NSData *deviceData = [NSKeyedArchiver archivedDataWithRootObject:userinfo.deviceArray];
//    iphoneNumber、userName、userID、isMaster写入就不能修改了
    [self.db open];
    BOOL result = [self.db executeUpdate:@"update userinfos SET photoData = ? , photoImagePath = ?,userName = ? ,birthday = ? ,height = ? , targetWeight = ?, weightUnitStr = ?, rulerUnit = ? where userID = ?",
                   UIImagePNGRepresentation(userinfo.photoImage), userinfo.photoImagePath,
                   userinfo.userName, userinfo.birthday,
                   userinfo.height, userinfo.targetWeight,
                   userinfo.weightUnitStr, userinfo.rulerUnit,
                   userinfo.userID];
    
    if (result){
        NSLog(@"更新用户完毕");
        return YES;
        
    }else{
        NSLog(@"更新用户出错");
        return NO;
        
    }
}

// 删除用户
- (BOOL)deleteWithUserInfo:(GTUserInfo *)userinfo
{
    [self.db open];
    //删除操作
    BOOL result = [self.db executeUpdate:@"delete from userinfos where userID = ?",userinfo.userID];
    if (result) {
        NSLog(@"删除记录完毕");
        return YES;
    }else {
        NSLog(@"删除记录出错");
        return NO;
    }
}


#pragma mark --------------- 用户的测量数据库 --------------------

/// 插入个人测试数据
- (BOOL)insertdbWithHistoryRecord:(UserInfoModel *)gtHistoryRecord {
    
    [self.db open];
    /// 防止相同用户历史数据被创建
    NSMutableArray *allUserHis = [self queryWithHistoryRecordTheUserID:gtHistoryRecord.userID];
    if (allUserHis.count > 0) {
        for (UserInfoModel *nowUserHis in allUserHis) {
            NSString *userHisString = [NSString stringWithFormat:@"%@",gtHistoryRecord.historyRecordID];
            NSString *nowUserHisString = [NSString stringWithFormat:@"%@",nowUserHis.historyRecordID];
            if ([userHisString isEqualToString:nowUserHisString] &&
                (gtHistoryRecord.weightTimeStamp == nowUserHis.weightTimeStamp)) {
                return NO;
            }
        }
    }
    
    
    NSString *sql = [NSString stringWithFormat:@"insert into HistoryRecordTables ('userName','userID', 'historyRecordID', 'serverTime', 'weightTimeStamp', 'weight', 'temperature', 'bmi', 'fatRate', 'muscle', 'moisture', 'boneMass', 'subcutaneousFat', 'BMR', 'proteinRate', 'visceralFat', 'physicalAge', 'adc', 'weightOriPoint', 'weightKgPoint', 'weightLbPoint', 'weightStPoint') values ('%@', '%@', '%@', '%@', %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %d, %d, %d, %d);",
                     gtHistoryRecord.userName,
                     gtHistoryRecord.userID,
                     gtHistoryRecord.historyRecordID,
                     gtHistoryRecord.serverTime,
                     gtHistoryRecord.weightTimeStamp,
                     gtHistoryRecord.weightsum,
                     gtHistoryRecord.temperature,
                     gtHistoryRecord.BMI,
                     gtHistoryRecord.fatRate,
                     gtHistoryRecord.muscle,
                     gtHistoryRecord.moisture,
                     gtHistoryRecord.boneMass,
                     gtHistoryRecord.subcutaneousFat,
                     gtHistoryRecord.BMR,
                     gtHistoryRecord.proteinRate,
                     gtHistoryRecord.visceralFat,
                     gtHistoryRecord.physicalAge,
                     gtHistoryRecord.newAdc,
                     gtHistoryRecord.weightOriPoint,
                     gtHistoryRecord.weightKgPoint,
                     gtHistoryRecord.weightLbPoint,
                     gtHistoryRecord.weightStPoint];
    BOOL result = [self.db executeUpdate:sql];
    
    if (result) {
        NSLog(@"写入个人用户数据-------成功");
        return YES;
    }else {
        NSLog(@"写入个人用户数据-------失败");
        return NO;
    }
    
}

/// 查询个人测试数据
- (NSMutableArray *)queryWithHistoryRecordTheUserID:(NSString *)userID{
    
    [self.db open];
    NSMutableArray *historys = [[NSMutableArray alloc] init];
    // 1.查询数据  && 要进行时间戳排序出来order by
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM HistoryRecordTables where userID = ? order by weightTimeStamp asc", userID];
    
    while ([rs next]) {
        UserInfoModel *historySingle = [[UserInfoModel alloc] init];
        historySingle.userName = [rs objectForColumn:@"userName"];
        historySingle.userID = [rs objectForColumn:@"userID"];
        historySingle.historyRecordID = [rs objectForColumn:@"historyRecordID"];
        historySingle.serverTime = [rs objectForColumn:@"serverTime"];
        historySingle.weightTimeStamp = [rs doubleForColumn:@"weightTimeStamp"];
        
        historySingle.weightsum = [[rs objectForColumn:@"weight"] floatValue];
        historySingle.temperature = [[rs objectForColumn:@"temperature"] floatValue];
        historySingle.BMI = [[rs objectForColumn:@"bmi"] floatValue];
        historySingle.fatRate = [[rs objectForColumn:@"fatRate"] floatValue];
        historySingle.muscle = [[rs objectForColumn:@"muscle"] floatValue];
        historySingle.moisture = [[rs objectForColumn:@"moisture"] floatValue];
        historySingle.boneMass = [[rs objectForColumn:@"boneMass"] floatValue];
        historySingle.subcutaneousFat = [[rs objectForColumn:@"subcutaneousFat"] floatValue];
        historySingle.BMR = [[rs objectForColumn:@"BMR"] floatValue];
        historySingle.proteinRate = [[rs objectForColumn:@"proteinRate"] floatValue];
        historySingle.visceralFat = [[rs objectForColumn:@"visceralFat"] floatValue];
        historySingle.physicalAge = [[rs objectForColumn:@"physicalAge"] floatValue];
        historySingle.newAdc = [[rs objectForColumn:@"adc"] floatValue];
        historySingle.weightOriPoint = [rs intForColumn:@"weightOriPoint"];
        historySingle.weightKgPoint = [rs intForColumn:@"weightKgPoint"];
        historySingle.weightLbPoint = [rs intForColumn:@"weightLbPoint"];
        historySingle.weightStPoint = [rs intForColumn:@"weightStPoint"];
        [historys addObject:historySingle];
    }
    return historys;
}

/// 查询这个用户在数据库中最大的一条历史数据的ID(historyRecordID)
- (NSString *)queryWithHistoryRecordIDTheUserID:(NSString *)userID {
//    SELECT * FROM Product WHERE (id IN(SELECT MAX([id])   FROM Product  GROUP BY userid))   ORDER BY id DESC
    [self.db open];
    FMResultSet *rs = [self.db executeQuery:@"SELECT MAX(historyRecordID) * FROM HistoryRecordTables WEHERE userID = ?", userID];
    NSString *maxID ;
    while ([rs next]) {
        maxID = [rs objectForColumn:@"historyRecordID"];
    }
    return maxID;
}

/// 删除用户测量数据
- (BOOL)deleteWithHistoryRecord:(UserInfoModel *)gtHistoryRecord {
    [self.db open];
    //删除操作
    BOOL result = [self.db executeUpdate:@"delete from HistoryRecordTables where userID = ? and weightTimeStamp = ?", gtHistoryRecord.userID, [NSNumber numberWithDouble:gtHistoryRecord.weightTimeStamp]];
    if (result) {
        NSLog(@"删除记录-----成功");
        return YES;
    }else {
        NSLog(@"删除记录-----出错");
        return NO;
    }
}

#pragma mark --------------- 蓝牙设备数据库 --------------------
// 创建的蓝牙设备地址表，参数：用户userID, 用户名字，设备蓝牙名称，设备地址，用户修改蓝牙名称

- (BOOL)insertdbWithDevices:(DeviceModel *)device {
    
    [self.db open];
    
    NSMutableArray *sqlDeviceMarray = [self queryDeviceswithUserID:device.userID];
    for (DeviceModel *sqlModel in sqlDeviceMarray) {
        if ([device.deviceAddress isEqualToString:sqlModel.deviceAddress]) {
            // 已经在数据库里面
            return YES;
        }
    }
    if ([NSString stringIsNil:[NSString stringWithFormat:@"%@",device.deviceType]] ) {
        device.deviceType = @1;
    }
    
    BOOL successful = [self.db executeUpdate:@"insert into DeviceTables (userID, deviceName, type, deviceAddress, acNumber, deviceNewName, deviceType) values (?, ?, ?, ?, ?, ?, ?);", device.userID,device.deviceName, device.type, device.deviceAddress, device.acNumber, device.deviceNewName, device.deviceType];
    if (successful) {
        NSLog(@"插入蓝牙设备-------成功");
        return YES;
    }else {
        NSLog(@"插入蓝牙设备------失败");
        return NO;
    }
}

- (BOOL)deletedbWithDevices:(DeviceModel *)device {
    [self.db open];
//    BOOL successful = [self.db executeUpdate:@"delete from DeviceTables where userID = ? and deviceAddress = ?", device.userID,device.deviceAddress];
    BOOL successful = [self.db executeUpdate:@"delete from DeviceTables where deviceAddress = ?", device.deviceAddress];
    if (successful) {
        NSLog(@"删除蓝牙设备-----成功");
        return YES;
    }else {
        NSLog(@"删除蓝牙设备-----失败");
        return NO;
    }
}

/// 更新秤信息
- (BOOL)updataWithDevices:(DeviceModel *)device
{
    [self.db open];
    BOOL result = [self.db executeUpdate:@"update DeviceTables SET deviceNewName = ?  where deviceAddress = ?",
                   device.deviceNewName,device.deviceAddress];
    
    if (result){
        NSLog(@"更新蓝牙设备-----成功");
        return YES;
        
    }else{
        NSLog(@"更新蓝牙设备-----成功");
        return NO;
        
    }
}

- (NSMutableArray *)queryDeviceswithUserID:(NSString *)userID {
    [self.db open];
    // 1.查询数据
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM DeviceTables WHERE userID = ?",userID];
    
    NSMutableArray *deviceS = [[NSMutableArray alloc] init];
    // 2.遍历结果集
    while (rs.next) {
        DeviceModel *model = [[DeviceModel alloc] init];
        model.userID = [rs objectForColumn:@"userID"];
        model.deviceName = [rs objectForColumn:@"deviceName"];
        model.deviceAddress = [rs objectForColumn:@"deviceAddress"];
        model.acNumber = [rs objectForColumn:@"acNumber"];
        model.deviceNewName = [rs objectForColumn:@"deviceNewName"];
        model.type = [rs objectForColumn:@"type"];
        model.deviceType = [rs objectForColumn:@"deviceType"];
        [deviceS addObject:model];
    }
    return deviceS;
}

#pragma - mark --------------- 尺子数据库 --------------------
/// 插入尺子数据
- (BOOL)insertRulerHistoryData:(RulerMeasurementModel *)model {
    [self.db open];
    
    NSMutableArray *allRulerHis = [self queryRulerDataWithUserID:model.userID];
    if (allRulerHis.count > 0) {
        for (RulerMeasurementModel *nowRulerHis in allRulerHis) {
            NSString *userHisString = [NSString stringWithFormat:@"%@",model.serverRulerDataID];
            NSString *nowUserHisString = [NSString stringWithFormat:@"%@",nowRulerHis.serverRulerDataID];
            if ([userHisString isEqualToString:nowUserHisString] &&
                (model.rulerTimeStamp == nowRulerHis.rulerTimeStamp)) {
                NSLog(@"数据库已经有----这组围度尺历史数据");
                return NO;
            }
        }
    }
    
    
    BOOL result = [self.db executeUpdate:@"insert into RulerTables (userID, rulerTimeStamp, serverRulerDataID, serverRulerTime, fromDevice, appVersion, rulerUnit, rulerShoulder, rulerBicep, rulerChest , rulerWaist, rulerHip, rulerThight, rulerCalf) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                   model.userID,
                   model.rulerTimeStamp,
                   model.serverRulerDataID,
                   model.serverRulerTime,
                   model.fromDevice,
                   model.appVersion,
                   model.rulerUnit,
                   model.rulerShoulder,
                   model.rulerBicep,
                   model.rulerChest,
                   model.rulerWaist,
                   model.rulerHip,
                   model.rulerThight,
                   model.rulerCalf
                   ];
    if (result) {
        NSLog(@"插入尺子的数据----成功");
        return YES;
    }else {
        NSLog(@"插入尺子的数据----失败");
        return NO;
    }
}

- (BOOL)deleterRulerHistoryData:(NSString *)serverRulerDataID {
    [self.db open];

    BOOL result = [self.db executeUpdate:@"delete from RulerTables where serverRulerDataID = ?", serverRulerDataID];
    if (result) {
        NSLog(@"删除尺子的数据-----成功");
        return YES;
    }else {
        NSLog(@"删除尺子的数据-----失败");
        return NO;
    }
}

- (NSMutableArray *)queryRulerDataWithUserID:(NSString *)userID {
    [self.db open];
    // 1.查询数据
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM RulerTables WHERE userID = ?",userID];
    
    NSMutableArray *deviceS = [[NSMutableArray alloc] init];
    // 2.遍历结果集
    while (rs.next) {
        RulerMeasurementModel *model = [[RulerMeasurementModel alloc] init];
        model.userID = [rs objectForColumn:@"userID"];
        model.rulerTimeStamp = [rs objectForColumn:@"rulerTimeStamp"];
        model.serverRulerDataID = [rs objectForColumn:@"serverRulerDataID"];
        model.serverRulerTime = [rs objectForColumn:@"serverRulerTime"];
        model.fromDevice = [rs objectForColumn:@"fromDevice"];
        model.appVersion = [rs objectForColumn:@"appVersion"];
        model.rulerUnit = [rs objectForColumn:@"rulerUnit"];
        model.rulerShoulder = [rs objectForColumn:@"rulerShoulder"];
        model.rulerBicep = [rs objectForColumn:@"rulerBicep"];
        model.rulerChest = [rs objectForColumn:@"rulerChest"];
        model.rulerWaist = [rs objectForColumn:@"rulerWaist"];
        model.rulerHip = [rs objectForColumn:@"rulerHip"];
        model.rulerThight = [rs objectForColumn:@"rulerThight"];
        model.rulerCalf = [rs objectForColumn:@"rulerCalf"];
        [deviceS addObject:model];
    }
    return deviceS;
}



























@end
