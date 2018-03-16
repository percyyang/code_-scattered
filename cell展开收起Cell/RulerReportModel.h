//
//  RulerReportModel.h
//  GoodType
//
//  Created by Senchor on 2018/1/11.
//  Copyright © 2018年 Senchor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RulerReportModel : NSObject

/// 是否展开
@property (nonatomic, assign) BOOL fold;

/// 服务器记录的ID
@property (nonatomic, copy) NSString *serverRulerDataID;

/// 测量时间
@property (nonatomic, copy) NSString *time;

/// 测量单位
@property (nonatomic, copy) NSString *rulerUnit;

@property (nonatomic, strong) NSMutableArray *arrM;

@property (nonatomic, assign) CGFloat height;

- (CGFloat)calCellH;
@end
