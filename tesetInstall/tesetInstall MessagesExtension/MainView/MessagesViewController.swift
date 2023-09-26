//
//  MessagesViewController.swift
//  tesetInstall MessagesExtension
//
//  Created by Serhii Molodets on 25.09.2023.
//

import UIKit
import Messages
import AVFoundation
import AVKit

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: - Properties
    private var captureSession = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var isBack = true
    private var camera: AVCaptureDevice.Position {
        if isBack {
            return AVCaptureDevice.Position.back
        } else {
            return AVCaptureDevice.Position.front
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView.layer.cornerRadius = previewView.frame.width / 2
        previewView.clipsToBounds = true
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: - Flow funcs
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        if let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: camera) {
            do {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                if captureSession.canAddInput(videoDeviceInput) {
                    captureSession.addInput(videoDeviceInput)
                }
            } catch {
                print("Error creating video device input: \(error)")
            }
        }
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            do {
                let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                if captureSession.canAddInput(audioDeviceInput) {
                    captureSession.addInput(audioDeviceInput)
                }
            } catch {
                print("Error creating audio device input: \(error)")
            }
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    fileprivate func prepareMessage(with url: URL, session: MSSession? = nil) -> MSMessage? {
        let components = URLComponents()
        let layout = MSMessageTemplateLayout()
        layout.mediaFileURL = url
        let message = MSMessage(session: session ?? MSSession())

        message.layout = layout
        return message
    }
    
    func sendMedia(with url: URL) {
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        guard let message = prepareMessage(with: url, session: conversation.selectedMessage?.session)
        else { return }
        // Add the message to the conversation.
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
        dismiss()
    }
    
    func performContinuousAction() {
        recordButton.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
        let outputPath = NSTemporaryDirectory() + "output.mov"
        let outputFileURL = URL(fileURLWithPath: outputPath)
        movieOutput.startRecording(to: outputFileURL, recordingDelegate: self)
    }
    
    func stopContinuousAction() {
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
        movieOutput.stopRecording()
        captureSession.stopRunning()
    }
    
    @IBAction func recordButtonTouchDown(_ sender: UIButton) {
        performContinuousAction()
    }
    
    
    @IBAction func recordButtonTouchUpInside(_ sender: UIButton) {
        stopContinuousAction()
    }
}

extension MessagesViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Video recording error: \(error)")
        } else {
            sendMedia(with: outputFileURL)
        }
    }
}
