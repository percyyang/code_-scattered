//
//  GTSQL.h
//  GoodType
//
//  Created by Senchor on 2017/10/11.
//  Copyright © 2017年 Senchor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTUserInfo.h"
#import "UserInfoModel.h"
#import "DeviceModel.h"
#import "RulerMeasurementModel.h"

@interface GTSQL : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareManager;

/// 删除数据个的整个表格：database表名
- (BOOL)deleteDatabase:(NSString *)database;

#pragma mark --------------- 用户数据库 --------------------
/// 创建个人信息数据库表格
- (void)createUserInfo;
/// 插入个人信息新数据
- (BOOL)insertdbWithUserInfo:(GTUserInfo *)userinfo;
/// 查询当前手机全部用户
- (NSMutableArray *)queryUserAll:(NSString *)iponeNumber;
/// 查询UserID用户数据
- (GTUserInfo *)queryUserDataTheID:(NSString *)userID;
/// 用手机号码查询用户数据
- (GTUserInfo *)queryUserDataTheIPhoneNumber:(NSString *)IPhoneNumber;
/// 返回主用户信息
- (GTUserInfo *)masterInfo;
/// 更新用户个人信息数据
- (BOOL)updataWithUserInfo:(GTUserInfo *)userinfo;
/// 删除个人信息用户
- (BOOL)deleteWithUserInfo:(GTUserInfo *)userinfo;


#pragma mark --------------- 测量秤数据库 --------------------
/// *** 创建个人用户测量数据库 ***
/// 插入个人测试数据
- (BOOL)insertdbWithHistoryRecord:(UserInfoModel *)gtHistoryRecord;
/// 请求个人数据
- (NSMutableArray *)queryWithHistoryRecordTheUserID:(NSString *)userID;
/// 删除个人测试用户
- (BOOL)deleteWithHistoryRecord:(UserInfoModel *)gtHistoryRecord;
/// 查询这个用户在数据库中最大的一条历史数据的ID(historyRecordID)
- (NSString *)queryWithHistoryRecordIDTheUserID:(NSString *)userID;


#pragma mark --------------- 设备数据库 --------------------
/// 创建的蓝牙设备地址表，参数：用户名字，设备蓝牙名称，设备地址，用户修改蓝牙名称
/// 添加设备
- (BOOL)insertdbWithDevices:(DeviceModel *)device;
/// 删除设备
- (BOOL)deletedbWithDevices:(DeviceModel *)device;
/// 取出设备
- (NSMutableArray *)queryDeviceswithUserID:(NSString *)userID;
/// 更新秤信息
- (BOOL)updataWithDevices:(DeviceModel *)device;


#pragma mark --------------- 尺子数据库 --------------------
/// 插入尺子数据
- (BOOL)insertRulerHistoryData:(RulerMeasurementModel *)model;
/// 删除尺子数据
- (BOOL)deleterRulerHistoryData:(NSString *)serverRulerDataID;
/// 获取该用户ID的全部尺子数据
- (NSMutableArray *)queryRulerDataWithUserID:(NSString *)userID;



@end
