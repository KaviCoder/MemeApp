//
//  ListMemesViewController.swift
//  MeMeShare
//
//  Created by Kavya Joshi on 7/13/21.
//

import UIKit

class ListMemesViewController: UITableViewController {
    
    var myMemes = ((UIApplication.shared.delegate) as! AppDelegate).memes

    
    //Check for updated data every time the view appears
    override func viewWillAppear(_ animated: Bool) {
         myMemes = ((UIApplication.shared.delegate) as! AppDelegate).memes
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myMemes.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListMemesViewCell
        cell.listImageView.image = myMemes[indexPath.row].memeImage
        cell.labelView.text = myMemes[indexPath.row].topText + "  " + myMemes[indexPath.row].bottomText
        // Configure the cell...

        return cell
    }
    
    
    
    //When a row is selected from the List View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "ListMemesDetail") as! DetailViewController
        dvc.mydetailImage = myMemes[indexPath.row].memeImage
        
        navigationController!.pushViewController(dvc, animated: true)
    }
   
    }



