//
//  DetailViewController.swift
//  MeMeShare
//
//  Created by Kavya Joshi on 7/13/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailImage: UIImageView!
    
    var mydetailImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let myDetailImage = mydetailImage
        {
            detailImage.image = myDetailImage
        }
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
