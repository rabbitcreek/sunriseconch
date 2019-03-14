//
//  secondViewController.swift
//  sunriseconch
//
//  Created by RobertW. on 3/8/19.
//  Copyright © 2019 RobertW. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class secondViewController: UIViewController, ARSCNViewDelegate{
    var audioPlayer: AVAudioPlayer!
      let soundEffect = URL(fileURLWithPath: Bundle.main.path(forResource: "0001", ofType: "wav")!)
    
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/conch3.dae")!
        
        // Set the scene to the view
        sceneView.scene = scene
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    @objc func tapped(recognizer :UIGestureRecognizer) {
        // Get exact position where touch happened on screen of iPhone (2D coordinate)
        let touchPosition = recognizer.location(in: sceneView)
        
        // 2.
        // Conduct a hit test based on a feature point that ARKit detected to find out what 3D point this 2D coordinate relates to
        let hitTestResult = sceneView.hitTest(touchPosition, types: .featurePoint)
        
        // 3.
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else {
                return
            }
            print(hitResult.worldTransform.columns.3)
            // setting up url for your soundtrack
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundEffect)
            audioPlayer.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                self.performSegue(withIdentifier: "Return", sender: self)
            }
            
        } catch {
            // couldn't load file :(
        } 
    }
    
}
