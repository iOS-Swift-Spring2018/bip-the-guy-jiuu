//
//  ViewController.swift
//  Bip The Guy
//
//  Created by Brian Wang on 2/10/18.
//  Copyright © 2018 Ji Woo Pak. All rights reserved
//

import UIKit
import AVFoundation

// We need to declare the two additional delegate protocols below in order to use a UIImagePickerController
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    

    @IBOutlet weak var imageToPunch: UIImageView!
    
    var audioPlayer = AVAudioPlayer()
    
    // Creates an instance of UIImagePickerController named imagePicker
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Called to make the image spring when pressed
    func animateImage() {
        // save the original bounds of imageToPunch
        let bounds = self.imageToPunch.bounds
        // we'll shrink the image by this amount, then set our end-state in the animation to bounds, above, which is the original size before we apply the shrinkValue.
        let shrinkValue: CGFloat = 60
        
        // shrink our imageToPunch by the shrinkValue set above
        self.imageToPunch.bounds = CGRect(x: self.imageToPunch.bounds.origin.x + shrinkValue, y: self.imageToPunch.bounds.origin.y + shrinkValue, width: self.imageToPunch.bounds.size.width - shrinkValue, height: self.imageToPunch.bounds.size.height - shrinkValue)
        
        // then animate it back out to the original bounds, usingSpringWithDamping will give it some bounce.
        // withDuration is in seconds, usingSpringWithDamping will have no spring at 1, so 0.2 is pretty springy. initialSpringVelocity determines how strong the spring starts off. Higher numbers are 'stronger'.
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: { self.imageToPunch.bounds = bounds }, completion: nil)
    }
    
    // Basically the same function we'd implemented earlier, with the addition of an inout parameter so we can update any audioPlayer we pass into the function.
    func playSound(soundName: String, audioPlayer: inout AVAudioPlayer) {
        if let sound = NSDataAsset(name: soundName) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("ERROR: Data from \(soundName) could not be played as an audio file")
            }
        } else {
            print("ERROR: Could not load datea from file \(soundName)")
        }
    }
    
    // This method is required to get the image picked from the UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info[] parameter will get a particular kind of media.  Here we get the original image.  We use as! UIImage to cast the data passed into selectedImage as a UIImage.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Add our selectedImage to the .image parameter of our imageToPunch
        imageToPunch.image = selectedImage
        // Now that we've got the image we can close the UIImagePicker using the dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    // This method is required so that the UIImagePickerController can be canceled by the user without picking an image.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // We wrote this method in an earlier app and reuse it here.  Note that this implementation allows us to pass in a title and message parameter, so it's very reusable.
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

    @IBAction func libraryPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        
        // Check to see if the camera is available.  If we didn't have this & clicked the "Camera" button in the simulator, our app would crash.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
    
    // An action for the tap gesture recognizer that we added to our imageToPunch image
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        animateImage()
        playSound(soundName: "punchSound", audioPlayer: &audioPlayer)
    }
    
}

