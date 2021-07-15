//
//  ViewController.swift
//  MeMeShare
//
//  Created by Kavya Joshi on 7/6/21.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    //photo library
    @IBOutlet weak var barButton1: UIBarButtonItem!
    //Camera
    @IBOutlet weak var barButton2: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var originalImage : UIImage?
    
    var imagePicker = UIImagePickerController()
    
    //subscribe and unsubscribe to the keyboard notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       subscribeToKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unsubscribeToKeyboardNotification()
        
    }
    
    //After app launched
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        topText.delegate = self
        bottomText.delegate = self
        
        //UI initialization
        if UIDevice.isSimulator
        {uiAttributesAccordingly(didLoad : true, isSimulator: true)
        }
        else{uiAttributesAccordingly(didLoad : true)
        }
        
    }
  
    
    //MARK:- This function is called once user chooses camera.
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
        //Check if the camera is available or not
        guard UIImagePickerController.isSourceTypeAvailable(.camera)
                else { return }
       
       //if available, set the sourcetype
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = [kUTTypeImage as String]
      
    //present the UIImagePicker on full screen for camera.
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
     }
    

        
    
    //MARK: When user selected photo library to select picture
    @IBAction func photoFolderPressed(_ sender: UIButton) {
        //Check if the library is available or not
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                else { return }
       
       //if available, set the sourcetype
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = [kUTTypeImage as String]
      
    //present the UIImagePicker modally for photo album and set the source View as sender
        imagePicker.modalPresentationStyle = .popover         //important
        
        self.present(imagePicker, animated: true, completion: nil)
        imagePicker.popoverPresentationController?.sourceView = sender
        
    }
    
    //MARK: Image Picker controller delegate functions
    //tells the controller or delegate if the user selected the clicked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

       
    let tempImage = info[.originalImage] as? UIImage
       
        originalImage = tempImage!
        imageView.image = originalImage
        
        //Check to enable/disable share button
      uiAttributesAccordingly()
       
        self.dismiss(animated: true)
    }
    

    
    func imagePickerControllerDidCancel(_ picker:
                          UIImagePickerController) {
      dismiss(animated: true, completion: nil)
    }
   
    //MARK:- Observing to NSNotification for keyboardwillshow and keyboardWillHide
    //My Class will observe to notification object
    
    func subscribeToKeyboardNotification()
    {
        NotificationCenter.default.addObserver(self, selector : #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector : #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   @objc func keyboardWillShow( notification : NSNotification)
   {
    
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !topText.isEditing
            {       if self.view.frame.origin.y == 0
            {self.view.frame.origin.y -= keyboardSize.height}
                }
        }
            
    }
  
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !topText.isEditing{
                if self.view.frame.origin.y != 0
                {
                self.view.frame.origin.y += keyboardSize.height
                }}
            
            uiAttributesAccordingly()
        }
    }
    
    func unsubscribeToKeyboardNotification()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object : nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object : nil)
    }
    
    
    //MARK:- Share button is pressed:
    //After disabling share button, we will present  activity View Controller
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        
        let myImage = generateMemedImage()
        let myActivityItems = [myImage]
        let activityController = UIActivityViewController(activityItems: myActivityItems, applicationActivities: .none)
       // activityController.popoverPresentationController?.sourceView = self.view// so that iPads won't crash
        
        activityController.completionWithItemsHandler = { activity, completed, items, error in
         
            if completed {
                
                print("here here")
         
            self.saveImage(sharedMeme: myImage)}
                                           }
        
        if let wPPC = activityController.popoverPresentationController {
          
            wPPC.barButtonItem = self.shareButton
        }
        // exclude some activity types from the list (optional)
                activityController.excludedActivityTypes = [  UIActivity.ActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityController, animated: true, completion: nil)
                
        
        uiAttributesAccordingly()
        
    }
    //MARK:- Cancel Meme is pressed on the navigation bar
    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        uiAttributesAccordingly(cancelMeme : true)
        self.dismiss(animated: true)
        
    }
}

//MARK:- UITextFieldDelegate methods implementation

extension ViewController :UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      uiAttributesAccordingly()
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
        uiAttributesAccordingly()
    }
    
    //MARK:- Share the Memed picture
    func saveImage(sharedMeme : UIImage)
    {
        // unwrap optionals - reverify the fields
        if imageView.image != nil && topText.text != nil && bottomText.text != nil
        {
        let top = self.topText.text!
       
        let bottom = self.bottomText.text!
       
            let meme =  MeMeShareModal(topText: top, bottomText: bottom, originalImage: originalImage!, memeImage: sharedMeme)
      
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
            
            print("Meme is saved")
    
        }
    }
    
    //MARK:- Create an image from current UIView(image + top text + bottom text)
    func generateMemedImage() -> UIImage {
          //Hide the tootbar

     self.toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    
        //Again show the tool bar
        self.toolBar.isHidden = false

        return memedImage
    }
    
   
    
    
    func uiAttributesAccordingly(didLoad: Bool = false, cancelMeme : Bool = false, isSimulator : Bool = false)
{
    
        
        if didLoad
        {
        topText.defaultTextAttributes = Attributes.memeTextAttributes
        bottomText.defaultTextAttributes = Attributes.memeTextAttributes
        topText.textAlignment = .center
        bottomText.textAlignment = .center
            topText.text = ""
            bottomText.text = ""
            
            if isSimulator
            {
                //Disable camera for simulator
                self.barButton2.isEnabled = false
            }
            
        }
        if cancelMeme{
            imageView.image = nil
            topText.placeholder = "Top Text"
            bottomText.placeholder = "Bottom Text"
            topText.text = ""
            bottomText.text = ""
            
        }
        enableShareButtonValidate()
}
    //Enabling and disabling of Share button
    func enableShareButtonValidate()
    {
        if imageView.image != nil && topText.text != "" && bottomText.text != ""

        {
            shareButton.isEnabled = true
        }
        else
        {
            shareButton.isEnabled = false
        }
}
   
}
extension UIDevice {
    static var isSimulator: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    
    
}
