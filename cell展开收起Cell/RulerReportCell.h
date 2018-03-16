//
//  RulerReportCell.h
//  GoodType
//
//  Created by Senchor on 2018/1/12.
//  Copyright © 2018年 Senchor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulerReportModel.h"

typedef void(^BtnClickComplete)(void);
typedef void(^GodJudgeButtonBlock)(void);

@interface RulerReportCell : UITableViewCell

@property (nonatomic, copy) BtnClickComplete btnClickComplete;

@property (nonatomic, copy) GodJudgeButtonBlock godJudgeButtonBlock;

- (void)bindModel:(RulerReportModel *)model;

@end
