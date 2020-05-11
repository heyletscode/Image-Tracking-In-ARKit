//
//  ViewController.swift
//  Image Tracking Tutorial
//
//  Created by Mihir Singh on 08/05/20.
//  Copyright © 2020 Hey! Let's Code. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var arView: ARView!
    var isEarthAdded = false, isPlaneAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = ARWorldTrackingConfiguration()
        config.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "images", bundle: nil)
        
        config.automaticImageScaleEstimationEnabled = true
        config.maximumNumberOfTrackedImages = 2
        
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        
        arView.session.delegate = self
        
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors {
            
            guard let imageAnchor = anchor as? ARImageAnchor
                else {continue}
            
            var entity: ModelEntity
            
            if (imageAnchor.referenceImage.name == "earth") {
                
                if (isEarthAdded) {
                    continue
                }
                
                isEarthAdded = true
                
                entity = try! Entity.loadModel(named: "earth")
            } else {
                
                if (isPlaneAdded) {
                    continue
                }
                
                isPlaneAdded = true
                
                entity = try! Entity.loadModel(named: "plane")
            }
            
            let anchorEntity = AnchorEntity(anchor: imageAnchor)
            anchorEntity.addChild(entity)
            
            
            arView.scene.addAnchor(anchorEntity)
            
        }
        
    }
    
}
