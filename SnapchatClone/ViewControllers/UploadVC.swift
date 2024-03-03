//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Seyhun Koçak on 27.02.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePic))
        uploadImageView.addGestureRecognizer(gestureRecognizer)

    }
    @objc func choosePic(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

    @IBAction func uploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storagRef = storage.reference()
        
        let mediaFolder = storagRef.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message:error?.localizedDescription ?? "Error")
                    
                }else {
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDict = ["imageUrlArray":imageUrlArray] as [String:Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDict, merge: true) { error in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(named: "select.png")
                                                        
                                                    }
                                                }
                                            }
                                            
                                            
                                            
                                            
                                        }
                                    } else {
                                        
                                        let snapDict = ["imageUrlArray":[imageUrl!], "snapOwner": UserSingleton.sharedUserInfo.username, "date": FieldValue.serverTimestamp()] as [String:Any]
                                        fireStore.collection("Snaps").addDocument(data: snapDict) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(named: "select.png")
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            
                            
                            

                            
                        }
                    }
                    
                }
            }
            
        }
        
    }


}
