#import <UIKit/UIKit.h>
#import <LegacyComponents/TGMediaEditingContext.h>
#import <LegacyComponents/TGMediaSelectionContext.h>

@class AVURLAsset;
@class TGMediaAsset;

@interface TGCameraCapturedVideo : NSObject <TGMediaEditableItem, TGMediaSelectableItem>

@property (nonatomic, readonly) SSignal *avAsset;
@property (nonatomic, readonly) AVURLAsset *immediateAVAsset;
@property (nonatomic, readonly) NSTimeInterval videoDuration;
@property (nonatomic, readonly) bool isAnimation;
@property (nonatomic, readonly) TGMediaAsset *originalAsset;


- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithAsset:(TGMediaAsset *)asset;

- (void)_cleanUp;

@end
