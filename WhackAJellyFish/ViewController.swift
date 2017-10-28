//
//  ViewController.swift
//  WhackAJellyFish
//
//  Created by Tewodros Wondimu on 10/28/17.
//  Copyright © 2017 Tewodros Wondimu. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    let configuration = ARWorldTrackingConfiguration()
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.session.run(configuration);
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // we use the tap gesture recognizer to recognize when the object is being tapped on
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        // add the tap gesture recognizer
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        self.addNode()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // when the play button is press show a box
    func addNode() {
        let node = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0))
        node.position = SCNVector3(0,0,-1)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    // Get the tap information
    @objc func handleTap(sender: UITapGestureRecognizer) {
        // allows us to see where in the arkit scene view the person tapped on
        let sceneViewTappedOn = sender.view as! SCNView
        
        // get the coordinates of where they touched on the screen
        let touchCoordinate = sender.location(in: sceneViewTappedOn)
        
        // did the user tap on the object
        // If there is a match, it will give you information
        // if it doesn't correspond to an object in the space, you get nil
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinate)
        
        // Check if hit test is empty, if there is find out what object was touched
        if (hitTest.isEmpty) {
            print("didn't touch anything")
        }
        else {
            print("Touched a box")
            // hit test is an array with one element
            let result = hitTest.first!
            let geometry = result.node.geometry
        }
        
    }
}

