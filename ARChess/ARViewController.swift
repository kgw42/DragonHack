//
//  ViewController.swift
//  ARChess
//
//  Created by Kathrina Waugh on 4/17/21.
//

import UIKit
import ARKit
import SceneKit


class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addChessBoard()
        addTapGestureToSceneView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    func addChessBoard() {
        //let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let board = SCNPlane(width: 0.1, height: 0.1)
            
        let boxNode = SCNNode()
        boxNode.geometry = board
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        let imageMaterial = SCNMaterial()
        let image = UIImage(named: "checkerboard")
        imageMaterial.diffuse.contents = image
        board.materials = [imageMaterial, imageMaterial, imageMaterial, imageMaterial, imageMaterial, imageMaterial]
            
        let scene = SCNScene()
        scene.rootNode.addChildNode(boxNode)
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
    }
    func addcheckerPiece() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        let imageMaterial = SCNMaterial()
        let image = UIImage(named: "chessboard")
        imageMaterial.diffuse.contents = image
        box.materials = [imageMaterial, imageMaterial, imageMaterial, imageMaterial, imageMaterial, imageMaterial]
            
            let scene = SCNScene()
            scene.rootNode.addChildNode(boxNode)
            sceneView.scene = scene
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else { return }
        node.removeFromParentNode()
    }
    
    
    


}

