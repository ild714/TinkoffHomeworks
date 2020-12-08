//
//  TouchAnimation.swift
//  TinkoffChat
//
//  Created by Ildar on 11/21/20.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import Foundation

import UIKit

protocol TouchAnimationProtocol: class {
    func addSublayer(layer: CAEmitterLayer)
}

class TouchAnimation {
    
    weak var delegate: TouchAnimationProtocol?
    
    lazy var tinkoffCell: CAEmitterCell = {
     var tinkoffCell = CAEmitterCell()
        tinkoffCell.contents = UIImage(named: "tinkoff")?.cgImage
     tinkoffCell.scale = 0.06
     tinkoffCell.scaleRange = 0.3
     tinkoffCell.emissionRange = .pi
        tinkoffCell.lifetime = 2
     tinkoffCell.birthRate = 10
     tinkoffCell.velocity = 100
     tinkoffCell.velocityRange = 25
     tinkoffCell.spin = -0.5
     tinkoffCell.spinRange = 1.0
     tinkoffCell.lifetimeRange = 0
     return tinkoffCell
    }()
    
    func showTinkoff(location: CGPoint) {
        let snowLayer = CAEmitterLayer()
        snowLayer.emitterPosition = CGPoint(x: location.x, y: location.y)
        snowLayer.emitterCells = [tinkoffCell]
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            snowLayer.birthRate = 0
        }
        delegate?.addSublayer(layer: snowLayer)
    }
}
