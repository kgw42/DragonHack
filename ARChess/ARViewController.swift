//
//  ViewController.swift
//  ARChess
//
//  Created by Kathrina Waugh on 4/17/21.
//
import UIKit
import ARKit
import SceneKit
import SpriteKit


class ARViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    
    var singlePlane:Bool = false;
    var blackPieces = [SCNNode: Array<Float>]();
    var redPieces = [SCNNode: Array<Float>]();
    var position:SCNVector3 = SCNVector3(0,0,0);
    var nodeSelected:SCNNode = SCNNode();
    var mainPlane:SCNNode = SCNNode();
    var turn:String = "red";
    var selected:Bool = false;
    //var move:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBoardtoScene()
        addTapGesture()
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
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func rotatePlane(node:SCNNode) {
        node.eulerAngles.y = node.eulerAngles.y + 180
        node.eulerAngles.x = node.eulerAngles.x + 180
    }
    
    func changeTurn() {
        if turn == "red"{
            turn = "black"
        }
        else{
            turn = "red"
        }
    }
    
    func makeBlackPieces() -> SCNNode {
      // 1
      let portal = SCNNode()
      // 2
      let piece = SCNSphere(radius: 0.05)
        piece.name = "blackSphere"
        piece.firstMaterial?.diffuse.contents = UIColor.black
      let boxNode = SCNNode(geometry: piece)
        //let imageMaterial = SCNMaterial()
        
       
      // 3
      portal.addChildNode(boxNode)
      return portal
    }
    
    func makeRedPieces() -> SCNNode {
      // 1
      let portal = SCNNode()
      // 2
      let piece = SCNSphere(radius: 0.05)
        piece.name = "redSphere"
        piece.firstMaterial?.diffuse.contents = UIColor.red
      let boxNode = SCNNode(geometry: piece)
        //let imageMaterial = SCNMaterial()
        
       
      // 3
      portal.addChildNode(boxNode)
      return portal
    }
    
    func addTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ARViewController.select(withGestureRecognizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ARViewController.move(withGestureRecognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        
        sceneView.addGestureRecognizer(singleTapGesture)
        sceneView.addGestureRecognizer(doubleTapGesture)
    }
    
    func removeComponen() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ARViewController.select(withGestureRecognizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(ARViewController.move(withGestureRecognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        
        sceneView.addGestureRecognizer(singleTapGesture)
        sceneView.addGestureRecognizer(doubleTapGesture)
    }
        
    @objc func select(withGestureRecognizer recognizer: UIGestureRecognizer) {
        var tapLocation = recognizer.location(in: sceneView)
        //print(tapLocation)
        let hitTestResults = sceneView.hitTest(tapLocation, options: [:])
          

        //guard let node = hitTestResults.first?.node else { return }
        //var location:Array<Float> = [node.position.x,node.position.y, node.position.z]
        //if location ==
        
        let result: SCNHitTestResult = hitTestResults[0]
        let node = result.node
        print(node)
        var new_name:String = ""
        if (node.geometry?.name) != nil{
            new_name = (node.geometry?.name!)!
        }
        else{
            new_name = "anything"
        }
        print(selected)
        print(turn)
        print(new_name)
        if turn == "red"{
            print("here")
            if (new_name == "redSphere"){
                print("here again")
                if !selected{
                    print("finally")
                selected = true
                nodeSelected = node
                node.position.y = node.position.y + 0.05
                position = SCNVector3(node.position.x, node.position.y-0.05, node.position.z)
                }
            
            }
            
        }
        
        else if turn == "black"{
            if (blackPieces.keys.contains(node) || ((node.geometry?.name) == "blackSphere")) && (selected == false){
                //node.removeFromParentNode()
                selected = true
                nodeSelected = node
                node.position.y = node.position.y + 0.05
                position = SCNVector3(node.position.x, node.position.y-0.05, node.position.z)
            }
        }
        
    }
    
    @objc func move(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        let result: SCNHitTestResult = hitTestResults[0]
        print(result)
        let node = result.node
        print(node)
        //if node is not in the position
        if ((node.geometry?.name) == "board") && (selected == true){
            print(node.position.x)
            print(nodeSelected.position.x)
            if turn == "red"{
            if node.position.x < nodeSelected.position.x{
                position.x = nodeSelected.position.x - 0.12
                position.z = nodeSelected.position.z - 0.12
            }
            else{
                position.x = nodeSelected.position.x + 0.12
                position.z = nodeSelected.position.z - 0.12
            }
            
            
            nodeSelected.position = position
            changeTurn()
            selected = false
            }
            else if turn == "black"{
                if node.position.x < nodeSelected.position.x{
                    position.x = nodeSelected.position.x + 0.12
                    position.z = nodeSelected.position.z + 0.12
                }
                else{
                    position.x = nodeSelected.position.x - 0.12
                    position.z = nodeSelected.position.z + 0.12
                }
                
                
                nodeSelected.position = position
                changeTurn()
                selected = false
            }
            
            
            // Ensure only one object highlighted at at time & moves up highest one time
            
        }
        if ((node.geometry?.name) == "redSphere") && (selected == true) && (turn == "black"){
            if node.position.x < nodeSelected.position.x{
                position.x = nodeSelected.position.x + (0.12 * 2)
                position.z = nodeSelected.position.z + (0.12 * 2)
                node.removeFromParentNode()
            }
            else{
                position.x = nodeSelected.position.x - (0.12 * 2)
                position.z = nodeSelected.position.z + (0.12 * 2)
                node.removeFromParentNode()
            }
            
            
            nodeSelected.position = position
            changeTurn()
            selected = false
        }
        else if ((node.geometry?.name) == "blackSphere") && (selected == true) && (turn == "red"){
            if node.position.x < nodeSelected.position.x{
                position.x = nodeSelected.position.x - (0.12 * 2)
                position.z = nodeSelected.position.z - (0.12 * 2)
                node.removeFromParentNode()
            }
            else{
                position.x = nodeSelected.position.x + (0.12 * 2)
                position.z = nodeSelected.position.z - (0.12 * 2)
                node.removeFromParentNode()
            }
            
            
            nodeSelected.position = position
            changeTurn()
            selected = false
        }
        
    }


}
extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            if singlePlane == false{
                singlePlane = true
                let plane = SCNPlane(width: 1, height: 1)
                plane.name = "board"
                let image = UIImage(named: "checkerboard")
                plane.firstMaterial?.diffuse.contents = image

              let planeNode = SCNNode(geometry: plane)

              planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
              planeNode.eulerAngles.x = -.pi / 2
                mainPlane = planeNode
                
                

              node.addChildNode(planeNode)
                // Add first row of black pieces
                var k:Int = 4
                var x:Float = planeAnchor.center.x - 0.28
                var y:Float = planeAnchor.center.y
                var z:Float = planeAnchor.center.z - 0.4
                while (k != 0) {
                    let blackpiece = makeBlackPieces()
                    
                    blackpiece.position = SCNVector3(x:x, y:y, z:z)
                    blackPieces[blackpiece] = [x,y,z]
                    node.addChildNode(blackpiece)
                    
                    x += 0.225
                    k -= 1
                }
                // Add second row of black pieces
                k = 8
                x = planeAnchor.center.x - 0.4
                y = planeAnchor.center.y
                z = planeAnchor.center.z - 0.275
                while (k != 4) {
                    let blackpiece = makeBlackPieces()
                   
                    blackpiece.position = SCNVector3(x:x, y:y, z:z)
                    blackPieces[blackpiece] = [x,y,z]
                    node.addChildNode(blackpiece)
                    
                    x += 0.225
                    k -= 1
                }
            //Add first row of red pieces
                k = 4
                x = planeAnchor.center.x - 0.3875
                y = planeAnchor.center.y
                z = planeAnchor.center.z + 0.4
                while (k != 0) {
                    let redpiece = makeRedPieces()
                   
                    redpiece.position = SCNVector3(x:x, y:y, z:z)
                    redPieces[redpiece] = [x,y,z]
                    node.addChildNode(redpiece)
                    
                    x += 0.225
                    k -= 1
                }
                
                //Add second row of red pieces
                    k = 8
                    x = planeAnchor.center.x - 0.28
                    y = planeAnchor.center.y
                z = planeAnchor.center.z + 0.275
                    while (k != 4) {
                        let redpiece = makeRedPieces()
                        
                        redpiece.position = SCNVector3(x:x, y:y, z:z)
                        redPieces[redpiece] = [x,y,z]
                        node.addChildNode(redpiece)
                        
                        x += 0.225
                        k -= 1
                    }

          }
        }
    }
    
    //func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
      //  if let planeAnchor = anchor as? ARPlaneAnchor,
        //  let planeNode = node.childNodes.first,
          //let plane = planeNode.geometry as? SCNPlane {
              //plane.width = CGFloat(planeAnchor.extent.x)
              //plane.height = CGFloat(planeAnchor.extent.z)
            //  planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
          //}
    //}
}

