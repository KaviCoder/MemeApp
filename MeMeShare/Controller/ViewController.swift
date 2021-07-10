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
    
    @IBOutlet weak var barButton1: UIBarButtonItem!
    @IBOutlet weak var barButton2: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var originalImage : UIImage?
    
    var imagePicker = UIImagePickerController()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
        NSAttributedString.Key.strokeWidth: 5.00
    ]
    
    //MARK:- Share button is pressed:
    //After disabling share button, we will present  activity View Controller
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        
       
        enableShareButtonValidate()
        let myImage = generateMemedImage()
        let myActivityItems = [myImage]
        let activityController = UIActivityViewController(activityItems: myActivityItems, applicationActivities: .none)
       // activityController.popoverPresentationController?.sourceView = self.view// so that iPads won't crash
        
        activityController.completionWithItemsHandler = { activity, completed, items, error in
         
                       if completed {
         
                           self.saveImage(sharedMeme: myImage)
         
                       }
        
                   }
        
        if let wPPC = activityController.popoverPresentationController {
          
            wPPC.barButtonItem = self.shareButton
        }
        // exclude some activity types from the list (optional)
                activityController.excludedActivityTypes = [  UIActivity.ActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityController, animated: true, completion: nil)
                
        
        enableShareButtonValidate()
        
    }
    
    //MARK:- Cancel Meme is pressed on the navigation bar
    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        
        imageView.image = nil
        topText.placeholder = "Top Text"
        bottomText.placeholder = "Bottom Text"
        topText.text = ""
        bottomText.text = ""
        enableShareButtonValidate()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        topText.delegate = self
        bottomText.delegate = self
        
     
            
            topText.defaultTextAttributes = memeTextAttributes
            bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        
        //To validate share button should be enabled or disabled
     enableShareButtonValidate()
        
   
    }
    
    //subscribe and unsubscribe to the keyboard notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       subscribeToKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unsubscribeToKeyboardNotification()
        
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
        enableShareButtonValidate()
       
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
        }
    }
    
    func unsubscribeToKeyboardNotification()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object : nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object : nil)
    }
    
}

//MARK:- UITextFieldDelegate methods implementation

extension ViewController :UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
       if textField.text == "Bottom Text" || textField.text == "Top Text"
        {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enableShareButtonValidate()
        return textField.resignFirstResponder()
    }
    
  
    
    //MARK:- Share the Memed picture
    func saveImage(sharedMeme : UIImage)
    {
        
        // unwrap optionals
       
                  if imageView.image != nil && topText.text != nil && bottomText.text != nil
       
                  {
       
                      let top = self.topText.text!
       
                      let bottom = self.bottomText.text!
       
                      
       
                  let meme =  MeMeShareModal(topText: top, bottomText: bottom, originalImage: originalImage, memeImage: sharedMeme)
      
                    (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    
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
    
    //Enabling and disabling of Share button
    func enableShareButtonValidate()
    {
        if imageView.image != nil && topText.text != nil && bottomText.text != nil

        {
            shareButton.isEnabled = true
        
    }
        else{
            shareButton.isEnabled = false
        }
    
    
}
}
