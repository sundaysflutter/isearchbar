#import "IsearchbarPlugin.h"
#if __has_include(<isearchbar/isearchbar-Swift.h>)
#import <isearchbar/isearchbar-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "isearchbar-Swift.h"
#endif

@implementation IsearchbarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIsearchbarPlugin registerWithRegistrar:registrar];
}
@end
