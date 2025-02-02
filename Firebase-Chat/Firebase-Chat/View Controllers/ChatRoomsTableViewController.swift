//
//  ChatRoomsTableViewController.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/17/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomsTableViewController: UITableViewController {

	@IBOutlet weak var textFieldContainerView: UIView!
	@IBOutlet weak var chatRoomNameTextField: UITextField!

	let chatRoomController = ChatRoomController()

	let rootRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		chatRoomController.fetchChatRooms {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
    }

	@IBAction func createChatRoom(_ sender: Any) {
		chatRoomNameTextField.resignFirstResponder()

		guard let roomName = chatRoomNameTextField.text,
			!roomName.isEmpty else { return }

		let chatRoom = ChatRoom(name: roomName)
		chatRoomController.createChatRoom(with: chatRoom)

		chatRoomNameTextField.text = ""
	}


	// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let messagesVC = segue.destination as? MessagesDetailViewController,
			let indexPath = tableView.indexPathForSelectedRow {
			messagesVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
			messagesVC.chatRoomController = chatRoomController
		}
    }

}
