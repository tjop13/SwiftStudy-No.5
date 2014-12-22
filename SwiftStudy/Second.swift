//
//  ViewController.swift
//  List
//
//  Created by Takuro Mori on 2014/11/25.
//  Copyright (c) 2014年 Takuro Mori. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class Second: Multipeer {
    //Firstクラスで値を代入する変数を宣言
    var selectImage : UIImage? = nil
    var Image_Array : [UIImage] = [UIImage]()
    
    //<初期化>
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0)
        
        var ImageView = UIImageView(frame: CGRectMake(10, 20, 300, 400))
        ImageView.image = selectImage
        self.view.addSubview(ImageView)
        
        var backButton = UIButton(frame: CGRectMake(110, 480, 100, 30))
        backButton.layer.position = CGPointMake(self.view.frame.width/2, self.view.frame.height-50)
        backButton.backgroundColor = UIColor.blueColor()
        backButton.setTitle("Back", forState: .Normal)
        backButton.showsTouchWhenHighlighted = true
        backButton.layer.cornerRadius = 10.0
        backButton.addTarget(self, action: "BACKbutton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
     
        
        println("(Input)アドバタイズ開始")
        self.myAdvertiser.startAdvertisingPeer();
    }
    
    //<メモリが足りなくなった時>
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //戻るボタン
    func BACKbutton(sender:UIButton){
        self.performSegueWithIdentifier("toFirst", sender: self)
    }
    
    //Segue処理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFirst"{
            var VC : First = segue.destinationViewController as First
            VC.inputArray = self.Image_Array
        }
    }
    
    // NSDataを受信したとき呼ばれる
    override func session(session: MCSession!,
        didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!){
            println("(Input)データ受信from\(peerID.displayName)");
            var tmp : UIImage = UIImage(data: data)!
            dispatch_async(dispatch_get_main_queue()){
                self.Image_Array.append(tmp)
        }
        self.myAdvertiser.stopAdvertisingPeer()
        self.mySession.disconnect()
        self.myAdvertiser.startAdvertisingPeer()
    }
}