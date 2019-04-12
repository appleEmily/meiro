//
//  ViewController.swift
//  meiro
//
//  Created by 野崎絵未里 on 2019/04/12.
//  Copyright © 2019年 野崎絵未里. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var playerView: UIView!
    var PlayerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY = 0.0
    
    
    let screenSize = UIScreen.main.bounds.size
    
    let meiro = [
        [1,0,0,0,1,0],
        [1,0,1,0,1,0],
        [3,0,1,0,1,0],
        [1,1,1,0,0,0],
        [1,0,0,1,1,0],
        [0,0,1,0,0,0],
        [0,1,1,0,1,0],
        [0,0,0,0,1,1],
        [0,1,1,0,0,0],
        [0,0,1,1,1,2]
    ]
    var startView: UIView!
    var goalView: UIView!
    var wallRectArray = [CGRect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellWidth = screenSize.width / CGFloat(meiro[0].count)
        let cellHeight = screenSize.height / CGFloat(meiro.count)
        
        let cellOffsetX = screenSize.width / CGFloat(meiro[0].count * 2)
        let cellOffsetY = screenSize.height / CGFloat(meiro.count * 2)
        
        for y in 0 ..< meiro.count {
            for x in 0 ..< meiro[y].count {
                switch meiro[y][x] {
                case 1:
                    let wallView = createView (x: x, y: y, width: cellWidth, height: cellHeight, offsety: cellOffsetX)
                    wallView.backgroundColor = UIColor.black
                    view.addSubview(wallView)
                    wallRectArray.append(wallView.frame)
                case 2:
                    startView = createView (x: x, y: y, width: cellWidth, height: cellHeight, offsety: cellOffsetX)
                    startView.backgroundColor = UIColor.green
                    view.addSubview(startView)
                case 3:
                    goalView = createView (x: x, y: y, width: cellWidth, height: cellHeight, offsety: cellOffsetX)
                    goalView.backgroundColor = UIColor.red
                default:
                    break
                }
            }
        }
        playerView = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth / 6, height: cellHeight / 6))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.gray
        self.view.addSubview(playerView)
        
        PlayerMotionManager = CMMotionManager()
        PlayerMotionManager.accelerometerUpdateInterval = 0.02
        self.startAccelerater()
        
    }
    
    func createView(x: Int, y: Int, width: CGFloat, height: CGFloat, offsety: CGFloat) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: offsety + width * CGFloat(x), y: offsety + height * CGFloat(y))
        
        view.center = center
        
        return view
        
    }
    func startAccelerater() {
        let handler: CMAccelerometerHandler = {(CMAccelerometerData:CMAccelerometerData?, error:Error?) -> Void in
            self.speedX += CMAccelerometerData!.acceleration.x
            self.speedY += CMAccelerometerData!.acceleration.y
            
            var posX = self.playerView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerView.center.y - (CGFloat(self.speedY) / 3)
            
            if posX <= self.playerView.frame.width / 2{
                self.speedX = 0
                posX = self.playerView.frame.width / 2
            }
            if posY <= self.playerView.frame.height / 2{
                self.speedX = 0
                posY = self.playerView.frame.height / 2
            }
            if posX >= self.screenSize.width - (self.playerView.frame.width / 2){
                self.speedX = 0
                posX = self.screenSize.width - (self.playerView.frame.width / 2)
            }
            if posY >= self.screenSize.height - (self.playerView.frame.height / 2){
                self.speedX = 0
                posY = self.screenSize.height - (self.playerView.frame.height / 2)
            }
            for wallRect in self.wallRectArray {
                if wallRect.intersects(self.playerView.frame){
                    self.gameCheck(result: "gameOver", message: "壁に当たりました")
                    return
                }
            }
            if (self.goalView.frame.intersects(self.playerView.frame)){
                print("clear")
                return
            }
            self.playerView.center = CGPoint(x: posX, y: posY)
        }
        PlayerMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: handler)
    }
    
    func gameCheck(result: String, message: String) {
        if PlayerMotionManager.isAccelerometerActive {
            PlayerMotionManager.stopAccelerometerUpdates()
        }
        let gameCheckAlert: UIAlertController = UIAlertController(title: result, message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "again", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.retry()
        })
        gameCheckAlert.addAction(retryAction)
        self.present(gameCheckAlert, animated: true, completion: nil)
        
    }
    func retry() {
        playerView.center = startView.center
        if !PlayerMotionManager.isAccelerometerActive {
            self.startAccelerater()
        }
        speedX = 0.0
        speedY = 0.0
    }
    
    

    

}
