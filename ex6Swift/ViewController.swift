//
//  ViewController.swift
//  ex6Swift
//
//  Created by VuHongSon on 7/27/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var img1 : UIImageView!
    @IBOutlet weak var img2 : UIImageView!
    @IBOutlet weak var img3 : UIImageView!
    @IBOutlet weak var img4 : UIImageView!
    @IBOutlet weak var img5 : UIImageView!
    @IBOutlet weak var img6 : UIImageView!
    @IBOutlet weak var img7 : UIImageView!
    @IBOutlet weak var img8 : UIImageView!
    @IBOutlet weak var img9 : UIImageView!
    @IBOutlet weak var img10: UIImageView!
    @IBOutlet weak var img11: UIImageView!
    @IBOutlet weak var img12: UIImageView!
    @IBOutlet weak var img13: UIImageView!
    @IBOutlet weak var img14: UIImageView!
    @IBOutlet weak var img15: UIImageView!
    @IBOutlet weak var img16: UIImageView!
    @IBOutlet weak var img17: UIImageView!
    @IBOutlet weak var img18: UIImageView!
    @IBOutlet weak var img19: UIImageView!
    @IBOutlet weak var img20: UIImageView!
    @IBOutlet weak var img21: UIImageView!
    @IBOutlet weak var img22: UIImageView!
    @IBOutlet weak var img23: UIImageView!
    @IBOutlet weak var img24: UIImageView!

    @IBOutlet weak var lblShowTime: UILabel!
    
    let imageNameData = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    var imageView = [UIImageView]()
    var displayImageName = [String]()
    var statusImage = Array<Bool>(repeating: false, count: 24)
    var hideImage = Array<Bool>(repeating: false, count: 24)
    var countTap = 0
    var countTime = 0 {
        didSet {
            lblShowTime.text = "\(countTime)"
        }
    }
    var timer: Timer? = nil
    var player:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "ProudOfYou", ofType: ".mp3")
        let url:URL = URL(fileURLWithPath: path!)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.play()
        } catch {
            print("Player Error")
        }
        
        imageView = [img1, img2, img3, img4, img5, img6, img7, img8, img9, img10, img11, img12, img13, img14, img15, img16, img17, img18, img19, img20, img21, img22, img23, img24]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countTime = 0
        creatGame()
        updateGame()
    }
    
    @IBAction func tapImageDid(_ sender: UITapGestureRecognizer) {
        let imgView = sender.view as! UIImageView
        let index = imageView.index(of: imgView)
        
        if !statusImage[index!] {
            statusImage[index!] = true
            countTap += 1
            if countTap == 2 {
                var index1 = 69
                var index2 = 69
                
                getIndexOfOpeningView(index1: &index1, index2: &index2)
                if (displayImageName[index1] == displayImageName[index2]) {
                    hideImageDid(index: index1)
                    hideImageDid(index: index2)
                } else {
                    loadImageToView(imgView: imageView[index1], imgName: displayImageName[index1])
                    loadImageToView(imgView: imageView[index2], imgName: displayImageName[index2])
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (time) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.closeImage(index1: index1, index2: index2)
                        })
                    }
                }
                countTap = 0
            }
            updateGame()
        }
    }
}

extension ViewController {
    
    func creatGame(){
        for imgView in imageView {
            imgView.isUserInteractionEnabled = true
        }
        
        statusImage = Array<Bool>(repeating: false, count: 24)
        hideImage = Array<Bool>(repeating: false, count: 24)
        displayImageName = imageNameData
        for i in 0..<imageNameData.count {
            displayImageName.append(imageNameData[i])
        }
        
        displayImageName =  obfuscateImageName(imgName: displayImageName)
//        hackGame()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (time) in
            self.countTime += 1
        }
    }
    
    func obfuscateImageName( imgName: [String] ) -> [String] {
        var imgName = imgName
        for _ in 0..<1000 {
            let index1 = Int(arc4random_uniform(UInt32(imgName.count)))
            let index2 = Int(arc4random_uniform(UInt32(imgName.count)))
            if index1 != index2 {
                let tmp = imgName[index1]
                imgName[index1] = imgName[index2]
                imgName[index2] = tmp
            }
        }
        return imgName
    }
    
    func loadImageToView(imgView: UIImageView, imgName: String) {
        imgView.image = UIImage(named: imgName)
    }
    
    func updateGame() {
        for i in 0..<imageView.count {
            if hideImage[i] {
                continue
            }
            
            if !statusImage[i] {
                loadImageToView(imgView: imageView[i], imgName: "Pokeball")
            } else {
                loadImageToView(imgView: imageView[i], imgName: displayImageName[i])
            }
        }
    }
    
    func hackGame() {
        print("\n")
        for i in 0..<6 {
            for j in 0..<4 {
                print(displayImageName[i*4+j], terminator:"  ")
            }
            print("\n")
        }
    }
    
}

extension ViewController {
    
    func getIndexOfOpeningView(index1: inout Int, index2: inout Int) {
        for i in 0..<statusImage.count {
            if statusImage[i] {
                if index1 == 69 {
                    index1 = i
                } else {
                    index2 = i
                }
            }
        }
    }
    
    func hideImageDid(index: Int) {
        loadImageToView(imgView: imageView[index], imgName: displayImageName[index])
        imageView[index].isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (time) in
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView[index].image = nil
            })
        }
        statusImage[index] = false
        hideImage[index] = true
        checkEnd()
    }
    
    func checkEnd() {
        for sub in hideImage {
            if !sub {
                return
            }
        }
        player.stop()
        timer?.invalidate()
        timer = nil
        var message : String = ""
        if countTime < 30 {
            message = "That's Great!"
        } else if countTime < 40 {
            message = "You are Done but not Good."
        } else {
            message = "You are Idot :v :v"
        }
        
        let alert = UIAlertController(title: "Complete", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func closeImage(index1: Int, index2: Int) {
        statusImage[index1] = false
        statusImage[index2] = false
        updateGame()
    }
    
}

