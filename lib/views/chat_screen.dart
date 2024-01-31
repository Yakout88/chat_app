import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/views/sign_view.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:chat_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.email});
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController messageField = TextEditingController();
  CollectionReference messageCollection =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  Stream<QuerySnapshot> messages = FirebaseFirestore.instance
      .collection(kMessagesCollection)
      .orderBy("createdTime", descending: true)
      .snapshots();
  final ScrollController controller = ScrollController();
  final String email;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.orange, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(30, 237, 229, 229),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignView(),
                    ),
                    (route) => false);
              },
            )
          ],
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat,
                size: 40,
                weight: 22,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Chat",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: messages,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: controller,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return email == snapshot.data!.docs[index]["email"]
                            ? ChatBuble(
                                messages: MessageModel.fromJson(
                                    snapshot.data!.docs[index]),
                              )
                            : ChatBubleFromFriend(
                                messages: MessageModel.fromJson(
                                  snapshot.data!.docs[index],
                                ),
                              );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: messageField,
                            onSubmitted: (value) {
                              messageCollection.add({
                                "messages": value,
                                "createdTime": DateTime.now(),
                                "email": email
                              });
                              messageField.clear();
                              controller.animateTo(0,
                                  duration: const Duration(seconds: 3),
                                  curve: Curves.linear);
                            },
                            decoration: InputDecoration(
                              hintText: "send a message",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              // border: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.white),
                              //   borderRadius: BorderRadius.circular(25),
                              // ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            onPressed: () {
                              messageCollection.add({
                                "messages": messageField.text,
                                "createdTime": DateTime.now(),
                                "email": email
                              });

                            },
                            icon: const Icon(Icons.send),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return const Text("data");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
