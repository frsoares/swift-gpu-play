//
//  ViewController.swift
//  MetaliOS
//
//  Created by Francisco Soares on 3/29/16.
//  Copyright © 2016 frsoares. All rights reserved.
//

import UIKit
import Metal

class ViewController: MetalViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = [Float](count: 32000, repeatedValue: 30.0)
        
        let result = doublerWithMetal(input)
        
        print("Ok \(result.count) : \(result[result.count-1])")
    }
    
    
    func doublerWithMetal( inputVector:[Float] ) -> [Float] {
        var output : [Float] = [Float](count: 32000, repeatedValue: 0.0)
        
        setupMetal()
        
        let (_, computePipelineState) = setupShaderInMetalPipeline("doubler")
        
        let inputMetalBuffer = createMetalBuffer(inputVector)
        
        let outputMetalBuffer = createMetalBuffer(output)
        
        
        let metalComputeCommandEncoder = metalCommandBuffer.computeCommandEncoder()
        
        metalComputeCommandEncoder.setBuffer(inputMetalBuffer, offset: 0, atIndex: 0)
        metalComputeCommandEncoder.setBuffer(outputMetalBuffer, offset: 0, atIndex: 1)
        
        
        metalComputeCommandEncoder.setComputePipelineState(computePipelineState)
        
        
        let threadExcWidth = computePipelineState.threadExecutionWidth
        
        let threadsPerGroup = MTLSize(width: threadExcWidth, height: 1, depth: 1)
        
        let numThreadgroups = MTLSize(width: (inputVector.count + threadExcWidth)/threadExcWidth, height: 1, depth: 1)
        
        metalComputeCommandEncoder.dispatchThreadgroups(numThreadgroups, threadsPerThreadgroup: threadsPerGroup)
        
        metalComputeCommandEncoder.endEncoding()
        
        print("ouputvector before job is running :  \(output.count)")
        
        let start = NSDate()
        
        metalCommandBuffer.commit()
        metalCommandBuffer.waitUntilCompleted()
        
        print("Time to run network \(NSDate().timeIntervalSinceDate(start))")
        
        let data = NSData(bytesNoCopy: outputMetalBuffer.contents(), length: output.count*sizeof(Float), freeWhenDone: false)
        
        data.getBytes(&output, length: inputVector.count * sizeof(Float))
        
        
        return output
    }
    
}
