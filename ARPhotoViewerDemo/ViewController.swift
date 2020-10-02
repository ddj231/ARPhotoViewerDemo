//
//  ViewController.swift
//  ARPhotoViewerDemo
//
//  Created by DAYE JACK on 10/1/20.
//  Copyright © 2020 DAYE JACK. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    var planeColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planeColor = UIColor(red: CGFloat(102.0/255) , green: CGFloat(189.0/255), blue: CGFloat(60.0/255), alpha: CGFloat(0.6))

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        sceneView.session.run(configuration)

        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        print(image)
    }
}

//MARK: ARSCN View Delegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else {return}

        //update the plane node, as plane anchor information updates

        //get the width and the height of the planeAnchor
        let w = CGFloat(planeAnchor.extent.x)
        let h = CGFloat(planeAnchor.extent.z)

        //set the plane to the new width and height
        plane.width = w
        plane.height = h

        //get the x y and z position of the plane anchor
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)

        //set the nodes position to the new x,y, z location
        planeNode.position = SCNVector3(x, y, z)
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        //add a plane node to the scene

        //get the width and height of the plane anchor
        let w = CGFloat(planeAnchor.extent.x)
        let h = CGFloat(planeAnchor.extent.z)

        //create a new plane
        let plane = SCNPlane(width: w, height: h)

        //set the color of the plane
        plane.materials.first?.diffuse.contents = planeColor!

        //create a plane node from the scene plane
        let planeNode = SCNNode(geometry: plane)

        //get the x, y, and z locations of the plane anchor
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)

        //set the plane position to the x,y,z postion
        planeNode.position = SCNVector3(x,y,z)

        //turn th plane node so it lies flat vertically, rather than stands up vertically
        planeNode.eulerAngles.x = -.pi / 2

        //set the name of the plane
        planeNode.name = "plain"

        //add plane to scene
        node.addChildNode(planeNode)
    }
    
    
    
}
