//
//  Multipeer.swift
//  SwiftStudy
//
//  Created by Takuro Mori on 2014/12/02.
//  Copyright (c) 2014年 Takuro Mori. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class Multipeer : UIViewController, MCSessionDelegate ,MCNearbyServiceAdvertiserDelegate,MCNearbyServiceBrowserDelegate{
    var myPeerID : MCPeerID!;
    var mySession : MCSession!;
    var myBrowser : MCNearbyServiceBrowser!;//（自分のセッションに招待するやつ）
    var myAdvertiser : MCNearbyServiceAdvertiser!;//（他セッションに参加するやつ）
    let serviceType = "swiftstudy100r";//ピアを識別するための文字列．関係ないアプリと競合しないようにする

    override func viewDidLoad() {
        super.viewDidLoad()
        /*初期化*/
        self.myPeerID = MCPeerID(displayName: UIDevice.currentDevice().name);
        self.mySession = MCSession(peer: myPeerID);
        self.myBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType);
        self.myAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType);
        /*デリゲートの設定*/
        self.mySession.delegate = self;
        self.myAdvertiser.delegate = self;
        self.myBrowser.delegate = self;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /******
    マルチピア関係の関数群
    ******/
    
    // --------------------
    // MCNearbyServiceBrowserDelegate
    // --------------------
    
    // エラーハンドリング（エラー処理）
    
    // browser:didNotStartBrowsingForPeers:
    // 検索処理に失敗したら呼ばれる.
    func browser(browser: MCNearbyServiceBrowser!,
        didNotStartBrowsingForPeers error: NSError!){
            NSLog("browserError");
    }
    // browser:foundPeer:withDiscoveryInfo:
    // ピアを発見したときに呼ばれる
    func browser(browser: MCNearbyServiceBrowser!,
        foundPeer peerID: MCPeerID!,
        withDiscoveryInfo info: [NSObject : AnyObject]!){
            println("次のピアを発見:\(peerID.displayName)");//見つかったピア名も確認
            //ピアの招待, withContextに招待するときのメッセージかける
            self.myBrowser.invitePeer(peerID, toSession: mySession, withContext: nil, timeout: 5);
    }
    
    // browser:lostPeer:
    // ピアが消えたときに呼ばれる
    func browser(browser: MCNearbyServiceBrowser!,
        lostPeer peerID: MCPeerID!){
            println("次のピアが消えました:\(peerID.displayName)"); //ロストしたピアも表示
    }
    
    
    // --------------------
    // MCNearbyServiceAdvertiserDelegate
    // --------------------
    
    // エラーハンドリング
    // advertiser:didNotStartAdvertisingPeer:
    // ピアの公開失敗時に呼ばれる
    func advertiser(advertiser: MCNearbyServiceAdvertiser!,
        didNotStartAdvertisingPeer error: NSError!){
            NSLog("ピアの公開に失敗");
    }
    
    // Invitation Handling Delegate Methods
    
    // advertiser:didReceiveInvitationFromPeer:withContext:invitationHandler:
    // 他のピアから招待されたとき呼ばれる
    func advertiser(advertiser: MCNearbyServiceAdvertiser!,
        didReceiveInvitationFromPeer peerID: MCPeerID!,
        withContext context: NSData!,
        invitationHandler: ((Bool,
        MCSession!) -> Void)!){
            println("招待されました。");
            invitationHandler(true, mySession);
            
    }
    
    // --------------------
    // MCSessionDelegate
    // --------------------
    
    // MCSession Delegate Methods
    
    // session:didReceiveData:fromPeer:
    // NSDataを受信したとき呼ばれる
    func session(session: MCSession!,
        didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!){
            println("データ受信from\(peerID.displayName)");
            var tmp2 : UIImage = UIImage(data: data)!
            dispatch_async(dispatch_get_main_queue()){
                
                //self.illustSet()
            }
    }
    
    // session:peer:didChangeState:
    // 他ピアの状態が変化したとき呼ばれる
    func session(session: MCSession!,
        peer peerID: MCPeerID!,
        didChangeState state: MCSessionState){
            println("(Input)状態変化:\(peerID)");//変化したピアIDと状態も表示
            //接続状態の処理
            if(state == MCSessionState.Connected){
                println("接続中状態に遷移");
//                dispatch_async(dispatch_get_main_queue()){
//                    self.myAdvertiser.stopAdvertisingPeer();
//                    self.myBrowser.startBrowsingForPeers();
//                }
            }
            //接続している途中状態の処理
            if(state == MCSessionState.Connecting){
                println("接続途中状態に遷移");
            }
            //接続切れた状態の処理
            if(state == MCSessionState.NotConnected){
                println("接続切れ状態に遷移");
            }
            println("セッション内のピア:\(session.connectedPeers)");
    }
    
    // session:didReceiveCertificate:fromPeer:certificateHandler:
    // 最初に接続確立したときによばれる。
    func session(session: MCSession!,
        didReceiveCertificate certificate: [AnyObject]!,
        fromPeer peerID: MCPeerID!,
        certificateHandler: ((Bool) -> Void)!){
            certificateHandler(true);
            println("接続確立");
    }
    
    /*xxxxx
    xxxここから下のメソッドは使ってません
    xxxただし，マルチピア機能を使うためには
    xxxとりあえず定義だけは必要
    xxxxx*/
    // session:didStartReceivingResourceWithName:fromPeer:withProgress:
    // Called when a remote peer begins sending a file-like resource to the local peer. (required)
    func session(session: MCSession!,
        didStartReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        withProgress progress: NSProgress!){
            NSLog("Start file-like data");
    }
    
    // session:didFinishReceivingResourceWithName:fromPeer:atURL:withError:
    // Called when a remote peer sends a file-like resource to the local peer. (required)
    func session(session: MCSession!,
        didFinishReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!,
        withError error: NSError!){
            NSLog("finish file-like data");
    }
    
    // session:didReceiveStream:withName:fromPeer:
    // Called when a remote peer opens a byte stream connection to the local peer. (required)
    func session(session: MCSession!,
        didReceiveStream stream: NSInputStream!,
        withName streamName: String!,
        fromPeer peerID: MCPeerID!){
            NSLog("receive bytestream");
    }
}