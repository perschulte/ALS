//
//  ViewController.swift
//  ALS
//
//  Created by Per Schulte on 02.05.16.
//  Copyright © 2016 Per Schulte. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBAction func speak(sender: UIButton) {
        
        let speechUtterance = AVSpeechUtterance(string: textView.text!)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if (voice.language == "de-DE" && voice.name == AVSpeechSynthesisVoiceIdentifierAlex) {
                speechUtterance.voice = AVSpeechSynthesisVoice(identifier: voice.identifier)
            }
        }
        speechSynthesizer.speakUtterance(speechUtterance)
    }
    @IBAction func deleteText(sender: UIButton) {
        textView.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        textView.becomeFirstResponder()
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
}

