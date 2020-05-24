//
//  TrackerModel.swift
//  SixFeet
//
//  Created by Alexander Englander on 4/27/20.
//  Copyright © 2020 Alexander Englander. All rights reserved.
//

import Foundation
import ARKit

struct TrackerModel {
    private var cylinders: [SCNNode]
    private var isMetric: Bool
    private var distance: Float?
    
    
    init(isMetric: Bool) {
        self.cylinders = [SCNNode]()
        self.isMetric = isMetric
    }
    
    mutating func getDistanceString(nodeUpdate:SCNNode, cameraNode:ARCamera)->String {
        let cameraPosition = SCNVector3Make(cameraNode.transform.columns.3.x,
                                            cameraNode.transform.columns.3.y,
                                            cameraNode.transform.columns.3.z)
        let distance = sqrt( //calculate euclidean distance from camera position to detected figure
            pow((nodeUpdate.worldPosition.x - cameraPosition.x), 2) +
            pow((nodeUpdate.worldPosition.y - cameraPosition.y), 2) +
            pow((nodeUpdate.worldPosition.z - cameraPosition.z), 2)
        )
        if self.isMetric {
            self.distance = distance
            return String(format: "%.2f ", distance)
        } else {
            let distanceInFeet = distance * 3.281
            self.distance = distanceInFeet
            return String(format: "%.2f ", distanceInFeet)
        }
    }
    
    mutating func updateUnits(unitSystem: String) {
        if unitSystem == "Metric" {
            self.isMetric = true
        } else if unitSystem == "Imperial" {
            self.isMetric = false
        }
    }
    
    func getDistance() -> Float? {
        return self.distance
    }
    
    func getDistanceBoundary() -> Float {
        if self.isMetric {
            return 2.0
        } else {
            return 6.0
        }
    }
    
    func getDistanceUnits()->String {
        if self.isMetric {
            return "m"
        } else {
            return "ft"
        }
    }
    mutating func getCylinderNode(vector3: SCNVector3)->SCNNode {
        for cylinder in self.cylinders {
            cylinder.removeFromParentNode()
        }
        let cylinder = SCNCylinder(radius: 0.9144, height: 2.0)
        let cylinderNode = SCNNode()
        
        cylinderNode.position = SCNVector3(x: vector3.x, y: vector3.y, z: vector3.z)
        let clyinderMaterial = SCNMaterial()
        clyinderMaterial.diffuse.contents = UIColor.systemOrange.withAlphaComponent(0.8)
        cylinder.materials = [clyinderMaterial]
        cylinderNode.geometry = cylinder
        self.cylinders.append(cylinderNode)
        return cylinderNode
    }
    
    
}
