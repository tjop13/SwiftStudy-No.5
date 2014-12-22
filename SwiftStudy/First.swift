//
//  ViewController.swift
//  List
//
//  Created by Takuro Mori on 2014/11/25.
//  Copyright (c) 2014年 Takuro Mori. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class First: Multipeer,UITableViewDelegate,UITableViewDataSource {
    //<グローバル変数宣言>
    var tableView = UITableView()
    var DrawButton = UIButton()
    var SaveButton = UIButton()
    var OpenButton = UIButton()
    var inputArray : [UIImage] = [UIImage]()
    var selectImage : UIImage!
    
    
    //<初期化>
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0)
        
        //tableview
        tableView.frame = CGRectMake(10, 20, 300, 450)
        tableView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0)
        tableView.separatorColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        var nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "IllustCell")
        self.view.addSubview(tableView)
        
        //イラスト画面へ移るボタン
        DrawButton.frame = CGRectMake(120, 480, 80, 30)
        DrawButton.backgroundColor = UIColor.blueColor()
        DrawButton.setTitle("Draw", forState: .Normal)
        DrawButton.layer.cornerRadius = 10.0
        DrawButton.addTarget(self, action: "Drawbutton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(DrawButton)
        
        //Saveボタン
        SaveButton.frame = CGRectMake(220, 480, 80, 30)
        SaveButton.backgroundColor = UIColor.blueColor()
        SaveButton.setTitle("Save", forState: .Normal)
        SaveButton.layer.cornerRadius = 10.0
        SaveButton.showsTouchWhenHighlighted = true
        SaveButton.addTarget(self, action: "Savebutton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(SaveButton)
        
        //Openボタン
        OpenButton.frame = CGRectMake(20, 480, 80, 30)
        OpenButton.backgroundColor = UIColor.blueColor()
        OpenButton.setTitle("Open", forState: .Normal)
        OpenButton.layer.cornerRadius = 10.0
        OpenButton.showsTouchWhenHighlighted = true
        OpenButton.addTarget(self, action: "Openbutton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(OpenButton)

        
    }
    
    //<メモリが足りなくなった時>
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //<画面が現れた時>
    override func viewDidAppear(animated: Bool) {
        self.mySession.disconnect()
        if inputArray.count != 0{
            tableView.reloadData()
            var indexPath = NSIndexPath(forItem: inputArray.count-1, inSection: 0)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
        //参加したい表明，開始（アドバタイジング）
        println("(Input)アドバタイズ開始")
        self.myAdvertiser.startAdvertisingPeer();
    }
    
    
    //<Drawボタンを押した時>
    func Drawbutton(sender : UIButton){
        self.performSegueWithIdentifier("toIllust", sender: self)
    }
    
    //<Saveボタン押した時>
    func Savebutton(sender : UIButton){
        ListSave()
        PictSave()
        
        inputArray.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    
    //<画像数をセーブする>
    func ListSave(){
        let documentdir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = documentdir.stringByAppendingPathComponent("List.plist")
        let fileManager = NSFileManager.defaultManager()
        
        //file exist?
        if !fileManager.fileExistsAtPath(filePath){
            let result : Bool = fileManager.createFileAtPath(filePath, contents:NSData(), attributes: nil)
            if !result{
                println("miss")
                return
            }
        }
        
        var Count = inputArray.count
        var tmp = String(Count).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        tmp?.writeToFile(filePath, atomically: true)
    }
    
    //<画像をセーブする>
    func PictSave(){
        for i in 0..<inputArray.count{
            let documentdir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let filePath = documentdir.stringByAppendingPathComponent("photo_\(i+1).jpg")
            var tmp = UIImageJPEGRepresentation(inputArray[i], 0.5)
            tmp.writeToFile(filePath, atomically: true)
        }
    }
    
    //<Openボタンを押した時>
    func Openbutton(sender:UIButton){
        FileOpen()
        tableView.reloadData()
    }
    
    //<データをOpenする>
    func FileOpen(){
        let documentdir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = documentdir.stringByAppendingPathComponent("List.plist")
        let fileManager = NSFileManager.defaultManager()
        
        //file exist?
        if !fileManager.fileExistsAtPath(filePath){
            let result : Bool = fileManager.createFileAtPath(filePath, contents:NSData(), attributes: nil)
            if !result{
                println("miss")
                return
            }
        }
        
        var CountData = NSData(contentsOfFile: filePath)
        var tmp = NSString(data: CountData!, encoding: NSUTF8StringEncoding)
        var Count = tmp?.integerValue
        
        for i in 0..<Count!{
            let filePath2 = documentdir.stringByAppendingPathComponent("photo_\(i+1).jpg")
            var Image = UIImage(contentsOfFile: filePath2)
            inputArray.append(Image!)
        }
    }
    
    //<各セルが選択された時>
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectImage = inputArray[indexPath.row]
        self.performSegueWithIdentifier("toSecond", sender: self)
    }
    
    //<セルをスワイプした時>
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            inputArray.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    //<セルの高さ>
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    //<リストに表示する要素数>
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputArray.count
    }
    
    //<リストに表示する中身>
    //リストに表示する要素数分呼び出され、その度indexPath.rowの値でインクリメントが行われる。
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("IllustCell", forIndexPath: indexPath) as CustomCell
        cell.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 0.85)
        cell.IllustImage?.image = inputArray[indexPath.row]
        return cell
    }
    
    
    //<画面遷移時に値を渡す>
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.myAdvertiser.stopAdvertisingPeer();
        self.mySession.disconnect();
        if segue.identifier == "toSecond"{
            var VC : Second = segue.destinationViewController as Second
            VC.selectImage = self.selectImage
            VC.Image_Array = self.inputArray
        }
        if segue.identifier == "toIllust"{
            var VC : Illust = segue.destinationViewController as Illust
            VC.Illust_Array = self.inputArray
        }
    }
    
    // NSDataを受信したとき呼ばれる
    override func session(session: MCSession!,
        didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!){
            println("データ受信from\(peerID.displayName)");
            var tmp : UIImage = UIImage(data: data)!
            dispatch_async(dispatch_get_main_queue()){
                self.inputArray.append(tmp)
                self.tableView.reloadData()
                var indexPath = NSIndexPath(forItem: self.inputArray.count-1, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            self.myAdvertiser.stopAdvertisingPeer();
            self.mySession.disconnect();
            self.myAdvertiser.startAdvertisingPeer()
    }
}

