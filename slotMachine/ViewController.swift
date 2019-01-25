//
//  ViewController.swift
//  SlotMachine
//
//  Created by Oguz Bayral on 2019/1/23.
//  301029119
//  Copyright © 2019 Centennial College. All rights reserved.
//

import UIKit

//Converting emojis to UIImages
extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.blue.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class ViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    //declaring the labels and the pickerView
    @IBOutlet weak var winMoney: UILabel!
    @IBOutlet weak var ownMoney: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    var i = 0
   
    //Initialization of betting variables and decalaration of UIImage array
    var bet100: Bool = false
    var bet500: Bool = false
    var imageArray:[UIImage]!
    let alert = UIAlertController(title: "Alert", message: "No cheating please:)", preferredStyle: UIAlertController.Style.alert);
   
    
    //setting the initial values for the view controller components
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
        
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    //betting 500 function
    @IBAction func bet500(_ sender: UIButton) {
        if Int(ownMoney.text!)! >= 500{
            bet100 = false
            bet500 = true
        }else{
           alertMessage()
           i = i + 1
        }
    }
    
    //betting 100 function
    @IBAction func bet100(_ sender: UIButton) {
        if Int(ownMoney.text!)! >= 100{
            bet100 = true
            bet500 = false
        }else{
           alertMessage()
            i = i + 1
        }
    }
    
    //spin function
    @IBAction func spin(_ sender: UIButton) {
        //initialization of game statements
        var win = false
        //number of emojis in row
        var numInRow = 0
        //index of the last emoji
        var lastVal = -1
        var winnedMoney = Int(winMoney.text!)!
        var ownnedMoney = Int(ownMoney.text!)!
        //user can continue to play if they still have money
        if bet500==true && ownnedMoney<500{
            alertMessage()
            i = i + 1
            return
        }
        else if bet500==false && bet100==false && ownnedMoney<250{
            alertMessage()
            i = i + 1
            return
        }
        else if bet100 == true && ownnedMoney<100{
            alertMessage()
            i = i + 1
            return
        }
        else{
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
       bet500  = false
       bet100  = false
       resultLabel.text = ""
       winMoney.text = "0"
       ownMoney.text = "5000"
       for i in 0..<5{
         pickerView.selectRow(0, inComponent: i, animated: true)
         pickerView.reloadComponent(i)
        }
     }
    
    // function which returns the number of 'columns' to display.

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return    5
    }
    
    
    // function which returns the number of rows in each component..
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
    
    func alertMessage(){
        if i == 0{
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
}

