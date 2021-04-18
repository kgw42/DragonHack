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
    
    var singlePlane:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBoardtoScene()
        addPiecestoScene()
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    func setUpSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func addBoardtoScene() {
    
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
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addPiecestoScene() {
        let piece = SCNSphere(radius: 0.01)
            
        let boxNode = SCNNode()
        boxNode.geometry = piece
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        let imageMaterial = SCNMaterial()
        let image = UIImage(named: "blackchecker")
        imageMaterial.diffuse.contents = image
        piece.materials = [imageMaterial, imageMaterial, imageMaterial, imageMaterial, imageMaterial, imageMaterial]
            
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
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if singlePlane == false{
                singlePlane = true
              let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
                let image = UIImage(named: "checkerboard")
                plane.firstMaterial?.diffuse.contents = image

              let planeNode = SCNNode(geometry: plane)

              planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.x, planeAnchor.center.z)
              planeNode.eulerAngles.x = -.pi / 2

              node.addChildNode(planeNode)
          }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor,
          let planeNode = node.childNodes.first,
          let plane = planeNode.geometry as? SCNPlane {
              plane.width = CGFloat(planeAnchor.extent.x)
              plane.height = CGFloat(planeAnchor.extent.z)
              planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
          }
    }
}

