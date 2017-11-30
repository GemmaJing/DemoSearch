//
//  ViewController.swift
//  DemoSearch
//
//  Created by Gemma Jing on 05/11/2017.
//  Copyright © 2017 Gemma Jing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: loading database
    var dictViewCont: [String:[String]] = [:]
    var categoryViewCont: [String] = []
    
    //MARK: pass to the next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // CatagoryDetailsViewController
        if segue.identifier == "loadDatabase" {
            let categoryViewController: CategoryViewController = segue.destination as! CategoryViewController
            categoryViewController.dict = dictViewCont
            categoryViewController.categories = categoryViewCont
        }
        //SpeechViewControlller
        if segue.identifier == "loadSpeechDatabase" {
            let speechViewController: SpeechViewController = segue.destination as! SpeechViewController
            speechViewController.dict = dictViewCont
            speechViewController.categories = categoryViewCont
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictViewCont = foodData().categorizeItems()
        categoryViewCont = foodData().categorizeItems().keys.sorted(by: <)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testingTapped(_ sender: UIButton) {
        //foodData().categorizeItems()
    }
    
}

