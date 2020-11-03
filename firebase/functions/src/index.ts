import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import {isArray} from 'lodash'
import Timestamp = admin.firestore.Timestamp;
import DocumentData = admin.firestore.DocumentData;
import DocumentReference = admin.firestore.DocumentReference;
import FieldValue = admin.firestore.FieldValue;

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const unreadMessageCounterIncrement = functions.firestore
    .document('chats/{chatId}/messages/{messageId}')
    .onCreate(async (snapshot, context) => {
        const {chatId} = context.params;
        const sendBy = snapshot.data().sendBy;
        const chat: DocumentReference = db.collection('chats').doc(chatId);
        const chatData = (await chat.get()).data();
        const unreadByCounter: Record<string, FieldValue> = {};
        if (chatData != undefined && isArray(chatData.users)) {
            for (const userId of chatData.users) {
                if (userId !== sendBy) {
                    unreadByCounter[userId] = FieldValue.arrayUnion(snapshot.id)
                } else {
                    unreadByCounter[userId] = FieldValue.delete();
                }
            }
            return chat.set({'unreadByCounter': unreadByCounter}, {merge: true})
        }
        return Promise.resolve();
    })


export const sendToDevice = functions.firestore
    .document('chats/{chatId}/messages/{messageId}')
    .onCreate(async (snapshot, context) => {
            const {chatId} = context.params;
            const message = snapshot.data();
            const chatUsersSnapshot = await db.collection('chats').doc(chatId).get();
            const chat = chatUsersSnapshot.data();
            const responses: Promise<admin.messaging.MessagingDevicesResponse>[] = []
        if (chat != undefined && isArray(chat.users))
            for (const userId of chat.users) {
                if (userId != message.sendBy) {
                    const querySnapshot = await db
                        .collection('users')
                        .doc(userId)
                        .collection('tokens')
                        .get();
                    const tokens = querySnapshot.docs.map(snap => snap.id);
                    const payload: admin.messaging.MessagingPayload = {
                        data: {
                                ...new MessageData(message).toMap(),
                                chatId
                            },
                            notification: {
                                title: chat.title[userId],
                                //this merges all new notifications
                                tag: "NEW_MESSAGE",
                                // todo in future provide unread messages counter
                                // "body_loc_key":"notification_new_message",
                                // "body_loc_args":["<<new_message_count>>"],
                                body: message.content,
                                icon: 'new_message_icon',
                                click_action: 'FLUTTER_NOTIFICATION_CLICK'
                            }
                        };
                        responses.push(fcm.sendToDevice(tokens, payload));
                    }
                }
            return Promise.all(responses);
        }
    );

interface Message {
    content: string
    sendBy: string
    timestamp: Timestamp
    type: string
}

class MessageData implements Message {
    toMap() {
        return {
            content: this.content,
            sendBy: this.sendBy,
            timestamp: this.timestamp.toMillis().toString(),
            type: this.type
        }
    }

    constructor(data: DocumentData) {
        this.content = data.content;
        this.sendBy = data.sendBy;
        this.timestamp = data.timestamp;
        this.type = data.type;
    }

    content: string;
    sendBy: string;
    timestamp: FirebaseFirestore.Timestamp;
    type: string;
}