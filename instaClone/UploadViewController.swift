//
//  UploadViewController.swift
//  instaClone
//
//  Created by Burak Kara on 7.12.2022.
//

import UIKit

import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       //Kullanıcı resme tıklayabiliyor mu evet :D
        //GestureRecognizer oluşturmamız gerekiyor .
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    //Kullanıcının kütüphanesine ulaşmak için picker kullanırız.
    //kullanıcıya fotoğrafı seçtirdik..
    @objc func selectImage(){
        
        let pickerController = UIImagePickerController()
        //Delegatini self yapıyoruz ki gerekli kodları burada çağırmak için .
        pickerController.delegate = self
        //kamera ile seçmeyi ekle
        pickerController.sourceType = .photoLibrary
       // pickerController.allowsEditing = true
        present(pickerController, animated: true,completion: nil)
    
    }
    //Kullanıcı fotoğraafı seçtikten sonra ne olacak kısmı burada yapılıyor .
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //. originial image  ile seçilen fotonun keyi alınıyor
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion:nil)
    }
    
    
    
    func makeAlert(titleInput:String,messageInput:String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:nil)
        alert.addAction(okButton)
        self.present(alert, animated: true , completion: nil)
        
    }
    
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        //upload işlemi stroge refenceden alınıyor.refence ile nereye kayıt ediyoruz hangi klasör vs belli olur
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        
        //İmageview içindeki veriyi kayıt edebilmemiz için veriye çevirmemiz gerekiyor .
        //UIimage olarak kayıt edilmez.
        
        
        //fotoyu sıkıştırıp veri haline getiriyor .0,5 kadar sıkıştır
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            //uuid ile rastgele unique değer oluşturup ismi benzersiz yapıyoruz.
            let uuid = UUID().uuidString
            
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
        //put data ile göderme yapılır her zaman sonunda competion olan istenir ki hata durumu takip edilebilsin.
            imageReference.putData(data,metadata:nil) { metadata, error in
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            //url al stringe çevir demek
                            let imageUrl = url?.absoluteString
                         
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            //önce reference oluşturuyoruz bu reference ile firestore database ulaşacağız .
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            //dic ile database de gerekli collection ve bilgiler oluşuturuluyor
                            
                            let firestorePost = ["imageUrl" : imageUrl! , "postedBy" : Auth.auth().currentUser!.email!, "postComment" :self.commentText.text!,"date" :FieldValue.serverTimestamp() , "likes" : 0 ] as [String : Any]
                            
                            
            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = " "
                                    self.tabBarController?.selectedIndex = 0
                                    //tabbar da ki 0.cı indexe git demek
                                }
                                
                                    })
                                      
                                  }
                              }
                          }
                      }
                  }
                  
              }
              
          }
