//
//  ViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 15/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView? = UITableView()
    
   // @IBOutlet var tableView: UITableView!
    
    var items: [String] = ["Push Behavior", "Snap Behavior", "Phonemes","Phonemes in TextView", "Main Gestures"]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.randomColor()
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
     
        
        tableView!.delegate = self
        tableView!.dataSource = self
    }
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView!.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        //let cell:UITableViewCell = self.tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = self.items[row]
        
        return cell
    }
   
    // MARK: - UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       
        let row = indexPath.row
        print("You selected cell #\(row)!")
        
        animteWithDuratio(row)
        
    }
    
    func animteWithDuratio(rows:Int)
    {
        UIView.animateWithDuration(0.5) { 
            
            switch (rows)
            {
                case 0:
                    if let pushBehaviorTests = self.storyboard?.instantiateViewControllerWithIdentifier("TestViewController") {
                        self.navigationController?.pushViewController(pushBehaviorTests, animated: true)
                    }
                //print("zero")
                case 1:
                    if let snapping = self.storyboard?.instantiateViewControllerWithIdentifier("SnapingViewController") {
                        self.navigationController?.pushViewController(snapping, animated: true)
                    }
                //print("one")
                case 2:
                    if let phonemes = self.storyboard?.instantiateViewControllerWithIdentifier("PhonemesViewController") {
                        self.navigationController?.pushViewController(phonemes, animated: true)
                    }
                //print("two")
                case 3:
                    if let phoTextView = self.storyboard?.instantiateViewControllerWithIdentifier("PhonemesThirdViewController") {
                        self.navigationController?.pushViewController(phoTextView, animated: true)
                    }
                // print("three")
                case 4:
                    
                    if let mainGesture = self.storyboard?.instantiateViewControllerWithIdentifier("GesturesViewController") {
                        self.navigationController?.pushViewController(mainGesture, animated: true)
                    }
                // print("four")
                    
                default:
                print("Integer out of range")
            }
 
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
