//
//  ViewController.swift
//  ALS
//
//  Created by Per Schulte on 02.05.16.
//  Copyright © 2016 Per Schulte. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var key = "spokenText"
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var spokenSnippets = [String]()
    
    @IBAction func pressSpeak(sender: UIButton) {
        speak(textView!.text)
    }
    
    func speak(text: String) {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if (voice.language == "de-DE" && voice.name == AVSpeechSynthesisVoiceIdentifierAlex) {
                speechUtterance.voice = AVSpeechSynthesisVoice(identifier: voice.identifier)
            }
        }
        speechSynthesizer.speakUtterance(speechUtterance)
        
        let snippet = textView!.text
        if !spokenSnippets.contains({$0 == snippet}) {
            spokenSnippets.append(snippet)
            tableView.reloadData()
            saveToUserDefaults()
            
            if spokenSnippets.count > 20 {
                spokenSnippets.removeFirst()
            }
        }
    }
    
    func saveToUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(spokenSnippets, forKey: key)
        defaults.synchronize()
    }
    
    func readFromUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let array = defaults.objectForKey(key) {
            spokenSnippets = array as! [String]
        }
    }
    
    @IBAction func deleteText(sender: UIButton) {
        textView.text = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        readFromUserDefaults()
    }
    
    override func viewWillDisappear(animated: Bool) {
        saveToUserDefaults()
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        textView.becomeFirstResponder()
        readFromUserDefaults()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomConstraint.constant = 20 + keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomConstraint.constant = 20 - keyboardSize.height
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spokenSnippets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = spokenSnippets[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let snippet = spokenSnippets[indexPath.row]
        speak(snippet)
    }
}

