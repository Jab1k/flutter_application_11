import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Dars extends StatefulWidget {
  const Dars({super.key});

  @override
  State<Dars> createState() => _DarsState();
}

class _DarsState extends State<Dars> {
  bool isloading = true;
  dynamic data;

  Future<void> getinfomation() async {
    isloading = true;
    setState(() {});
    final url =
        Uri.parse('http://universities.hipolabs.com/search?country=Uzbekistan');
    final res = await http.get(url);
    data = jsonDecode(res.body);
    isloading = false;
    setState(() {});
    print(data[0]['name']);
  }

  @override
  void initState() {
    getinfomation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.lightBlue),
                    child: Column(
                      children: [
                        Text(
                          data[index]['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextButton(
                            onPressed: () async {
                              final launchUri = Uri.parse(
                                  data[index]['web_pages']?[0] ?? "0");
                              await url_launcher.launchUrl(launchUri);
                            },
                            child: Text(
                              data[index]['web_pages']?[0] ?? '',
                              style: TextStyle(color: Colors.white),
                            )),
                        const SizedBox(
                          height: 32,
                        ),
                        TextButton(
                            onPressed: () async {
                              final Uri launchUri =
                                  Uri(scheme: 'sms', path: '+998336088666');
                              await url_launcher.launchUrl(launchUri);
                            },
                            child: Text(
                              'Number',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  );
                },
              ));
  }
}
