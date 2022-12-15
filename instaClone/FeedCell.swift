//
//  FeedCell.swift
//  instaClone
//
//  Created by Burak Kara on 9.12.2022.
//

import UIKit

import FirebaseFirestore


class FeedCell: UITableViewCell {
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1 ] as [String : Any]
            firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore,merge: true)
            
        }
    }
    
 
    
}

