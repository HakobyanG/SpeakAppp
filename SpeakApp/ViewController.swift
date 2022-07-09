//
//  ViewController.swift
//  SpeakApp
//
//  Created by Garnik on 7/2/22.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask? = SFSpeechRecognitionTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.backgroundColor = .systemGreen
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        }
        catch {
            return print(error)
        }
        
        guard let myRecongniser = SFSpeechRecognizer() else { return }
        if !myRecongniser.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
                self.checkForColorsSaid(resultString: lastString)
            } else if let error = error {
                print(error)
            }
        })
    }
    
    func checkForColorsSaid(resultString: String) {
        switch resultString {
        case "red":
            colorView.backgroundColor = UIColor.red
        case "orange":
            colorView.backgroundColor = UIColor.orange
        case "yellow":
            colorView.backgroundColor = UIColor.yellow
        case "blue":
            colorView.backgroundColor = UIColor.blue
        case "green":
            colorView.backgroundColor = UIColor.green
        case "purple":
            colorView.backgroundColor = UIColor.purple
        case "black":
            colorView.backgroundColor = UIColor.black
        case "white":
            colorView.backgroundColor = UIColor.white
        case "gray":
            colorView.backgroundColor = UIColor.gray
        case "brown":
            colorView.backgroundColor = UIColor.brown
        case "cyan":
            colorView.backgroundColor = UIColor.cyan
        case "pink":
            colorView.backgroundColor = UIColor.systemPink
        case "teal":
            colorView.backgroundColor = UIColor.systemTeal
        case "mint":
            colorView.backgroundColor = UIColor.systemMint
        default:
            print("error")
        }
    }

    @IBAction func startButton(_ sender: Any) {
        self.recordAndRecognizeSpeech()
        startButton.backgroundColor = .red
    }
}

