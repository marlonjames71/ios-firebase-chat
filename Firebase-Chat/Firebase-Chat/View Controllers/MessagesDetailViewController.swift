//
//  MessageDetailViewController.swift
//  Firebase-Chat
//
//  Created by Marlon Raskin on 9/18/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessagesDetailViewController: MessagesViewController {

	let messagesController = MessageController()
	var chatRoomController: ChatRoomController?
	var chatRoom: ChatRoom?

    override func viewDidLoad() {
        super.viewDidLoad()
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self
		messageInputBar.delegate = self

		guard let room = chatRoom else { return }

		messagesController.currentUser = Sender(id: "marlon71", displayName: "Marlon")

		messagesController.fetchMessages(with: room) {
			DispatchQueue.main.async {
				self.messagesCollectionView.reloadData()
			}
		}
    }
}

extension MessagesDetailViewController: MessagesDataSource {

	func currentSender() -> SenderType {
		guard let user = messagesController.currentUser else { fatalError("No user set")  }
		return user
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		guard let messages = chatRoom?.messages else { fatalError("No messages found") }
		let message = messages[indexPath.item]
		
		return message
	}

	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return 1
	}

	func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
		guard let messages = chatRoom?.messages else { return 0 }
//		return messagesController.messages.count
		return	messages.count
	}
}

extension MessagesDetailViewController: MessagesDisplayDelegate {
	func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
		guard let user = messagesController.currentUser else { fatalError("No user set") }

		guard let messages = chatRoom?.messages else { return .bubbleOutline(.blue) }

		let aMessage = messages[indexPath.item]

		if aMessage.sender.senderId == user.senderId {
			return .bubbleTailOutline(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), .bottomRight, .pointedEdge)
		} else {
			
			return .bubbleTailOutline(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), .bottomLeft, .pointedEdge)
		}
	}
}

extension MessagesDetailViewController: InputBarAccessoryViewDelegate {
	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		print("text: \(text)")

		inputBar.inputTextView.text = ""

		guard let room = chatRoom else {
			fatalError("No thread set!")
		}

		guard let user = messagesController.currentUser else {
			fatalError("No user set!")
		}

		messagesController.createMessage(chatRoom: room, with: text, sender: user)
	}
}

extension MessagesDetailViewController: MessagesLayoutDelegate {
	func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		guard let user = messagesController.currentUser else { fatalError("No user set") }

		if message.sender.senderId == user.senderId {
			return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
		} else {
			return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
		}
	}
}


