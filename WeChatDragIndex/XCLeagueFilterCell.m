//
//  XCLeagueFilterCell.m
//  AIGuessSDK
//
//  Created by XunCheng_Jack on 2019/7/23.
//

#import "XCLeagueFilterCell.h"
#import <Masonry/Masonry.h>

@interface XCLeagueFilterCell ()
@property(nonatomic, strong)UILabel *bottomLineLabel;
@end

@implementation XCLeagueFilterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// RGB(17, 28, 38)17
		self.opaque = YES;
		self.backgroundColor = [UIColor colorWithRed:17 green:28 blue:38 alpha:1.0];
		
		[self addSubview:self.topLineLabel];
		[self addSubview:self.logonIv];
		[self addSubview:self.titlelabel];
		[self addSubview:self.deatilLabel];
		[self addSubview:self.bottomLineLabel];
		
		[self addConstraint];
	}
	return self;
}

- (void)addConstraint {
	[self.topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-25);
		make.top.equalTo(@0);
		make.height.equalTo(@.2);
	}];
	[self.logonIv mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(10);
		make.width.height.mas_equalTo(30);
		make.centerY.mas_equalTo(self.mas_centerY);
	}];
	[self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.logonIv.mas_right).offset(12);
		make.height.mas_equalTo(20);
		make.centerY.mas_equalTo(self.mas_centerY);
		make.right.mas_equalTo(self.deatilLabel.mas_left);
	}];
	[self.deatilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.equalTo(@0);
		make.right.mas_equalTo(self.mas_right).offset(-28);
		make.width.mas_equalTo(20);
	}];
	[self.bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(15);
		make.right.mas_equalTo(-25);
		make.bottom.equalTo(@0);
		make.height.equalTo(@.5);
	}];
}
- (UIImageView *)logonIv {
	if (!_logonIv) {
		_logonIv = [[UIImageView alloc] init];
		_logonIv.backgroundColor = [UIColor redColor];
		_logonIv.layer.cornerRadius = 30/2;
	}
	return _logonIv;
}
- (UILabel *)titlelabel {
	if (!_titlelabel) {
		_titlelabel = [[UILabel alloc] init];
		_titlelabel.font = [UIFont systemFontOfSize:14];
		_titlelabel.textColor = [UIColor whiteColor];
	}
	return _titlelabel;
}
- (UILabel *)deatilLabel {
	if (!_deatilLabel) {
		_deatilLabel = [[UILabel alloc] init];
		_deatilLabel.font = [UIFont fontWithName:@"LiGothicMed" size:18];
		_deatilLabel.textColor = [UIColor orangeColor];
		_deatilLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _deatilLabel;
}
- (UILabel *)topLineLabel {
	if (!_topLineLabel) {
		_topLineLabel = [[UILabel alloc] init];
		_topLineLabel.backgroundColor = [UIColor lightGrayColor];
	}
	return _topLineLabel;
}
- (UILabel *)bottomLineLabel {
	if (!_bottomLineLabel) {
		_bottomLineLabel = [[UILabel alloc] init];
		_bottomLineLabel.backgroundColor = [UIColor lightGrayColor];
	}
	return _bottomLineLabel;
}
@end
