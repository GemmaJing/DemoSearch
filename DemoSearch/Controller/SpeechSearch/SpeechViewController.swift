//
//  SpeechViewController.swift
//  DemoSearch
//
//  Created by Gemma Jing on 20/11/2017.
//  Copyright © 2017 Gemma Jing. All rights reserved.
//

import UIKit
import Speech

class SpeechViewController: UIViewController, SFSpeechRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {

    //MARK: outlet
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var speechTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: get database and filtered data
    var dict:[String:[String]] = [:]
    var categories:[String] = []
    var filteredData: [String] = []
    var searchFood: String = ""
    
    
    //MARK: speech
    //MARK : speech recognizer
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-UK"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func startRecording(){
        if recognitionTask != nil{
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        }catch{
            print("audioSession properties weren't set because of an error")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else{
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {(result, error) in
            var isFinal = false
            if result != nil{
                self.speechTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){(buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            print("AudioEngine couldn't start because of an error")
        }
        speechTextView.text = "Tell me about what you just eat, I am listening."
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            microphoneButton.isEnabled = true
        }else{
            microphoneButton.isEnabled = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //speech
        microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization{ authStatus in
            OperationQueue.main.addOperation {
                switch authStatus{
                case .authorized:
                    self.microphoneButton.isEnabled = true
                case .denied:
                    self.microphoneButton.isEnabled = false
                    self.microphoneButton.setTitle("user denied to speech recognition", for: .disabled)
                case .restricted:
                    self.microphoneButton.isEnabled = false
                    self.microphoneButton.setTitle("speech recognition restricted on the device", for: .disabled)
                case .notDetermined:
                    self.microphoneButton.isEnabled = false
                    self.microphoneButton.setTitle("speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: microphontButton tapped
    @IBAction func microphoneTapped(_ sender: UIButton) {
        if audioEngine.isRunning{
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start recording", for: .normal)
        }
        else{
            startRecording()
            self.speechTextView.text = "I am listening."
            microphoneButton.setTitle("Stop recording...", for: .normal)
        }
    }


    
    @IBAction func confirmSpeech(_ sender: Any){
        
        
        let text = speechTextView.text
        let food = NaturalLanguageProcess().findInformation(speech: text!)
        if ((food["Noun"]! == "") || (food["Determiner"]! == "")) {
            speechTextView.text = "Please tell me what you have eaten and how much."
        }
        else{
            speechTextView.text = "You have eaten: "
            speechTextView.text.append(food["Determiner"]!)
            speechTextView.text.append(" ")
            speechTextView.text.append(food["Noun"]!)
            searchFood = food["Noun"]!.captilizeFirstLetter()
            speechTextView.text.append("\n \r Please confirm by selecting the correct item in the table below.")
        }
        
        filteredData = categories.filter({
            $0.range(of: searchFood, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }

    // MARK: load table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "speechSearchResults")
        cell?.textLabel?.text = String(filteredData[indexPath.row])
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }

}

//MARK: for dictionary search
extension String{
    func captilizeFirstLetter() -> String{
        return prefix(1).uppercased() + dropFirst()
    }
    mutating func captilizeFirstLetter(){
        self = self.captilizeFirstLetter()
    }
}

