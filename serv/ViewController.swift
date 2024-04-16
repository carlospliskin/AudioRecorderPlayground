//
//  ViewController.swift
//  serv
//
//  Created by Carlos Paredes León on 20/04/22.
//

import UIKit
import MediaPlayer
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate
{
    
    private var audioLevel : Float = 0.0
    
    @IBOutlet weak var RecorderBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    
    var soundRecorder = AVAudioRecorder()
    var soundPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        listenVolumeButton()
    }
    
    
    //MARK:- Acciones BTN
    
    @IBAction func Record(_ sender: Any)
    {
        
    }
    
    @IBAction func PlaySound(_ sender: Any)
    {
        
    }
    
    
    func setupRecorder() {
        let recordSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        do {
            soundRecorder = try AVAudioRecorder(url: getFileURL() as URL, settings: recordSettings)
        } catch {
            print("Error al configurar el grabador de audio: \(error.localizedDescription)")
        }
    }

    func getFileURL() -> NSURL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as NSString
        let audioFilename = documentDirectory.appendingPathComponent("audioRecording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        return audioURL
    }

    
    func listenVolumeButton()
    {
        let audioSession = AVAudioSession.sharedInstance()
        do
        {
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(self, forKeyPath: "outputVolume",
                                     options: NSKeyValueObservingOptions.new, context: nil)
            audioLevel = audioSession.outputVolume
        } catch
        {
            print("Error")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "outputVolume"{
            let audioSession = AVAudioSession.sharedInstance()
            if audioSession.outputVolume > audioLevel {
                print("Arriba")
                audioLevel = audioSession.outputVolume
            }
            if audioSession.outputVolume < audioLevel {
                print("Abajo")
                audioLevel = audioSession.outputVolume
            }
            if audioSession.outputVolume > 0.999 {
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0.9375, animated: false)
                audioLevel = 0.9375
            }
            
            if audioSession.outputVolume < 0.000 {
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0.0625, animated: false)
                audioLevel = 0.0625
            }
        }
    }
}

