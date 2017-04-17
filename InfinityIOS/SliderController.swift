//
//  SliderController.swift
//  InfinityIOS
//
//  Created by Ajay Saini on 10/04/17.
//  Copyright © 2017 Technolabs. All rights reserved.
//

import UIKit
import ImageSlideshow


class DashboardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
}

class SliderController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

   
    @IBOutlet weak var dashboardView: UICollectionView!
    
    var items = ["My Car", "Services", "Insurance", "Offers", "New Car", "Tips", "Contactus", "Tracker", "Hotlines"]
    var icons = ["offers.png?token=APK02bNySGzEy51ZAAOAVb3pEZ73yvf7ks5Y9JlLwA%3D%3D",
                 "services.jpg?token=APK02Vcy4kS8JxivqE77ZY9wSHDPs8jrks5Y9K0fwA%3D%3D",
                 "insurance.jpg?token=APK02TIs6fMHAaxKa-ufztSB77QtPj6eks5Y9JqrwA%3D%3D",
                 "insurance.jpg?token=APK02TIs6fMHAaxKa-ufztSB77QtPj6eks5Y9JqrwA%3D%3D",
                 "new-car-icon.png?token=APK02Ter0SCyyp0Qw-12mdKGRYEOUSCQks5Y9KwZwA%3D%3D",
                 "insurance.jpg?token=APK02TIs6fMHAaxKa-ufztSB77QtPj6eks5Y9JqrwA%3D%3D",
                 "location.png?token=APK02e0yMe7LeZzLp5DKDZsJJHpAG4wZks5Y9KzLwA%3D%3D",
                 "insurance.jpg?token=APK02TIs6fMHAaxKa-ufztSB77QtPj6eks5Y9JqrwA%3D%3D",
                 "hotlines.png?token=APK02aqIv4kLIEJf2HSNg6CoNOmqjiyoks5Y9J7jwA%3D%3D"]

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    //let localSource = [ImageSource(imageString: "card_1")!, ImageSource(imageString: "card_1")!, ImageSource(imageString: "card_1")!]
    let alamofireSource = [AlamofireSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, AlamofireSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.currentPageChanged = { page in
            //print("current page:", page)
        }
        
        // try out other sources such as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(alamofireSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
        dashboardView.delegate = self
        dashboardView.dataSource = self
    }
    
    func didTap() {
        slideshow.presentFullScreenController(from: self)
    }
    
    
    private let minItemSpacing: CGFloat = 2
    private let itemWidth: CGFloat      = 100
   // private let headerHeight: CGFloat   = 32
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Create our custom flow layout that evenly space out the items, and have them in the center
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = minItemSpacing
        layout.minimumLineSpacing = minItemSpacing
        //layout.headerReferenceSize = CGSize(width: 0, height: headerHeight)
        
        // Find n, where n is the number of item that can fit into the collection view
        var n: CGFloat = 1
        let containerWidth = dashboardView.bounds.width
        while true {
            let nextN = n + 1
            let totalWidth = (nextN*itemWidth) + (nextN-1)*minItemSpacing
            if totalWidth > containerWidth {
                break
            } else {
                n = nextN
            }
        }
        
        // Calculate the section inset for left and right.
        // Setting this section inset will manipulate the items such that they will all be aligned horizontally center.
        let inset = max(minItemSpacing, floor( (containerWidth - (n*itemWidth) - (n-1)*minItemSpacing) / 2 ) )
        layout.sectionInset = UIEdgeInsets(top: minItemSpacing, left: inset, bottom: minItemSpacing, right: inset)
        
        dashboardView.collectionViewLayout = layout
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashViewCell", for: indexPath as IndexPath) as! DashboardViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.title.text = self.items[indexPath.item]
        let fx = "https://raw.githubusercontent.com/technolabs/biznomyApps/master/frontend/staticapps/PrimeHonda/www/img/";
        let u = fx+icons[indexPath.item];
       
        if let data = NSData(contentsOf: NSURL(string: u)! as URL) {
            cell.icon?.image = UIImage(data: data as Data)
        }
        
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
