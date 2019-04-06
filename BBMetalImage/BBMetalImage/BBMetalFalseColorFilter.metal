//
//  BBMetalFalseColorFilter.metal
//  BBMetalImage
//
//  Created by Kaibo Lu on 4/3/19.
//  Copyright © 2019 Kaibo Lu. All rights reserved.
//

#include <metal_stdlib>
#include "BBMetalShaderTypes.h"
using namespace metal;

kernel void falseColorKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                             texture2d<half, access::read> inputTexture [[texture(1)]],
                             device float3 *firstColor [[buffer(0)]],
                             device float3 *secondColor [[buffer(1)]],
                             uint2 gid [[thread_position_in_grid]]) {
    
    const half4 inColor = inputTexture.read(gid);
    const float luminance = dot(inColor.rgb, kLuminanceWeighting);
    const half4 outColor(mix(half3((*firstColor).rgb), half3((*secondColor).rgb), half3(luminance)), inColor.a);
    outputTexture.write(outColor, gid);
}