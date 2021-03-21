//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield:
        UITextField!
    @IBOutlet weak var msgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var typeView: UIView!
    
    var db =  Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "ta", body: "Hdsdahdajsdasdjkhakjsdhk jhaskdhkasjdhkaajkshdkjashdkasjhdkjashdkjashdkjahskdjhasasjhdkajshdkasjhdkasjhdkahdkashdksahdey"),
        Message(sender: "saw", body: "Hi"),
        Message(sender: "ta", body: "Hey")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        loadMessage()
        
    }
    
    func loadMessage() {
       
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let errorFound = error {
                                print(errorFound)
            }
            else {
                if let snapshotDocument = querySnapshot?.documents {
                    for doc in snapshotDocument {
                        //print(doc.data())
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
            }
    }
    
    
    
    @objc func keyboardWillShow( notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
            msgViewBottomConstraint.constant = keyboardHeight
            }
        
    }
    @objc func keyboardWillHide( notification: Notification) {
        msgViewBottomConstraint.constant = 0
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text , let messageSender =  Auth.auth().currentUser?.email {
            
            if messageBody.count > 0{
                if !messageBody.trimmingCharacters(in: .whitespaces).isEmpty {
                    // string contains non-whitespace characters
                    
                    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                        if let errorFound = error {
                            print(errorFound)
                        }
                        else {
                            print("Message Sent !")
                            DispatchQueue.main.async {
                                self.messageTextfield.text = ""
                            }
                            
                        }
                    }
                }
                
            }
        }
    }
 
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      
    }
}
extension ChatViewController: UITableViewDelegate {

    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = message.body
        // for myself
        if message.sender ==  Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.textLabel?.textColor = UIColor(named: K.BrandColors.purple)
        }
        // for other
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.textLabel?.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        
        return cell
    }
    
    
}
