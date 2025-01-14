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
              return snapshot.data == null || snapshot.data!.docs.isEmpty
                  ? const Text("No data. Add new customer detail")
                  : Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data!.size,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(data['name']),
                              subtitle: Text(data['phoneNumber']),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  )),
                            ),
                          );
                        },
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
