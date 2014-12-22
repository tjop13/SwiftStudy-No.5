//
//  Illust.swift
//  SwiftStudy
//
//  Created by Takuro Mori on 2014/12/02.
//  Copyright (c) 2014 Takuro Mori. All rights reserved.
//

import UIKit
import CoreImage
import MultipeerConnectivity

class Illust: Multipeer {
    
    //変数定義
    var Illust_Array : [UIImage] = [UIImage]()
    
    var pre_Image : UIImage! = nil
    var canvas_View = UIImageView()
    var touchedPoint : CGPoint = CGPointZero
    var bezierPath : UIBezierPath! = nil
    
    var red :CGFloat=0.91
    var green :CGFloat = 0.3
    var blue :CGFloat = 0.24
    var alpha :CGFloat = 0.8
    var width :CGFloat = 5.0
    
    var firstMovedFlag : Bool = true
    var image : UIImage! = nil
    var Image_array_undo : [UIImage] = [UIImage]()
    var Image_array_redo : [UIImage] = [UIImage]()
    
    var Red_Button = UIButton()
    var Blue_Button = UIButton()
    var Green_Button = UIButton()
    var Small_Eraser = UIButton()
    var Large_Eraser = UIButton()
    
    //初期化
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0)
        
        canvas_View = UIImageView(frame: CGRectMake(10, 20, 300, 420))
        canvas_View.image = UIImage(named: "White.jpeg")
        image = canvas_View.image
        canvas_View.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(canvas_View)
        
        pre_Image = canvas_View.image
        
        var Save_Button = UIButton(frame: CGRectMake(215, 505, 100, 50))
        Save_Button.backgroundColor = UIColor(red: 0.98, green: 0.66, blue: 0.28, alpha: 0.8)
        Save_Button.setTitle("Add", forState: .Normal)
        Save_Button.layer.cornerRadius = 10.0
        Save_Button.layer.borderWidth = 1
        Save_Button.addTarget(self, action: "illustSave:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Save_Button)
        
        var Undo_Button = UIButton(frame: CGRectMake(110, 505, 100, 50))
        Undo_Button.backgroundColor = UIColor.darkGrayColor()
        Undo_Button.setTitle("Undo", forState: .Normal)
        Undo_Button.layer.cornerRadius = 10.0
        Undo_Button.layer.borderWidth = 1
        Undo_Button.addTarget(self, action: "pushed_undoButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Undo_Button)
        
        var Redo_Button = UIButton(frame: CGRectMake(5, 505, 100, 50))
        Redo_Button.backgroundColor = UIColor.darkGrayColor()
        Redo_Button.setTitle("Redo", forState: .Normal)
        Redo_Button.layer.cornerRadius = 10.0
        Redo_Button.layer.borderWidth = 1
        Redo_Button.addTarget(self, action: "pushed_redoButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Redo_Button)
        
        Red_Button = UIButton(frame: CGRectMake(5, 450, 58, 50))
        Red_Button.backgroundColor = UIColor(red: 0.91, green: 0.3, blue: 0.24, alpha: 0.8)
        Red_Button.setTitle("Red", forState: .Normal)
        Red_Button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Red_Button.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        Red_Button.layer.cornerRadius = 10.0
        Red_Button.layer.borderWidth = 1
        Red_Button.enabled = false
        Red_Button.addTarget(self, action: "pushed_RedButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Red_Button)
        
        Green_Button = UIButton(frame: CGRectMake(68, 450, 58, 50))
        Green_Button.backgroundColor = UIColor(red: 0.1, green: 0.74, blue: 0.61, alpha: 0.8)
        Green_Button.setTitle("Green", forState: .Normal)
        Green_Button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Green_Button.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        Green_Button.layer.cornerRadius = 10.0
        Green_Button.layer.borderWidth = 1
        Green_Button.addTarget(self, action: "pushed_GreenButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Green_Button)
        
        Blue_Button = UIButton(frame: CGRectMake(131, 450, 58, 50))
        Blue_Button.backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.86, alpha: 0.8)
        Blue_Button.setTitle("Blue", forState: .Normal)
        Blue_Button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Blue_Button.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        Blue_Button.layer.cornerRadius = 10.0
        Blue_Button.layer.borderWidth = 1
        Blue_Button.addTarget(self, action: "pushed_BlueButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Blue_Button)
        
        Small_Eraser = UIButton(frame: CGRectMake(194, 450, 58, 50))
        Small_Eraser.backgroundColor = UIColor.lightGrayColor()
        Small_Eraser.setTitle("SErace", forState: .Normal)
        Small_Eraser.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Small_Eraser.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        Small_Eraser.layer.cornerRadius = 10.0
        Small_Eraser.layer.borderWidth = 1
        Small_Eraser.addTarget(self, action: "pushed_SEraser:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Small_Eraser)
        
        Large_Eraser = UIButton(frame: CGRectMake(257, 450, 58, 50))
        Large_Eraser.backgroundColor = UIColor.lightGrayColor()
        Large_Eraser.setTitle("LErace", forState: .Normal)
        Large_Eraser.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        Large_Eraser.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        Large_Eraser.layer.cornerRadius = 10.0
        Large_Eraser.layer.borderWidth = 1
        Large_Eraser.addTarget(self, action: "pushed_LEraser:", forControlEvents: .TouchUpInside)
        self.view.addSubview(Large_Eraser)
        
        self.myBrowser.startBrowsingForPeers();
        println("ブラウジング開始")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //書くため,No.1
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch :UITouch = touches.anyObject() as UITouch
        touchedPoint = touch.locationInView(self.canvas_View)
        bezierPath = UIBezierPath()
        bezierPath.moveToPoint(touchedPoint)
        firstMovedFlag = true
    }
    
    //書くため,No.2
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if (bezierPath == nil){
            return;
        }
        let touch :UITouch = touches.anyObject() as UITouch
        let currentPoint = touch.locationInView(self.canvas_View)
        if firstMovedFlag {
            firstMovedFlag = false
            touchedPoint = currentPoint
            return
        }
        let middlePoint = self.midPoint(touchedPoint, point1: currentPoint)
        bezierPath.addQuadCurveToPoint(middlePoint, controlPoint: touchedPoint)
        self.drawLinePreview(currentPoint)
        touchedPoint = currentPoint
    }
    
    //書くため,No.3
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if (bezierPath == nil){
            return;
        }
        let touch :UITouch = touches.anyObject() as UITouch
        let currentPoint = touch.locationInView(self.canvas_View)
        bezierPath.addQuadCurveToPoint(currentPoint, controlPoint: touchedPoint)
        self.drawline()
        bezierPath = nil
    }
    
    //書くため,No.4
    func drawLinePreview(endPoint:CGPoint){
        UIGraphicsBeginImageContextWithOptions(canvas_View.bounds.size, false, 0.0)
        canvas_View.image?.drawInRect(canvas_View.bounds)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), self.width)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),self.red,self.green,self.blue, self.alpha)
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchedPoint.x, touchedPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPoint.x, endPoint.y)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        canvas_View.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    //書くため,No.5
    func drawline(){
        UIGraphicsBeginImageContextWithOptions(canvas_View.bounds.size, false, 0.0)
        image?.drawInRect(canvas_View.bounds)
        bezierPath.lineWidth = self.width
        bezierPath.lineCapStyle = kCGLineCapRound
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),self.red,self.green,self.blue, self.alpha)
        bezierPath.stroke()
        image = UIGraphicsGetImageFromCurrentImageContext()
        canvas_View.image = image
        
        into_undoArray()
        pre_Image = canvas_View.image
        
        UIGraphicsEndImageContext()
    }
    
    //書くため,No.6
    func midPoint(point0:CGPoint, point1:CGPoint) ->CGPoint{
        let x = point0.x + point1.x
        let y = point0.y + point1.y
        return CGPointMake(x/2.0, y/2.0)
    }
    
    //赤
    func pushed_RedButton(sender : UIButton){
        ButtonStateReset()
        Red_Button.enabled = false
        
        self.width = 5.0
        self.red = 0.91
        self.green = 0.3
        self.blue = 0.24
        self.alpha = 0.8
    }
    
    //緑
    func pushed_GreenButton(sender : UIButton){
        ButtonStateReset()
        Green_Button.enabled = false
        
        self.width = 5.0
        self.red = 0.1
        self.green = 0.74
        self.blue = 0.61
        self.alpha = 0.8
    }
    
    //青
    func pushed_BlueButton(sender : UIButton){
        ButtonStateReset()
        Blue_Button.enabled = false
        
        self.width = 5.0
        self.red = 0.2
        self.green = 0.6
        self.blue = 0.86
        self.alpha = 0.8
    }
    
    //Small消しゴム
    func pushed_SEraser(sender : UIButton){
        ButtonStateReset()
        Small_Eraser.enabled = false
        
        self.width = 5.0
        self.red = 1.0
        self.green = 1.0
        self.blue = 1.0
        self.alpha = 1.0
    }
    
    //Large消しゴム
    func pushed_LEraser(sender : UIButton){
        ButtonStateReset()
        Large_Eraser.enabled = false
        
        self.width = 15.0
        self.red = 1.0
        self.green = 1.0
        self.blue = 1.0
        self.alpha = 1.0
    }
    
    //ボタン押したか押してないか
    func ButtonStateReset(){
        Red_Button.enabled = true
        Blue_Button.enabled = true
        Green_Button.enabled = true
        Small_Eraser.enabled = true
        Large_Eraser.enabled = true
    }
    
    //Undoボタン
    func into_undoArray(){
        if Image_array_undo.count == 11{
            for i in 0..<10{
                Image_array_undo[i] = Image_array_undo[i+1]
            }
        }
        else{
            Image_array_undo.append(pre_Image!)
        }
        
    }
    
    //Undo処理
    func pushed_undoButton(sender: UIButton){
        if Image_array_undo.count >= 1{
            into_redoArray()
            
            image = Image_array_undo[Image_array_undo.count-1]
            canvas_View.image = image
            pre_Image = image
            Image_array_undo.removeAtIndex(Image_array_undo.count-1)
        }
    }
    
    //Redoボタン
    func into_redoArray(){
        if Image_array_redo.count == 11{
            for i in 0..<10{
                Image_array_redo[i] = Image_array_redo[i+1]
            }
        }
        else{
            Image_array_redo.append(canvas_View.image!)
        }
        
    }
    
    //Redo処理
    func pushed_redoButton(sender: UIButton){
        if Image_array_redo.count >= 1{
            into_undoArray()
            
            image = Image_array_redo[Image_array_redo.count-1]
            canvas_View.image = image
            pre_Image = image
            Image_array_redo.removeAtIndex(Image_array_redo.count-1)
        }
    }
    
    //Sendボタン
    func illustSave(sender : UIButton){
        Illust_Array.append(image)
        var tmp = UIImageJPEGRepresentation(image, 0.8)
        
        mySession.sendData(tmp, toPeers: self.mySession.connectedPeers, withMode: MCSessionSendDataMode.Unreliable, error: nil)
        
        self.performSegueWithIdentifier("toFirst", sender: self)
    }
    
    //Segue処理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //toSecondというidentifierを持つsegueの場合
        if segue.identifier == "toFirst"{
            
            self.myBrowser.stopBrowsingForPeers();
            //SecondViewControllerを定数として宣言する
            var VC : First = segue.destinationViewController as First
            //SecondViewController内のselectWordにこのクラスのselectWordを代入する
            VC.inputArray = self.Illust_Array
        }
    }
    
}
