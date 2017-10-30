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
    @IBOutlet weak var playButton: UIButton!
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
        
        // disable the playbutton untill the animation ends
        playButton.isEnabled = false
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // when the play button is press show a box
    func addNode() {
        // turbosquid.com sells 3D models
        // download a 3D model with a dae format
        // drag it into your project along with the texture file
        // open the dae file and remove the camera and lights, you should remain with a sphere
        // In the material inspector, change the diffuse from the color to the texture image
        // Go to editor, click on convert to sceneKit scene file format
        // to load the scene in the arkit view you need to have it in an asset
        // create an asset folder by going to new > file > asset catalog
        // change the file format to *.scnassets and click use
        let jellyFishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        
        // to convert the scene to the node
        // to get the name go to the scene in the assets and change the name of the child from sphere to jellyfish
        // recursively will search for every node with in the root node subtree, if false it will only search immediate nodes
        let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: "Jellyfish", recursively: false)
        //jellyFishNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Textures/Jellyfish.png")
        
        // place the object infront of you and then add it to the sceneView
        jellyFishNode?.position = SCNVector3(0,0,-1)
        self.sceneView.scene.rootNode.addChildNode(jellyFishNode!)
        
        // To change the orientation of the 3d model go to assets
        // then click presepective and make it front
        // then under the node inspector, change the euler angles to the angle you want (usually x-axis)
        // to change the size of the 3D object, underscale multiple by a value like 0.1
    }
    
    func animateNode(node: SCNNode) {
        // to make the object make a shaky spin we modify the position
        let spin = CABasicAnimation(keyPath: "position")
        
        // presentation is the current state of the object in the sceneview
        // this records the starting point of the animation 
        spin.fromValue = node.presentation.position
        
        // to change the duration of the animation
        spin.duration = 0.7
        
        // makes sure that the return back is also animated
        spin.autoreverses = true
        
        // to repeat the number of times the animation happens
        spin.repeatCount = 5
        
        // this shows where you want the node to go relative to the world origin
        // spin.toValue = SCNVector3(0,0,-2)
        
        // if you want to go from the current position of the node,
        spin.toValue = SCNVector3(node.presentation.position.x - 0.2, node.presentation.position.y - 0.2, node.presentation.position.z - 0.2)
        
        // add the animation to the node
        node.addAnimation(spin, forKey: "position")
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
            
            // The node that was touched
            let touchedNode = result.node
            
            // Check whether the object is already animating
            if (touchedNode.animationKeys.isEmpty) {
                // Animate the node that was touched
                animateNode(node: touchedNode)
            }
        }
    }
}

