#import <UIKit/UIKit.h>

//! Project version number for GPUImageFramework.
FOUNDATION_EXPORT double GPUImageFrameworkVersionNumber;

//! Project version string for GPUImageFramework.
FOUNDATION_EXPORT const unsigned char GPUImageFrameworkVersionString[];

#import <GPUImage/GLProgram.h>

// Base classes
#import <GPUImage/GPUImageBuffer.h>
#import <GPUImage/GPUImageContext.h>
#import <GPUImage/GPUImageFilterGroup.h>
#import <GPUImage/GPUImageFilterPipeline.h>
#import <GPUImage/GPUImageFramebuffer.h>
#import <GPUImage/GPUImageFramebufferCache.h>
#import <GPUImage/GPUImageMovie.h>
#import <GPUImage/GPUImageMovieWriter.h>
#import <GPUImage/GPUImageOutput.h>
#import <GPUImage/GPUImagePicture.h>
#import <GPUImage/GPUImageRawDataInput.h>
#import <GPUImage/GPUImageRawDataOutput.h>
#import <GPUImage/GPUImageStillCamera.h>
#import <GPUImage/GPUImageTextureInput.h>
#import <GPUImage/GPUImageTextureOutput.h>
#import <GPUImage/GPUImageUIElement.h>
#import <GPUImage/GPUImageVideoCamera.h>
#import <GPUImage/GPUImageView.h>

// Filters
#import <GPUImage/GPUImage3x3ConvolutionFilter.h>
#import <GPUImage/GPUImageAdaptiveThresholdFilter.h>
#import <GPUImage/GPUImageAddBlendFilter.h>
#import <GPUImage/GPUImageAlphaBlendFilter.h>
#import <GPUImage/GPUImageAmatorkaFilter.h>
#import <GPUImage/GPUImageAverageColor.h>
#import <GPUImage/GPUImageAverageLuminanceThresholdFilter.h>
#import <GPUImage/GPUImageBilateralFilter.h>
#import <GPUImage/GPUImageBoxBlurFilter.h>
#import <GPUImage/GPUImageBrightnessFilter.h>
#import <GPUImage/GPUImageBulgeDistortionFilter.h>
#import <GPUImage/GPUImageCGAColorspaceFilter.h>
#import <GPUImage/GPUImageCannyEdgeDetectionFilter.h>
#import <GPUImage/GPUImageChromaKeyBlendFilter.h>
#import <GPUImage/GPUImageChromaKeyFilter.h>
#import <GPUImage/GPUImageClosingFilter.h>
#import <GPUImage/GPUImageColorBlendFilter.h>
#import <GPUImage/GPUImageColorBurnBlendFilter.h>
#import <GPUImage/GPUImageColorDodgeBlendFilter.h>
#import <GPUImage/GPUImageColorInvertFilter.h>
#import <GPUImage/GPUImageColorLocalBinaryPatternFilter.h>
#import <GPUImage/GPUImageColorPackingFilter.h>
#import <GPUImage/GPUImageColourFASTFeatureDetector.h>
#import <GPUImage/GPUImageColourFASTSamplingOperation.h>
#import <GPUImage/GPUImageContrastFilter.h>
#import <GPUImage/GPUImageCropFilter.h>
#import <GPUImage/GPUImageCrosshairGenerator.h>
#import <GPUImage/GPUImageCrosshatchFilter.h>
#import <GPUImage/GPUImageDarkenBlendFilter.h>
#import <GPUImage/GPUImageDifferenceBlendFilter.h>
#import <GPUImage/GPUImageDilationFilter.h>
#import <GPUImage/GPUImageDirectionalNonMaximumSuppressionFilter.h>
#import <GPUImage/GPUImageDirectionalSobelEdgeDetectionFilter.h>
#import <GPUImage/GPUImageDissolveBlendFilter.h>
#import <GPUImage/GPUImageDivideBlendFilter.h>
#import <GPUImage/GPUImageEmbossFilter.h>
#import <GPUImage/GPUImageErosionFilter.h>
#import <GPUImage/GPUImageExclusionBlendFilter.h>
#import <GPUImage/GPUImageExposureFilter.h>
#import <GPUImage/GPUImageFASTCornerDetectionFilter.h>
#import <GPUImage/GPUImageFalseColorFilter.h>
#import <GPUImage/GPUImageFilter.h>
#import <GPUImage/GPUImageFourInputFilter.h>
#import <GPUImage/GPUImageGammaFilter.h>
#import <GPUImage/GPUImageGaussianBlurFilter.h>
#import <GPUImage/GPUImageGaussianBlurPositionFilter.h>
#import <GPUImage/GPUImageGaussianSelectiveBlurFilter.h>
#import <GPUImage/GPUImageGlassSphereFilter.h>
#import <GPUImage/GPUImageGrayscaleFilter.h>
#import <GPUImage/GPUImageHSBFilter.h>
#import <GPUImage/GPUImageHalftoneFilter.h>
#import <GPUImage/GPUImageHardLightBlendFilter.h>
#import <GPUImage/GPUImageHarrisCornerDetectionFilter.h>
#import <GPUImage/GPUImageHazeFilter.h>
#import <GPUImage/GPUImageHighPassFilter.h>
#import <GPUImage/GPUImageHighlightShadowFilter.h>
#import <GPUImage/GPUImageHistogramFilter.h>
#import <GPUImage/GPUImageHistogramGenerator.h>
#import <GPUImage/GPUImageHoughTransformLineDetector.h>
#import <GPUImage/GPUImageHueBlendFilter.h>
#import <GPUImage/GPUImageHueFilter.h>
#import <GPUImage/GPUImageJFAVoronoiFilter.h>
#import <GPUImage/GPUImageKuwaharaFilter.h>
#import <GPUImage/GPUImageKuwaharaRadius3Filter.h>
#import <GPUImage/GPUImageLanczosResamplingFilter.h>
#import <GPUImage/GPUImageLaplacianFilter.h>
#import <GPUImage/GPUImageLevelsFilter.h>
#import <GPUImage/GPUImageLightenBlendFilter.h>
#import <GPUImage/GPUImageLineGenerator.h>
#import <GPUImage/GPUImageLinearBurnBlendFilter.h>
#import <GPUImage/GPUImageLocalBinaryPatternFilter.h>
#import <GPUImage/GPUImageLookupFilter.h>
#import <GPUImage/GPUImageLowPassFilter.h>
#import <GPUImage/GPUImageLuminanceRangeFilter.h>
#import <GPUImage/GPUImageLuminanceThresholdFilter.h>
#import <GPUImage/GPUImageLuminosity.h>
#import <GPUImage/GPUImageLuminosityBlendFilter.h>
#import <GPUImage/GPUImageMaskFilter.h>
#import <GPUImage/GPUImageMedianFilter.h>
#import <GPUImage/GPUImageMissEtikateFilter.h>
#import <GPUImage/GPUImageMonochromeFilter.h>
#import <GPUImage/GPUImageMosaicFilter.h>
#import <GPUImage/GPUImageMotionBlurFilter.h>
#import <GPUImage/GPUImageMotionDetector.h>
#import <GPUImage/GPUImageMovieComposition.h>
#import <GPUImage/GPUImageMultiplyBlendFilter.h>
#import <GPUImage/GPUImageNobleCornerDetectionFilter.h>
#import <GPUImage/GPUImageNonMaximumSuppressionFilter.h>
#import <GPUImage/GPUImageNormalBlendFilter.h>
#import <GPUImage/GPUImageOpacityFilter.h>
#import <GPUImage/GPUImageOpeningFilter.h>
#import <GPUImage/GPUImageOverlayBlendFilter.h>
#import <GPUImage/GPUImageParallelCoordinateLineTransformFilter.h>
#import <GPUImage/GPUImagePerlinNoiseFilter.h>
#import <GPUImage/GPUImagePinchDistortionFilter.h>
#import <GPUImage/GPUImagePixellateFilter.h>
#import <GPUImage/GPUImagePixellatePositionFilter.h>
#import <GPUImage/GPUImagePoissonBlendFilter.h>
#import <GPUImage/GPUImagePolarPixellateFilter.h>
#import <GPUImage/GPUImagePolkaDotFilter.h>
#import <GPUImage/GPUImagePosterizeFilter.h>
#import <GPUImage/GPUImagePrewittEdgeDetectionFilter.h>
#import <GPUImage/GPUImageRGBClosingFilter.h>
#import <GPUImage/GPUImageRGBDilationFilter.h>
#import <GPUImage/GPUImageRGBErosionFilter.h>
#import <GPUImage/GPUImageRGBFilter.h>
#import <GPUImage/GPUImageRGBOpeningFilter.h>
#import <GPUImage/GPUImageSaturationBlendFilter.h>
#import <GPUImage/GPUImageSaturationFilter.h>
#import <GPUImage/GPUImageScreenBlendFilter.h>
#import <GPUImage/GPUImageSepiaFilter.h>
#import <GPUImage/GPUImageSharpenFilter.h>
#import <GPUImage/GPUImageShiTomasiFeatureDetectionFilter.h>
#import <GPUImage/GPUImageSingleComponentGaussianBlurFilter.h>
#import <GPUImage/GPUImageSketchFilter.h>
#import <GPUImage/GPUImageSmoothToonFilter.h>
#import <GPUImage/GPUImageSobelEdgeDetectionFilter.h>
#import <GPUImage/GPUImageSoftEleganceFilter.h>
#import <GPUImage/GPUImageSoftLightBlendFilter.h>
#import <GPUImage/GPUImageSolarizeFilter.h>
#import <GPUImage/GPUImageSolidColorGenerator.h>
#import <GPUImage/GPUImageSourceOverBlendFilter.h>
#import <GPUImage/GPUImageSphereRefractionFilter.h>
#import <GPUImage/GPUImageStretchDistortionFilter.h>
#import <GPUImage/GPUImageSubtractBlendFilter.h>
#import <GPUImage/GPUImageSwirlFilter.h>
#import <GPUImage/GPUImageThreeInputFilter.h>
#import <GPUImage/GPUImageThresholdEdgeDetectionFilter.h>
#import <GPUImage/GPUImageThresholdSketchFilter.h>
#import <GPUImage/GPUImageThresholdedNonMaximumSuppressionFilter.h>
#import <GPUImage/GPUImageTiltShiftFilter.h>
#import <GPUImage/GPUImageToneCurveFilter.h>
#import <GPUImage/GPUImageToonFilter.h>
#import <GPUImage/GPUImageTransformFilter.h>
#import <GPUImage/GPUImageTwoInputCrossTextureSamplingFilter.h>
#import <GPUImage/GPUImageTwoInputFilter.h>
#import <GPUImage/GPUImageUnsharpMaskFilter.h>
#import <GPUImage/GPUImageVignetteFilter.h>
#import <GPUImage/GPUImageVoronoiConsumerFilter.h>
#import <GPUImage/GPUImageWeakPixelInclusionFilter.h>
#import <GPUImage/GPUImageWhiteBalanceFilter.h>
#import <GPUImage/GPUImageXYDerivativeFilter.h>
#import <GPUImage/GPUImageZoomBlurFilter.h>
#import <GPUImage/GPUImageiOSBlurFilter.h>