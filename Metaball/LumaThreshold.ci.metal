//
//  LumaThreshold.ci.metal
//  Metaball
//
//  Created by Eugene Mokhan on 15/09/2022.
//

#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

extern "C" float4 lumaThreshold(coreimage::sample_t pixelColor, float threshold, coreimage::destination destination) {
    float3 pixelRGB = pixelColor.rgb;

    float luma = (pixelRGB.r * 0.2126) + (pixelRGB.g * 0.7152) + (pixelRGB.b * 0.0722);

    return (luma > threshold) ? float4(1.0, 1.0, 1.0, 1.0) : float4(0.0, 0.0, 0.0, 0.0);
}
