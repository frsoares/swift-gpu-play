//
//  MetalViewController.swift
//  MetalOSXTesting
//
//  Created by Francisco Soares on 3/29/16.
//  Copyright © 2016 frsoares. All rights reserved.
//

import Cocoa

class MetalViewController: NSViewController {
    
    var metalDevice : MTLDevice!
    var metalCommandQueue : MTLCommandQueue!
    var metalDefaultLibrary  : MTLLibrary!
    var metalCommandBuffer : MTLCommandBuffer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    func setupMetal(){
        
        //        let copiedDevices = MTLCopyAllDevices()
        metalDevice = MTLCreateSystemDefaultDevice()
        //        metalDevice = copiedDevices[0] // pq isso ao inves de MTLCreate?
        
        metalCommandQueue = metalDevice.newCommandQueue()
        
        metalDefaultLibrary = metalDevice.newDefaultLibrary()
        
        metalCommandBuffer = metalCommandQueue.commandBuffer()
        
    }
    
    func setupShaderInMetalPipeline(shaderName : String) -> (shader:MTLFunction!,
        compPipelineSt : MTLComputePipelineState!) {
            
            let shader = metalDefaultLibrary.newFunctionWithName(shaderName)
            let computePipelineDesc = MTLComputePipelineDescriptor()
            
            computePipelineDesc.computeFunction = shader
            
            var computePipelineState : MTLComputePipelineState? = nil
            do {
                
                computePipelineState = try metalDevice.newComputePipelineStateWithFunction(shader!)
            } catch let error {
                // do nothing
                print("oh, an error occurred: \(error)")
            }
            
            return (shader, computePipelineState)
            
    }
    
    func createMetalBuffer(vector : [Float]) -> MTLBuffer {
        var v = vector
        let byteLength = vector.count*sizeof(Float)
        
        return metalDevice.newBufferWithBytes(&v, length: byteLength, options: .CPUCacheModeDefaultCache)
    }
    
}
