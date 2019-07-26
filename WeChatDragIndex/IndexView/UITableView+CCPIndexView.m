#import "UITableView+CCPIndexView.h"
#import "Aspects.h"
#import <objc/runtime.h>


@interface BjLabel : UILabel
@end

@implementation BjLabel
- (instancetype)init {
	if (self = [super init]) {
		self.bounds = CGRectMake([UIScreen mainScreen].bounds.size.width-20, 0, 15, 15);
		self.backgroundColor = [UIColor greenColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = 15/2;
        self.clipsToBounds = YES;
        self.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
	}
	return self;
}
@end

@interface IndexLabel:UILabel
@end

@implementation IndexLabel

- (instancetype)init {
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, 60, 60);
        self.textColor = [UIColor blackColor];
		self.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = 30;
        self.clipsToBounds = YES;
    }
    return self;
}
@end

@interface IndexImageView:UIImageView
@end

@implementation IndexImageView

- (instancetype)init {
	if (self = [super init]) {
		self.bounds = CGRectMake(0, 0, 32, 26);
		[self setImage:[UIImage imageNamed:@"league_icon_qipao"]];
		self.backgroundColor = [UIColor redColor];
	}
	return self;
}

- (void)circelLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(40, 0)];
    [path addLineToPoint:CGPointMake(50, 15)];
    [path addLineToPoint:CGPointMake(40, 30)];
    [path addLineToPoint:CGPointMake(0, 30)];
    [path addArcWithCenter:CGPointMake(0, 20) radius:15 startAngle:M_PI_2 endAngle:M_PI*3/2 clockwise:YES];
    layer.path = path.CGPath;
    [layer setFillColor:[UIColor clearColor].CGColor];
    [layer setStrokeColor:[UIColor redColor].CGColor];
    layer.lineCap = @"round";
    [self.layer insertSublayer:layer atIndex:0];
}
@end

@interface UITableView ()

@property (nonatomic, strong) IndexLabel *idLabel;
@property (nonatomic, strong) BjLabel *bjLabel;
@property (nonatomic, strong) IndexImageView *indexImageView;

@end

static const void *indexLabel_key = &indexLabel_key;
static const void *bjLabel_key = &bjLabel_key;
static const void *indexImageView_key = &indexImageView_key;

@implementation UITableView (CCPIndexView)
// 暗黑的Label
- (void)setIdLabel:(IndexLabel *)idLabel {
    objc_setAssociatedObject(self, indexLabel_key, idLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (IndexLabel *)idLabel {
    return objc_getAssociatedObject(self, &indexLabel_key);
}
// 背景Label
- (void)setBjLabel:(BjLabel *)bjLabel {
	objc_setAssociatedObject(self, bjLabel_key, bjLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BjLabel *)bjLabel {
	return  objc_getAssociatedObject(self, &bjLabel_key);
}
// 水滴imageView
- (void)setIndexImageView:(IndexImageView *)indexImageView {
	objc_setAssociatedObject(self, indexImageView_key, indexImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (IndexImageView *)indexImageView {
	return objc_getAssociatedObject(self, &indexImageView_key);
}

- (void)ccpIndexView {
    if (self.idLabel == nil) {
        self.idLabel = [[IndexLabel alloc] init];
    }
	if (self.bjLabel == nil) {
		self.bjLabel = [[BjLabel alloc] init];
	}
	if (self.indexImageView == nil) {
		self.indexImageView = [[IndexImageView alloc] init];
	}
    id delegate = self.delegate;
    NSAssert(delegate, @"请设置UITableViewDelegate");
    BOOL isRs = [delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)];
    BOOL isRs1 = [delegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)];
    NSAssert(isRs, @"请实现sectionIndexTitlesForTableView:");
    NSAssert(isRs1, @"请实现tableView:sectionForSectionIndexTitle:atIndex:");
    
    [delegate aspect_hookSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>info ,UITableView *tableView, NSString *title, NSInteger index) {
        [self addIndexLabelWithText:title atIndex:index];
    } error:NULL];
}


- (void)addIndexLabelWithText:(NSString *)text atIndex:(NSInteger)idx {
    UIView *aview = self.subviews.lastObject;
    BOOL isIndexView = [NSStringFromClass([aview class]) isEqualToString:@"UITableViewIndex"];
    if (!isIndexView) {
        for (id obj in self.subviews) {
            BOOL isIdx = [NSStringFromClass([obj class]) isEqualToString:@"UITableViewIndex"];
            if (isIdx) {
                aview = obj;
                break;
            }
        }
    }
    CGPoint cp = CGPointMake(-25, CGRectGetHeight(aview.bounds)/2);
    self.idLabel.center = cp;
	
	CGPoint imageCp = CGPointMake(-25, CGRectGetHeight(aview.bounds)/2);
	self.indexImageView.center = imageCp;
    
    CGPoint cp1 = CGPointMake(13, CGRectGetHeight(aview.bounds)/2);
    self.bjLabel.center = cp1;
    if (self.idLabel.superview != aview) {
        [aview addSubview:self.idLabel];
        self.idLabel.hidden = text.length == 0;
		
		[aview addSubview:self.indexImageView];
		self.indexImageView.hidden = text.length == 0;
		
		[aview addSubview:self.bjLabel];
		self.bjLabel.hidden = text.length == 0;
    }
    [aview aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet<UITouch *> *touches,UIEvent *event) {
        UITouch *touch = [touches anyObject];
        CGPoint center = self.idLabel.center;
        center.y = [touch locationInView:aview].y;
        self.idLabel.center = center;
        self.idLabel.hidden = NO;
		
		UITouch *touch0 = [touches anyObject];
		CGPoint center0 = self.indexImageView.center;
		center0.y = [touch0 locationInView:aview].y;
		self.indexImageView.center = center0;
		self.indexImageView.hidden = NO;
		
        UITouch *touch1 = [touches anyObject];
        CGPoint center1 = self.bjLabel.center;
        center1.y = [touch1 locationInView:aview].y;
        self.bjLabel.center = center1;
        self.bjLabel.hidden = NO;
        
        NSLog(@"A");
    } error:NULL];
    [aview aspect_hookSelector:@selector(touchesMoved:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        UITouch *touch = [touches anyObject];
        CGPoint center = self.idLabel.center;
        center.y = [touch locationInView:aview].y;
        self.idLabel.center = center;
        self.idLabel.hidden = NO;
		
		UITouch *touch0 = [touches anyObject];
		CGPoint center0 = self.indexImageView.center;
		center0.y = [touch0 locationInView:aview].y;
		self.indexImageView.center = center0;
		self.indexImageView.hidden = NO;
		
        UITouch *touch1 = [touches anyObject];
        CGPoint center1 = self.bjLabel.center;
        center1.y = [touch1 locationInView:aview].y;
        self.bjLabel.center = center1;
        self.bjLabel.hidden = NO;
        
        NSLog(@"B");
    } error:NULL];
    [aview aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        UITouch *touch = [touches anyObject];
        CGPoint center = self.idLabel.center;
        center.y = [touch locationInView:aview].y;
        self.idLabel.center = center;
        self.idLabel.hidden = YES;
		
		UITouch *touch0 = [touches anyObject];
		CGPoint center0 = self.indexImageView.center;
		center0.y = [touch0 locationInView:aview].y;
		self.indexImageView.center = center0;
		self.indexImageView.hidden = YES;
		self.indexImageView.hidden = YES;
		
        UITouch *touch1 = [touches anyObject];
        CGPoint center1 = self.bjLabel.center;
        center1.y = [touch1 locationInView:aview].y;
        self.bjLabel.center = center1;
        self.bjLabel.hidden = YES;
        
        //NSLog(@"C  %f", center1.y);
    } error:NULL];
    [aview aspect_hookSelector:@selector(touchesCancelled:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        self.idLabel.hidden = YES;
		self.indexImageView.hidden = YES;
		self.bjLabel.hidden = YES;
        NSLog(@"D");
    } error:NULL];
    self.idLabel.text = text;
    self.bjLabel.text = text;
}


@end
