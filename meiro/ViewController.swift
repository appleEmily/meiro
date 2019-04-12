//
//  ViewController.swift
//  meiro
//
//  Created by 野崎絵未里 on 2019/04/12.
//  Copyright © 2019年 野崎絵未里. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let screenSiza = UIScreen.main.bounds.size
    
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
    
    func createView(x: Int, y: Int, width: CGFloat, height: CGFloat, offsety: CGFloat) -> UIView {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let view = UIView(frame: rect)
        
        let center = CGPoint(x: offsetX + width * CGFloat(x), y: offsetY + height * CGFloat(y))
        
        view.center = center
        
        return view
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellWidth = screenSiza.width / CGFloat(meiro[0].count)
        let cellHeight = screenSiza.height / CGFloat(meiro.count)
        
        let cellOffsetX = screenSiza.width / CGFloat(meiro[0].count * 2)
        let cellOffsetY = screenSiza.height / CGFloat(meiro.count * 2)
        
        for y in 0 ..< meiro.count {
            for x in 0 ..< meiro[y].count {
                switch meiro[y][x] {
                case 1:
                    let wallView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    wallView.backgroundColor = UIColor.black
                    view.addSubview(wallView)
                case 2:
                    startView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetx: cellOffsetX, offsetY: cellOffsetY)
                    startView.backgroundColor = UIColor.green
                    view.addSubview(startView)
                case 3:
                    goalView = createView(x: x, y: y, width: cellWidth, height: cellHeight, offsetX: cellOffsetX, offsetY: cellOffsetY)
                    goalView.backgroundColor = UIColor.red
                default:
                    break
            }
        }
    }
    
    


}

