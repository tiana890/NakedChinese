//
//  NCInteractionView.m
//  NCInteractionView
//
//  Created by Dmitriy Karachentsov on 15.08.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCInteractionView.h"

#import "NCInteractionManager.h"

@interface NCInteractionView ()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *cloudView;
@property (strong, nonatomic) UIImageView *landscapeView;

@property (strong, nonatomic) UIImageView *leftRoofView;
@property (strong, nonatomic) UIImageView *rightRoofView;

@property (strong, nonatomic) UIButton *hellmanBtn;
@property (strong, nonatomic) UIButton *hellgirlBtn;

@property (assign, nonatomic) BOOL hasInitialConstrains;

@end

@implementation NCInteractionView

#pragma mark - Lifecycle

+ (instancetype)interactionWithHell:(NCHell)interactionHell {
    return [[self alloc] initWithHell:interactionHell];
}

+ (instancetype)interactionRandomHell {
    NCHell hell = [self randomHell];
    return [[self alloc] initWithHell:hell];
}

- (instancetype)init {
    return [self initWithHell:NCHellMan];
}

- (instancetype)initWithHell:(NCHell)hell {
    self = [super init];
    if (self) {
        self.hell = hell;
        self.hasInitialConstrains = NO;
        [self setup];
    }
    return self;
}

#pragma mark - Custom Accessors

#pragma mark Landscapes
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        UIImage *backgroundImage = [UIImage imageNamed:@"interaction-bg"];
        _backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backgroundView;
}
- (UIImageView *)cloudView {
    if (!_cloudView) {
        UIImage *cloudImage = [UIImage imageNamed:@"interaction-clouds"];
        _cloudView = [[UIImageView alloc] initWithImage:cloudImage];
        _cloudView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cloudView;
}
- (UIImageView *)landscapeView {
    if (!_landscapeView) {
        UIImage *landscapeImage = [UIImage imageNamed:@"interaction-landscape"];
        _landscapeView = [[UIImageView alloc] initWithImage:landscapeImage];
        _landscapeView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _landscapeView;
}
#pragma mark Roofs

- (UIImageView *)leftRoofView {
    if (!_leftRoofView) {
        UIImage *leftRoofImage = [UIImage imageNamed:@"interaction-roof-left"];
        _leftRoofView = [[UIImageView alloc] initWithImage:leftRoofImage];
        _leftRoofView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftRoofView;
}

- (UIImageView *)rightRoofView {
    if (!_rightRoofView) {
        UIImage *rightRoofImage = [UIImage imageNamed:@"interaction-roof-right"];
        _rightRoofView = [[UIImageView alloc] initWithImage:rightRoofImage];
        _rightRoofView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightRoofView;
}

#pragma mark Characters

- (UIButton *)hellmanBtn {
    if (!_hellmanBtn) {
        UIImage *hellmanImage = [UIImage imageNamed:@"interaction-hellman"];
        _hellmanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hellmanBtn setImage:hellmanImage forState:UIControlStateNormal];
        [_hellmanBtn addTarget:self action:@selector(hellmanAction:) forControlEvents:UIControlEventTouchUpInside];
        _hellmanBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _hellmanBtn;
}

- (UIButton *)hellgirlBtn {
    if (!_hellgirlBtn) {
        UIImage *hellgirlImage = [UIImage imageNamed:@"interaction-hellgirl"];
        _hellgirlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hellgirlBtn setImage:hellgirlImage forState:UIControlStateNormal];
        [_hellgirlBtn addTarget:self action:@selector(hellgirlAction:) forControlEvents:UIControlEventTouchUpInside];
        _hellgirlBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _hellgirlBtn;
}

#pragma mark - IBActions

- (IBAction)hellmanAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(interactionView:actionHell:)]) {
        [self.delegate interactionView:self actionHell:NCHellMan];
    }
}

- (IBAction)hellgirlAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(interactionView:actionHell:)]) {
        [self.delegate interactionView:self actionHell:NCHellGirl];
    }
}

#pragma mark - Private

- (void)setup {
    
    [self addSubview:[self backgroundView]];
    [self addSubview:[self cloudView]];
    [self addSubview:[self landscapeView]];
    
    [self addParralaxOnBackViews];
    
    switch ([self hell]) {
        case NCHellNotRequired:
        case NCHellGirl:
            
            [self addSubview:self.rightRoofView];
            [self addSubview:self.hellgirlBtn];
            
            [self addHorizontalAndVerticalParralaxToHellBtn:self.hellgirlBtn andToRoofView:self.rightRoofView];
            
            break;
        case NCHellMan:
            
            [self addSubview:self.leftRoofView];
            [self addSubview:self.hellmanBtn];
            
            [self addHorizontalAndVerticalParralaxToHellBtn:self.hellmanBtn andToRoofView:self.leftRoofView];
            
            break;
    }
    
    //[self setNeedsUpdateConstraints];
}

+ (NCHell)randomHell {
    //изменили randomHell на упорядоченный
    NSInteger rValue = 1;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    BOOL ifGirl = [def boolForKey:@"ifGirl"];
    if(ifGirl)
    {
        rValue = 2;
        [def setBool:NO forKey:@"ifGirl"];
    }
    else
    {
        rValue = 1;
        [def setBool:YES forKey:@"ifGirl"];
    }
    [def synchronize];
    //NSUInteger rValue = arc4random_uniform(2) + 1;
    return (NCHell)rValue;
}

- (void)addParralaxOnBackViews {
    [self addParralaxWithKeyPath:@"center.x"
                        withType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis
                 minimumRelative:50
                 maximumRelative:-50
                          toView:self.cloudView];
    [self addParralaxWithKeyPath:@"center.y"
                        withType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis
                 minimumRelative:40
                 maximumRelative:-40
                          toView:self.cloudView];
    
    [self addParralaxWithKeyPath:@"center.x"
                        withType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis
                 minimumRelative:50
                 maximumRelative:-50
                          toView:self.landscapeView];
    [self addParralaxWithKeyPath:@"center.y"
                        withType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis
                 minimumRelative:40
                 maximumRelative:0
                          toView:self.landscapeView];
    
    [self addParralaxWithKeyPath:@"center.x"
                        withType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis
                 minimumRelative:100
                 maximumRelative:-100
                          toView:self.backgroundView];
    
    [self addParralaxWithKeyPath:@"center.y"
                        withType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis
                 minimumRelative:40
                 maximumRelative:-40
                          toView:self.backgroundView];
}

- (CGSize)screenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size;
}

#pragma mark Parallax Effects

- (void)addHorizontalAndVerticalParralaxToHellBtn:(UIButton *)hellBtn andToRoofView:(UIView *)roofView {
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-50);
    horizontalMotionEffect.maximumRelativeValue = @(50);
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-50);
    verticalMotionEffect.maximumRelativeValue = @(50);
    
    UIMotionEffectGroup *effectsGroup = [UIMotionEffectGroup new];
    effectsGroup.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [hellBtn addMotionEffect:effectsGroup];
    [roofView addMotionEffect:effectsGroup];
}

- (void)addParralaxWithKeyPath:(NSString *)keyPath withType:(UIInterpolatingMotionEffectType)type minimumRelative:(CGFloat)minValue maximumRelative:(CGFloat)maxValue toView:(UIView *)view  {
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:keyPath
     type:type];
    horizontalMotionEffect.minimumRelativeValue = @(minValue);
    horizontalMotionEffect.maximumRelativeValue = @(maxValue);
    
    // Add both effects to your view
    [view addMotionEffect:horizontalMotionEffect];
}

#pragma mark Constraints

- (void)setupInitialConstraints {
    __weak NCInteractionView *interactionView = self;
    interactionView.frame = (CGRect){CGPointZero, [self screenSize]};
    interactionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(interactionView);
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[interactionView]|" options:0 metrics:0 views:views]];
    
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[interactionView]|" options:0 metrics:0 views:views]];
}

- (void)addSizesConstraints:(CGSize)size toView:(UIView *)view {
    NSLayoutConstraint *width = [NSLayoutConstraint
                                 constraintWithItem:view
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                 constant:size.width];
    
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:view
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                  constant:size.height];
    [view addConstraints:@[width, height]];
}


- (void)setupHorizontalCenterOfView:(UIView *)view andAttachByAttribute:(NSLayoutAttribute)attribute withConstant:(CGFloat)constant {
    NSLayoutConstraint *centerConstraint = [NSLayoutConstraint
                                            constraintWithItem:view
                                            attribute:NSLayoutAttributeCenterX
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeCenterX
                                            multiplier:1
                                            constant:0];
    
    NSLayoutConstraint *attributeConstraint = [NSLayoutConstraint
                                               constraintWithItem:view
                                               attribute:attribute
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                               attribute:attribute
                                               multiplier:1
                                               constant:constant];
    
    [self addConstraints:@[centerConstraint,attributeConstraint]];
}

- (void)addConstraintsForLeftRoof {
    NSDictionary *views = NSDictionaryOfVariableBindings(_leftRoofView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftRoofView]-(-110)-|" options:0 metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-30)-[_leftRoofView]" options:0 metrics:0 views:views]];
}

- (void)addConstraintsForHellMan {
    NSDictionary *views = NSDictionaryOfVariableBindings(_hellmanBtn);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hellmanBtn]-65-|" options:0 metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_hellmanBtn]" options:0 metrics:0 views:views]];
}

- (void)addConstraintsForRightRoof {
    NSDictionary *views = NSDictionaryOfVariableBindings(_rightRoofView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightRoofView]-(-89)-|" options:0 metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_rightRoofView]-(-75)-|" options:0 metrics:0 views:views]];
}

- (void)addConstraintsForHellGirl {
    NSDictionary *views = NSDictionaryOfVariableBindings(_hellgirlBtn);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_hellgirlBtn]-52-|" options:0 metrics:0 views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_hellgirlBtn]-17-|" options:0 metrics:0 views:views]];
}

- (void)addConstraintsForLandscapeAtPositionAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint
                                            constraintWithItem:self.landscapeView
                                            attribute:NSLayoutAttributeBottom
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1
                                            constant:0];
    NSLayoutConstraint *attributeConstraint = [NSLayoutConstraint
                                               constraintWithItem:self.landscapeView
                                               attribute:attribute
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                               attribute:attribute
                                               multiplier:1
                                               constant:constant];
    
    [self addConstraints:@[attributeConstraint, bottomConstraint]];
}

#pragma mark - UIView

- (void)updateConstraints {
    
    if (!self.hasInitialConstrains) {
        [self setupInitialConstraints];
    }
    
    [self addSizesConstraints:[self.backgroundView image].size toView:self.backgroundView];
    [self addSizesConstraints:[self.cloudView image].size toView:self.cloudView];
    [self addSizesConstraints:[self.landscapeView image].size toView:self.landscapeView];
    
    switch ([self hell]) {
        case NCHellNotRequired:
        case NCHellGirl:
            [self addSizesConstraints:[self.rightRoofView image].size toView:self.rightRoofView];
            
            CGSize hellGirlSize = [self.hellgirlBtn imageForState:UIControlStateNormal].size;
            [self addSizesConstraints:hellGirlSize toView:self.hellgirlBtn];
            
            [self addConstraintsForLandscapeAtPositionAttribute:NSLayoutAttributeRight constant:100];
            
            [self addConstraintsForRightRoof];
            [self addConstraintsForHellGirl];
            break;
        case NCHellMan:
            [self addSizesConstraints:[self.leftRoofView image].size toView:self.leftRoofView];
            
            CGSize hellManSize = [self.hellmanBtn imageForState:UIControlStateNormal].size;
            [self addSizesConstraints:hellManSize toView:self.hellmanBtn];
            
            [self addConstraintsForLandscapeAtPositionAttribute:NSLayoutAttributeLeft constant:-100];
            
            [self addConstraintsForLeftRoof];
            [self addConstraintsForHellMan];
            break;
    }
    //-50
    [self setupHorizontalCenterOfView:self.backgroundView andAttachByAttribute:NSLayoutAttributeBottom withConstant:-150];
    [self setupHorizontalCenterOfView:self.cloudView andAttachByAttribute:NSLayoutAttributeTop withConstant:-80];
   
    
    [super updateConstraints];
    
}

#pragma mark - NSObject

- (void)awakeFromNib {
    self.hasInitialConstrains = YES;
    self.hell = [NCInteractionView randomHell];
    [self setup];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
