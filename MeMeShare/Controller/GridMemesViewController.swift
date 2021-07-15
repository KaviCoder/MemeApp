//
//  GridMemesViewController.swift
//  MeMeShare
//
//  Created by Kavya Joshi on 7/13/21.
//

import UIKit



class GridMemesViewController: UICollectionViewController {
    var myMemes = ((UIApplication.shared.delegate) as! AppDelegate).memes
    
    //For the cell dimentions and distance in between(see view Did Load)
    @IBOutlet weak var layout : UICollectionViewFlowLayout!
    
    
    //Check for updated data every time the view appears
    override func viewDidAppear(_ animated: Bool) {
        myMemes = ((UIApplication.shared.delegate) as! AppDelegate).memes
        collectionView.reloadData()
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        //default flow layout
        flowLayout(space : 3,components : 4)
        
        
    }
    
    //grid flow layout when orientation changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            //  print("landscape")
            flowLayout(space : 4,components : 5)
            
        }
        else {
            //  print("portrait")
            flowLayout(space : 3,components : 4)
        }
    }
    
    
    func flowLayout(space : CGFloat,components : CGFloat)
    {
        let width = (view.frame.size.width - (space * space)) / components
        let height = (view.frame.size.height - (space * space)) / components
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        layout.itemSize = CGSize(width: width, height: height)
    
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return myMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridMemesViewCell
        cell.gridImageView.image = myMemes[indexPath.row].memeImage
        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //When an item is selected from the Grid View
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "ListMemesDetail") as! DetailViewController
        dvc.mydetailImage = myMemes[indexPath.row].memeImage
        
        navigationController!.pushViewController(dvc, animated: true)
    }
    
    
    
}
