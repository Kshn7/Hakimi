import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SenaraiPelanggan extends StatefulWidget {
  const SenaraiPelanggan({super.key});

  @override
  State<SenaraiPelanggan> createState() => _SenaraiPelangganState();
}

class _SenaraiPelangganState extends State<SenaraiPelanggan> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('customers')
                .orderBy('name'.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return const Text("No data. Add new customer detail");
              }
                  return SizedBox(
                      width: MediaQuery.of(context).size.width*0.2, // **Limits width to 25% of screen width**
                      height: MediaQuery.of(context).size.height*0.7, // **Limits width to 70% of screen width**
                    child: Flexible(
                      child: ListView.builder(

                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data!.size,
                        shrinkWrap: false,
                        physics: const AlwaysScrollableScrollPhysics(), // Smooth scrolling
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(data['name']),
                              subtitle: Text(data['phoneNumber']),
                              trailing: IconButton(
                                  onPressed: () async {
                                    //Delete customer from Firestore
                                    bool? confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Delete Customer"),
                                        content: const Text("Are you sure you want to delete this customer?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false), // Cancel
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true), // Confirm delete
                                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmDelete == true) {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection('customers')
                                          .doc(data.id)
                                          .delete();
                                    }

                                  },
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                );
            }),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () async {
                var name;
                var phoneNumber;
                var uid = Uuid().v4();
                await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Add customer detail'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                onChanged: (v) {
                                  name = v;
                                },
                              ),
                              TextFormField(
                                onChanged: (v) {
                                  phoneNumber = v;
                                },
                              )
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('customers')
                                      .doc(uid)
                                      .set({
                                    "uid": uid,
                                    'name': name,
                                    "phoneNumber": phoneNumber
                                  }, SetOptions(merge: true));
                                  Navigator.pop(context);
                                },
                                child: Text("Submit"))
                          ],
                        ));
              },
              child: const Text('Add new customer')),
        )
      ],
    ));
  }
}
