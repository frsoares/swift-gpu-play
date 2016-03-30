//
//  Shaders.metal
//  MetalOSXTesting
//
//  Created by Francisco Soares on 3/30/16.
//  Copyright © 2016 frsoares. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


kernel void doubler(const device float *inVector [[ buffer(0) ]], device float *outVector [[ buffer(1) ]], uint id [[ thread_position_in_grid ]]) {
    
    outVector[id] = 2*inVector[id];
    
}