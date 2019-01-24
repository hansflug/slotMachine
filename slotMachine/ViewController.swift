//
//  ViewController.swift
//  SlotMachine
//
//  Created by Oguz Bayral on 2019/1/23.
//  301029119
//  Copyright © 2019 Centennial College. All rights reserved.
//

import UIKit
extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
class ViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var winMoney: UILabel!
    @IBOutlet weak var ownMoney: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    var bet100: Bool = false
    var bet500: Bool = false
    var imageArray:[UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        imageArray = ["🍎".emojiToImage()!,
                      "😍".emojiToImage()!,
                      "🐮".emojiToImage()!,
                      "🐼".emojiToImage()!,
                      "🐔".emojiToImage()!,
                      "🎅".emojiToImage()!,
                      "🚍".emojiToImage()!,
                      "💖".emojiToImage()!,
                      "👑".emojiToImage()!,
                      "👻".emojiToImage()!]
        
        resultLabel.text = ""
        winMoney.text = "0"
        ownMoney.text = "5000"
        
        arc4random_stir()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func bet500(_ sender: UIButton) {
        bet100 = false
        bet500 = true
    }
    
    
    @IBAction func bet100(_ sender: UIButton) {
        bet100 = true
        bet500 = false
    }
    
    
    @IBAction func spin(_ sender: UIButton) {
        var win = false
        var numInRow = -1
        var lastVal = -1
        var winnedMoney = Int(winMoney.text!)!
        var ownnedMoney = Int(ownMoney.text!)!
        if ownnedMoney>0{
            for i in 0..<5{
                let newValue = Int(arc4random_uniform(UInt32(imageArray.count)))
                print("NEW VALUE: ", newValue)
                if newValue == lastVal{
                    print("NEW numInRow: ", numInRow)
                    numInRow += 1
                     print("NEW numInRow2: ", numInRow)
                }else {
                    numInRow = 1
                }
                lastVal = newValue
                
                pickerView.selectRow(newValue, inComponent: i, animated: true)
                pickerView.reloadComponent(i)
                if bet100 == true{
                    ownnedMoney = ownnedMoney - 20
                }
                else if bet500 == true{
                    ownnedMoney = ownnedMoney - 100
                }
                else{
                    ownnedMoney = ownnedMoney - 50
                }
                ownMoney.text = String(ownnedMoney)
                if numInRow >= 3{
                    winnedMoney = winnedMoney + 500
                    ownnedMoney = ownnedMoney + 500
                    winMoney.text = String(winnedMoney)
                    ownMoney.text = String(ownnedMoney)
                    win = true
                }
            }
            resultLabel.text = win ? "YOU WON" : ""
            if ownnedMoney == 0{
                resultLabel.text = "You Lose :("
            }
        }
    }
    
    @IBAction func restart(_ sender: UIButton) {
        bet100 = false
        bet500 = false
        resultLabel.text = ""
        winMoney.text = "0"
        ownMoney.text = "5000"
    }
    
    
    // function which returns the number of 'columns' to display.
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return    5
    }
    
    // function which returns the number of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return imageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat{
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let image = imageArray[row]
        let imageView = UIImageView(image: image)
        return imageView
    }
}

