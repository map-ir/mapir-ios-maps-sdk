//
//  SHMapView.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 20/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import "SHMapView.h"
#import "SHURLProtocol.h"
#import "UIImage+Extension.h"
#import "SHSunManager.h"
#import "SHMapViewDelegate.h"
#import "SHEventManager.h"

NSString * const SHMapLogoImageName = @"map-logo";
NSString * const SHCompassImageName = @"compass";
NSString * const SHDefaultMarkerImageName = @"mapir-default-marker";

typedef NS_ENUM(NSUInteger, SHMapUserInterfaceStyle) {
    SHMapUserInterfaceStyleLight,
    SHMapUserInterfaceStyleDark
};

@interface MGLMapView()

- (MGLAnnotationImage *)defaultAnnotationImage;

@end

@interface SHMapView () <SHSunManagerDelegate>

@property (nonatomic, strong) UIView *attributionContainer;
@property (nonatomic, strong) UIView *attributionBackground;

@property (nonatomic, assign, readwrite) SHMapUserInterfaceStyle mapInterfaceStyle;

@property (nonatomic, assign, readwrite) BOOL internalStyleUpdateFlag;

@property (nonatomic, strong) SHSunManager *sunManager;

@property (nonatomic, strong) SHEventManager *eventManager;

@end

@implementation SHMapView

- (instancetype)init
{
    [SHMapView preInitSetup];
    self = [super init];
    if (self) {
        [self setupWithStyleURL:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    [SHMapView preInitSetup];
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithStyleURL:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame apiKey:(NSString *)apiKey
{
    [SHMapView preInitSetup];
    [SHAccountManager setApiKey:apiKey];
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithStyleURL:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame styleURL:(NSURL *)styleURL
{
    [SHMapView preInitSetup];
    self = [super initWithFrame:frame styleURL:styleURL];
    if (self) {
        [self setupWithStyleURL:styleURL];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    [SHMapView preInitSetup];
    self.internalStyleUpdateFlag = true;
    self = [super initWithCoder:coder];
    if (self) {
        [self setupWithStyleURL:nil];
    }
    return self;
}

- (void)setupWithStyleURL:(NSURL *)styleURL
{
    [self setupObservers];

    if (!styleURL)
    {
        styleURL = SHStyle.vernaStyleURL;
    }

    self.autoDarkModeConfiguration = SHAutoDarkModeConfiguration.defaultConfiguration;

    self.eventManager = [[SHEventManager alloc] init];
    [self.eventManager sendLoadEventForStyle:styleURL];
    [self.eventManager setMapView:self];

    self.sunManager = [[SHSunManager alloc] initWithLocation:self.autoDarkModeConfiguration.location];
    self.sunManager.delegate = self;

    if ([styleURL.absoluteString isEqualToString:SHStyle.carmaniaStyleURL.absoluteString])
    {
        _mapInterfaceStyle = SHMapUserInterfaceStyleDark;
    }
    else
    {
        _mapInterfaceStyle = SHMapUserInterfaceStyleLight;
    }

    [self updateLogo];
    [self updateCompassIcon];
    [self setupNewAttribution];
}

- (void)dealloc
{
    [_attributionLabel removeObserver:self forKeyPath:@"hidden"];
    [_attributionLabel removeObserver:self forKeyPath:@"alpha"];

    [_attributionContainer removeObserver:self forKeyPath:@"hidden"];
    [_attributionContainer removeObserver:self forKeyPath:@"alpha"];

    [NSNotificationCenter.defaultCenter removeObserver:self];
}

// MARK: Setup Observers

- (void)setupObservers
{
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceiveUnauthorizedFromResponse:)
                                               name:SHAccountManager.unauthorizedNotification
                                             object:nil];
}

// MARK: Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSString *message = @"Attribution of Map.ir and OpenStreetMap shouldn't be hidden or unreadable unless noticed in another section of the application.";
    if ([keyPath isEqualToString:@"hidden"] && (object == _attributionLabel || object == _attributionContainer))
    {
        NSNumber *hidden = change[NSKeyValueChangeNewKey];
        BOOL newHidden = [hidden boolValue];
        if (newHidden == true)
        {
            NSLog(@"%@", message);
        }
    }
    else if ([keyPath isEqualToString:@"alpha"] && (object == _attributionLabel || object == _attributionContainer))
    {
        NSNumber *alpha = change[NSKeyValueChangeNewKey];
        CGFloat newAlpha = [alpha floatValue];
        if (newAlpha != 1)
        {
            NSLog(@"%@", message);
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveUnauthorizedFromResponse:(NSNotification *)notif
{
    if (self.delegate)
    {
        if ([self.delegate conformsToProtocol:@protocol(SHMapViewDelegate)])
        {
            id<SHMapViewDelegate> delegate = (id<SHMapViewDelegate>)self.delegate;
            if ([delegate respondsToSelector:@selector(mapView:didReceiveUnauthorizedError:)])
            {
                [delegate mapView:self didReceiveUnauthorizedError:(NSError *)notif.object];
            }
        }
    }
}

// MARK: Setup new assets

+ (void)preInitSetup
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableArray *classes = [configuration.protocolClasses mutableCopy];
    [classes insertObject:[SHURLProtocol class] atIndex:0];
    configuration.protocolClasses = classes;

    [MGLNetworkConfiguration.sharedManager setSessionConfiguration:configuration];
}

// MARK: New Attribution

- (void)setupNewAttribution
{
    [self.attributionButton setAlpha:0.0f];

    // Label

    UILabel *attribution = [[UILabel alloc] init];
    [attribution setText:@"© Map © OpenSreetMap"];
    [attribution setFont:[UIFont systemFontOfSize:9]];
    [attribution setTextColor:[UIColor blackColor]];
    [attribution sizeToFit];
    _attributionLabel = attribution;

    // Container

    CGRect containerFrame = CGRectMake(attribution.frame.origin.x - 4,
                                       attribution.frame.origin.y - 1.5,
                                       attribution.frame.size.width + 8,
                                       attribution.frame.size.height + 3);

    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    [containerView.layer setCornerRadius:6.0f];
    [containerView.layer setMasksToBounds:true];
    _attributionContainer = containerView;

    // Background

    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [bgView setAlpha:0.7f];
    _attributionBackground = bgView;

    // Layouts

    [containerView setTranslatesAutoresizingMaskIntoConstraints:false];
    [attribution setTranslatesAutoresizingMaskIntoConstraints:false];

    [containerView addSubview:bgView];
    [containerView addSubview:attribution];
    [self insertSubview:containerView aboveSubview:self.attributionButton];


    NSArray<NSLayoutConstraint *> *constraints = @[
        [containerView.centerXAnchor constraintEqualToAnchor:attribution.centerXAnchor],
        [containerView.centerYAnchor constraintEqualToAnchor:attribution.centerYAnchor],

        [containerView.heightAnchor constraintEqualToConstant:containerView.frame.size.height],
        [containerView.widthAnchor constraintEqualToConstant:containerView.frame.size.width],

        [attribution.heightAnchor constraintEqualToConstant:attribution.frame.size.height],
        [attribution.widthAnchor constraintEqualToConstant:attribution.frame.size.width],

        [containerView.trailingAnchor constraintEqualToAnchor:self.attributionButton.trailingAnchor],
        [containerView.bottomAnchor constraintEqualToAnchor:self.attributionButton.bottomAnchor]
    ];

    [NSLayoutConstraint activateConstraints:constraints];

    // Observers

    [self.attributionLabel addObserver:self
                            forKeyPath:@"hidden"
                               options:NSKeyValueObservingOptionNew context:nil];
    [self.attributionLabel addObserver:self
                            forKeyPath:@"alpha"
                               options:NSKeyValueObservingOptionNew context:nil];

    [self.attributionContainer addObserver:self
                                forKeyPath:@"hidden"
                                   options:NSKeyValueObservingOptionNew context:nil];
    [self.attributionContainer addObserver:self
                                forKeyPath:@"alpha"
                                   options:NSKeyValueObservingOptionNew context:nil];
}

// MARK: Logo

- (void)updateLogo
{
    UIImage *image = [UIImage imageInCurrentBundleNamed:[self imageNameForCurrentStyleNamed:SHMapLogoImageName]
                          compatibleWithTraitCollection:nil];
    [self.logoView setImage:image];
    [self.logoView setContentMode:UIViewContentModeScaleAspectFit];

    NSArray<NSLayoutConstraint *> *oldConstraints = self.logoView.constraints;

    for (NSLayoutConstraint *constr in oldConstraints)
    {
        if (constr.firstAttribute == NSLayoutAttributeHeight)
        {
            [constr setConstant:37];
        }
        else if (constr.firstAttribute == NSLayoutAttributeWidth)
        {
            [constr setConstant:104];
        }
    }

    [self.logoView layoutIfNeeded];
}

// MARK: Compass Icon

- (void)updateCompassIcon
{
    UIImage *image = [UIImage imageInCurrentBundleNamed:[self imageNameForCurrentStyleNamed:SHCompassImageName]
                          compatibleWithTraitCollection:nil];
    [self.compassView setImage:image];
}

// MARK: Annotation Image

- (MGLAnnotationImage *)defaultAnnotationImage
{
    MGLAnnotationImage *annotationImage = [super defaultAnnotationImage];
    UIImage *image = [UIImage imageInCurrentBundleNamed:SHDefaultMarkerImageName compatibleWithTraitCollection:nil];

    [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height / 2, 0)];
    if (image)
    {
        [annotationImage setImage:image];
    }

    return annotationImage;
}

// MARK: - Auto Dark Mode

@synthesize autoDarkMode=_autoDarkMode;

- (SHAutoDarkMode)autoDarkMode
{
    return _autoDarkMode;
}

- (void)setAutoDarkMode:(SHAutoDarkMode)autoDarkMode
{
    if (_autoDarkMode == autoDarkMode)
    {
        return;
    }

    if (autoDarkMode == SHAutoDarkModeOff) {
        _autoDarkMode = autoDarkMode;
        if (_sunManager.isRunning)
        {
            [self.sunManager stop];
        }
    }
    else if (autoDarkMode == SHAutoDarkModeUpdateAutomatically)
    {
        _autoDarkMode = autoDarkMode;
        [self.sunManager start];
        self.mapInterfaceStyle = self.sunManager.sunState == SHSunStateOverHorizon ? SHMapUserInterfaceStyleLight : SHMapUserInterfaceStyleDark;
    }
    else if (autoDarkMode == SHAutoDarkModeUpdateWithOS)
    {
        if (@available(iOS 13.0, *))
        {
            _autoDarkMode = autoDarkMode;
            self.mapInterfaceStyle = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ?
                SHMapUserInterfaceStyleDark : SHMapUserInterfaceStyleLight;
        }
        else
        {
            _autoDarkMode = SHAutoDarkModeOff;
            NSLog(@"`SHAutoDarkModeUpdateWithOS` is not available in versions older than iOS 13.0.");
        }
    }
}

@synthesize autoDarkModeConfiguration = _autoDarkModeConfiguration;

- (SHAutoDarkModeConfiguration *)autoDarkModeConfiguration
{
    return _autoDarkModeConfiguration;
}

- (void)setAutoDarkModeConfiguration:(SHAutoDarkModeConfiguration *)config
{
    if (!config)
    {
        config = SHAutoDarkModeConfiguration.defaultConfiguration;
    }
    _autoDarkModeConfiguration = config;
    self.sunManager.location = config.location;
}

@synthesize mapInterfaceStyle=_mapInterfaceStyle;

- (SHMapUserInterfaceStyle)mapInterfaceStyle
{
    return _mapInterfaceStyle;
}

- (void)setMapInterfaceStyle:(SHMapUserInterfaceStyle)mapInterfaceStyle
{
    if (mapInterfaceStyle != _mapInterfaceStyle)
    {
        self.internalStyleUpdateFlag = true;
        if (mapInterfaceStyle == SHMapUserInterfaceStyleDark)
        {
            self.styleURL = self.autoDarkModeConfiguration.darkStyleURL;
        }
        else
        {
            self.styleURL = self.autoDarkModeConfiguration.lightStyleURL;
        }
    }
    _mapInterfaceStyle = mapInterfaceStyle;
}

// MARK: Updates received by iOS interface updates

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];

    // As "auto dark mode based on OS user interface style" only works on iOS 13 and above:
    if (@available(iOS 13.0, *)) {
        if (self.autoDarkMode == SHAutoDarkModeUpdateWithOS)
        {
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
            {
                self.mapInterfaceStyle = SHMapUserInterfaceStyleDark;
            }
            else
            {
                self.mapInterfaceStyle = SHMapUserInterfaceStyleLight;
            }
        }
    }
}

// MARK: Updates received by sunset/sunrise

- (void)sunManager:(SHSunManager *)sunManager sunStateChangedToState:(SHSunState)sunState
{
    if (self.autoDarkMode == SHAutoDarkModeUpdateAutomatically)
    {
        self.mapInterfaceStyle = sunState == SHSunStateOverHorizon ?
        SHMapUserInterfaceStyleLight : SHMapUserInterfaceStyleDark;
    }
}

// MARK: - Style update

- (void)setStyleURL:(nullable NSURL *)styleURL
{
    NSURL *oldStyleURL = self.styleURL;
    if (!styleURL)
    {
        styleURL = SHStyle.vernaStyleURL;
    }

    [super setStyleURL:styleURL];

    if (oldStyleURL) {
        if (![oldStyleURL.absoluteString isEqualToString:styleURL.absoluteString])
        {
            [self updateLogoAndAttributionAndCompassForCurrentStyle];
        }

        // If user updates the style, auto dark mode turns off.
        if (!self.internalStyleUpdateFlag && self.autoDarkMode != SHAutoDarkModeOff)
        {
            self.autoDarkMode = SHAutoDarkModeOff;
            NSLog(@"Auto dark mode is turned off, because you updated style.");

            if (self.eventManager) {
                [self.eventManager sendLoadEventForStyle:styleURL];
            }
        }
    }

    self.internalStyleUpdateFlag = false;
}

- (void)updateLogoAndAttributionAndCompassForCurrentStyle
{
    UIImage *logoImage = [UIImage imageInCurrentBundleNamed:[self imageNameForCurrentStyleNamed:SHMapLogoImageName]
                         compatibleWithTraitCollection:nil];
    UIImage *compassImage = [UIImage imageInCurrentBundleNamed:[self imageNameForCurrentStyleNamed:SHCompassImageName]
                            compatibleWithTraitCollection:nil];

    [self.logoView setImage:logoImage];
    [self.compassView setImage:compassImage];

    if ([self isStyleDark])
    {
        [self.attributionBackground setBackgroundColor:UIColor.blackColor];
        [self.attributionLabel setTextColor:UIColor.whiteColor];
    }
    else
    {
        [self.attributionBackground setBackgroundColor:UIColor.whiteColor];
        [self.attributionLabel setTextColor:UIColor.blackColor];
    }
}

- (BOOL)isStyleDark
{
    if ([self.styleURL.absoluteString isEqualToString:SHStyle.carmaniaStyleURL.absoluteString])
    {
        return true;
    }
    return false;
}


// MARK: Util methods

- (NSString *)imageNameForCurrentStyleNamed:(NSString *)imageName
{
    if ([self isStyleDark])
    {
        imageName = [imageName stringByAppendingString:@"-dark"];
    }
    else
    {
        imageName = [imageName stringByAppendingString:@"-light"];
    }
    return imageName;
}

@end
