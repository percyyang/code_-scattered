//
//  RulerReportCell.m
//  GoodType
//
//  Created by Senchor on 2018/1/12.
//  Copyright © 2018年 Senchor. All rights reserved.
//

#import "RulerReportCell.h"

@interface RulerReportCell ()

@property (nonatomic, strong) RulerReportModel *foldModel;

@end

@implementation RulerReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)bindModel:(RulerReportModel *)model {
    // 不触发点击底色
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.foldModel = model;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = 0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    if (model.fold) {
        count = model.arrM.count < 5 ? model.arrM.count : 5;
        for (NSInteger index = 0; index < count; index++) {
            if (index == 0) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 44*index, width-15*2, 44)];
                button.backgroundColor = [UIColor whiteColor];
                [button addTarget:self action:@selector(godIndexClick) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:button];
                
                CGFloat buttonWidth = button.frame.size.width;
                
                UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 2)];
                lineView.image = [UIImage drawLineOfDashByImageView:lineView];
                [button addSubview:lineView];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4.5, 35, 35)];
                imageView.image = [UIImage imageNamed:model.arrM[index][@"image"]];
                [button addSubview:imageView];
                
                UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 10, 150, 30)];
                titleLB.textColor = [UIColor mainFontColor];
                titleLB.font = [UIFont systemFontOfSize:12.0];
                titleLB.text = model.arrM[index][@"title"];
                [button addSubview:titleLB];
                
                UIImageView *jiantouImageV = [[UIImageView alloc] initWithFrame:CGRectMake(buttonWidth-15, 18, 10, 12)];
                jiantouImageV.image = [UIImage imageNamed:@"right_arrows"];
                [button addSubview:jiantouImageV];
                
                UILabel *valueLB = [[UILabel alloc] initWithFrame:CGRectMake(buttonWidth-120, 10, 100, 30)];
                valueLB.textColor = [UIColor mainGreenColor];
                valueLB.font = [UIFont systemFontOfSize:12.0];
                valueLB.textAlignment = NSTextAlignmentRight;
                valueLB.text = model.arrM[index][@"value"];
                [button addSubview:valueLB];
            }else {
                UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(15, 44*index, width-15*2, 44)];
                bigView.backgroundColor = [UIColor whiteColor];
                [self.contentView addSubview:bigView];
                
                CGFloat bigViewWidth = bigView.frame.size.width;
                
                UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bigViewWidth, 2)];
                lineView.image = [UIImage drawLineOfDashByImageView:lineView];
                [bigView addSubview:lineView];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4.5, 35, 35)];
                imageView.image = [UIImage imageNamed:model.arrM[index][@"image"]];
                [bigView addSubview:imageView];
                
                UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 10, 150, 30)];
                titleLB.textColor = [UIColor mainFontColor];
                titleLB.font = [UIFont systemFontOfSize:12.0];
                titleLB.text = model.arrM[index][@"title"];
                [bigView addSubview:titleLB];
                
                UILabel *valueLB = [[UILabel alloc] initWithFrame:CGRectMake(bigViewWidth-120, 10, 100, 30)];
                valueLB.textColor = [UIColor mainGreenColor];
                valueLB.font = [UIFont MainFontTheSize:25.0];
                valueLB.textAlignment = NSTextAlignmentRight;
                valueLB.text = model.arrM[index][@"value"];
                [bigView addSubview:valueLB];
            }
        }
    }else {
        count = model.arrM.count;
        for (NSInteger index = 0; index < count; index++) {
            if (index == 0) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 44*index, width-15*2, 44)];
                button.backgroundColor = [UIColor whiteColor];
                [button addTarget:self action:@selector(godIndexClick) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:button];
                
                CGFloat buttonWidth = button.frame.size.width;
                
                UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 2)];
                lineView.image = [UIImage drawLineOfDashByImageView:lineView];
                [button addSubview:lineView];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4.5, 35, 35)];
                imageView.image = [UIImage imageNamed:model.arrM[index][@"image"]];
                [button addSubview:imageView];
                
                UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 10, 150, 30)];
                titleLB.textColor = [UIColor mainFontColor];
                titleLB.font = [UIFont systemFontOfSize:12.0];
                titleLB.text = model.arrM[index][@"title"];
                [button addSubview:titleLB];
                
                UIImageView *jiantouImageV = [[UIImageView alloc] initWithFrame:CGRectMake(buttonWidth-15, 18, 10, 12)];
                jiantouImageV.image = [UIImage imageNamed:@"right_arrows"];
                [button addSubview:jiantouImageV];
                
                UILabel *valueLB = [[UILabel alloc] initWithFrame:CGRectMake(buttonWidth-120, 10, 100, 30)];
                valueLB.textColor = [UIColor mainGreenColor];
                valueLB.font = [UIFont systemFontOfSize:12.0];
                valueLB.textAlignment = NSTextAlignmentRight;
                valueLB.text = model.arrM[index][@"value"];
                [button addSubview:valueLB];
            }else {
                UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(15, 44*index, width-15*2, 44)];
                bigView.backgroundColor = [UIColor whiteColor];
                [self.contentView addSubview:bigView];
                
                CGFloat bigViewWidth = bigView.frame.size.width;
                
                UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bigViewWidth, 2)];
                lineView.image = [UIImage drawLineOfDashByImageView:lineView];
                [bigView addSubview:lineView];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4.5, 35, 35)];
                imageView.image = [UIImage imageNamed:model.arrM[index][@"image"]];
                [bigView addSubview:imageView];
                
                UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 10, 150, 30)];
                titleLB.textColor = [UIColor mainFontColor];
                titleLB.font = [UIFont systemFontOfSize:12.0];
                titleLB.text = model.arrM[index][@"title"];
                [bigView addSubview:titleLB];
                
                UILabel *valueLB = [[UILabel alloc] initWithFrame:CGRectMake(bigViewWidth-120, 10, 100, 30)];
                valueLB.textColor = [UIColor mainGreenColor];
                valueLB.font = [UIFont MainFontTheSize:25.0];
                valueLB.textAlignment = NSTextAlignmentRight;
                valueLB.text = model.arrM[index][@"value"];
                [bigView addSubview:valueLB];
            }
        }
    }
    
    // 展开button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 44 * count, width-20, 20);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor mainFontColor] forState:UIControlStateNormal];
    NSString *title = model.fold ? @"展开所有数据>" : @"收起>";
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self  action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}

- (void)godIndexClick {
    NSLog(@"点击男女神指数");
    self.godJudgeButtonBlock();
}

- (void)btnClick:(UIButton *)sender {
    self.foldModel.fold = !self.foldModel.fold;
    [self.foldModel calCellH];
    self.btnClickComplete();
}

















@end
