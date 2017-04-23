//
//  VideoPlayer.swift
//  VideoPlayerFramework
//
//  Created by Jesus Manuel Prieto Gonzalo on 21/4/17.
//  Copyright © 2017 Jesus Manuel Prieto Gonzalo. All rights reserved.
//

import Foundation
import AVFoundation

public class VideoPlayer: UIView {
    
    let player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    let playerView = UIView()
    let progressSlider = UISlider()
    var videoPaused = true
    var resumeButton = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Inicializa el player y los controler con el video recibido y lo agrega a la vista recibida
    public convenience init(view parentView: UIView, videoUrl: URL) {
        
        self.init(frame: parentView.bounds)
        parentView.addSubview(self)
        
        //Crea las constraints de la vista para que se adapte a la pantalla
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        //Crea las constraints del botón de play/pause
        self.addSubview(resumeButton)
        self.resumeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.resumeButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.resumeButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.resumeButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.resumeButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        //Crea las constraints del slider
        self.addSubview(progressSlider)
        self.progressSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.progressSlider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.progressSlider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.progressSlider, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        //Añade los eventos al botón play/pause
        self.resumeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        //Añade los eventos al slider
        self.progressSlider.addTarget(self, action: #selector(sliderBeganTouch), for: .touchDown)
        self.progressSlider.addTarget(self, action: #selector(sliderEndTouch), for: [.touchUpInside, .touchUpOutside])
        self.progressSlider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        
        //Añade el timer para actualizar el slider de progreso
        let timeInterval = CMTimeMakeWithSeconds(1.0, 10)
        _ = self.player.addPeriodicTimeObserver(forInterval: timeInterval, queue: nil, using: { (elapsedTime: CMTime) in
            self.updateProgressSlider(elapsedTime: elapsedTime)
        })
        
        //Crea el player
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.layer.insertSublayer(self.playerLayer, at: 0)
        let video = AVPlayerItem(url: videoUrl)
        self.player.replaceCurrentItem(with: video)
        
        self.playerLayer.frame = self.bounds
    }
    
    override public func layoutSubviews() {
        
        self.playerLayer.frame = self.bounds
    }
    
    //MARK: - Métodos públicos para el control del video desde fuera
    
    public func play() {
        
        if self.videoPaused {
            
            self.videoPaused = false
            self.player.play()
        }
    }
    
    public func pause() {
        
        if !self.videoPaused {
            
            self.videoPaused = true
            self.player.pause()
        }
    }
    
    //MARK: -  Métodos para controlar el slider de progreso
    
    func sliderBeganTouch(slider: UISlider) {
        
        if !self.videoPaused {
            self.player.pause()
        }
    }
    
    func sliderEndTouch(slider: UISlider) {
        
        let videoDuration = CMTimeGetSeconds((self.player.currentItem?.duration)!)
        let elapsedTime = videoDuration * Float64(progressSlider.value)
        
        self.player.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) in
            
            if !self.videoPaused {
                
                self.player.play()
            }
        }
    }
    
    func sliderValueChange(slider: UISlider) {
        
        let videoDuration = CMTimeGetSeconds((self.player.currentItem?.duration)!)
        let elapsedTime = videoDuration * Float64(progressSlider.value)
        
        self.player.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100))
    }
    
    //Actualiza el slider de progreso con el video
    
    private func updateProgressSlider(elapsedTime: CMTime) {
        
        let videoDuration = CMTimeGetSeconds((self.player.currentItem?.duration)!)
        let elapsedTimeInSeconds = CMTimeGetSeconds(elapsedTime)
        self.progressSlider.value = Float(elapsedTimeInSeconds / videoDuration)
        
    }
    
    //MARK: - Método de control del botón play/pause
    
    func buttonTapped(sender: UIButton) {
        
        if self.videoPaused {
            
            self.videoPaused = false
            self.player.play()
        } else {
            
            self.videoPaused = true
            self.player.pause()
        }
    }
}
