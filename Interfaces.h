#import <dlfcn.h>
#import <objc/runtime.h>
#include <sys/sysctl.h>
#import <substrate.h>

#include <arpa/inet.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <net/if.h>


// Start modern status bar interfaces
@interface _UIStatusBarStringView : UILabel
- (NSString *)convertToRomanString:(int)num;
@end

@interface _UIStatusBarItemUpdate : NSObject
@property (assign,nonatomic) BOOL dataChanged;
@end

@interface _UIStatusBarTimeItem
@property (copy) _UIStatusBarStringView *shortTimeView;
@property (copy) _UIStatusBarStringView *pillTimeView;
@end

@interface _UIStatusBarCellularItem
@property (copy) _UIStatusBarStringView *serviceNameView;
@end

// End modern status bar interfaces


// Start legacy status bar interfaces

typedef struct {
    BOOL itemIsEnabled[35];
    char timeString[64];
    char shortTimeString[64];
    int gsmSignalStrengthRaw;
    int gsmSignalStrengthBars;
    char serviceString[100];
    char serviceCrossfadeString[100];
    char serviceImages[2][100];
    char operatorDirectory[1024];
    unsigned serviceContentType;
    int wifiSignalStrengthRaw;
    int wifiSignalStrengthBars;
    unsigned dataNetworkType;
    int batteryCapacity;
    unsigned batteryState;
    char batteryDetailString[150];
    int bluetoothBatteryCapacity;
    int thermalColor;
    unsigned thermalSunlightMode : 1;
    unsigned slowActivity : 1;
    unsigned syncActivity : 1;
    char activityDisplayId[256];
    unsigned bluetoothConnected : 1;
    unsigned displayRawGSMSignal : 1;
    unsigned displayRawWifiSignal : 1;
    unsigned locationIconType : 1;
    unsigned quietModeInactive : 1;
    unsigned tetheringConnectionCount;
    unsigned batterySaverModeActive : 1;
    unsigned deviceIsRTL : 1;
    unsigned lock : 1;
    char breadcrumbTitle[256];
    char breadcrumbSecondaryTitle[256];
    char personName[100];
    unsigned electronicTollCollectionAvailable : 1;
    unsigned wifiLinkWarning : 1;
    unsigned wifiSearching : 1;
    double backgroundActivityDisplayStartDate;
    unsigned shouldShowEmergencyOnlyStatus : 1;
} SCD_Struct_UI61;

@interface UIStatusBarComposedData : NSObject
@property (nonatomic,readonly) SCD_Struct_UI61* rawData;
- (instancetype)initWithRawData:(const SCD_Struct_UI61*)arg1;
@end

@interface UIStatusBarTimeItemView : UIView
- (BOOL)updateForNewData:(id)arg1 actions:(int)arg2;
- (NSString *)convertToRomanString:(int)num;
@end

// End legacy status bar interfaces