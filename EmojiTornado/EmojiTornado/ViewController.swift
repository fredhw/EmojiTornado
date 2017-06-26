//
//  ViewController.swift
//  EmojiTornado
//
//  Created by iGuest on 5/11/17.
//  Copyright © 2017 fredhw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let emojis = [
        "😀",
        "😃",
        "😄",
        "😁",
        "😆",
        "😅",
        "😂",
        "🤣"
    ]
    
    let textLayer = CATextLayer()
    
    let fontSize : CGFloat = 30.0
    let fontColor = UIColor(white: 0.1, alpha: 1.0)
    
    // responsible for rendering a particle system
    let emitterLayer = CAEmitterLayer()
    
    let fallRate: CGFloat = 72
    let spinRange: CGFloat = 5
    let birthRate: Float = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextLayer()
        configureEmitterLayer()
        beginRotatingIn3D()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emitterLayer.frame = view.bounds
        
        let paddingAboveScreen = view.bounds.height
        emitterLayer.emitterPosition = CGPoint(x: emitterLayer.frame.midX, y: -paddingAboveScreen / 2)
        emitterLayer.emitterSize = CGSize(width: emitterLayer.frame.width, height: 50)
    }
    
// Mark: Raining Emojis
    
    // renders things
    func configureTextLayer() {
        // Anytime you are doing CATextLayer on iPhone Screens
        textLayer.contentsScale = UIScreen.main.scale
        
        textLayer.fontSize = fontSize
        textLayer.alignmentMode = kCAAlignmentCenter // center a line of text when we draw it
        
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = fontColor.cgColor
        
        textLayer.frame = CGRect(x: 0, y: 0, width: fontSize * 2, height: fontSize * 2)
    }
    
    // layer that draws emojis
    func configureEmitterLayer() {
        textLayer.contentsScale = UIScreen.main.scale
        
        emitterLayer.preservesDepth = true
        
        // object that describes emitter volume
        emitterLayer.emitterMode = kCAEmitterLayerVolume
        emitterLayer.emitterShape = kCAEmitterLayerRectangle
        
        // emitterLayer.backgroundColor = UIColor.red.cgColor
        // emitterLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        emitterLayer.emitterCells = generateEmitterCells()
        
        view.layer.addSublayer(emitterLayer)
    }
    
    func generateEmitterCells() -> [CAEmitterCell] {
        var emitterCells = Array<CAEmitterCell>()
        
        for emoji in self.emojis {
            let emitterCell = emitterCellWith(text: emoji)
            emitterCells.append(emitterCell)
        }
        
        return emitterCells
    }
    
    func emitterCellWith(text: String) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        
        emitterCell.contents = cgImageFrom(text:text)
        emitterCell.contentsScale = UIScreen.main.scale
        
        emitterCell.birthRate = birthRate
        emitterCell.lifetime = Float(view.bounds.height * 2 / fallRate)
        
        emitterCell.emissionLongitude = CGFloat.pi * 0.5 // vertical movement
        emitterCell.emissionRange = CGFloat.pi * 0.25 // horizontal movement
        emitterCell.velocity = fallRate
        emitterCell.spinRange = spinRange
        
        return emitterCell
    }
    
    func cgImageFrom(text: String) -> CGImage? {
        textLayer.string = text
        
        UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else  { return nil }
        textLayer.render(in: context)
        
        // have to end or you will be using memory continuously
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderedImage?.cgImage
    }
    
// MARK: Rotation
    
    func beginRotatingIn3D() {
        
        // beautiful property: distance of camera space to UI
        view.layer.sublayerTransform.m34 = 1 / 500.0
        
        
        let rotationAnimation = infiniteRotatingAnimation()
        emitterLayer.add(rotationAnimation, forKey: "asdfghjkl")
    }
    
    func infiniteRotatingAnimation() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.y")
        
        rotation.toValue = 4 * Double.pi
        rotation.duration = 10
        
        rotation.isCumulative = true
        rotation.repeatCount = HUGE
        
        return rotation
    }

}

