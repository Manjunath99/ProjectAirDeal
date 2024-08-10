import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textrecogn/models/Card_details.dart';
import 'package:textrecogn/pages/edit_card_details.dart';
import 'package:textrecogn/pages/extraxt_text.dart';
import 'package:textrecogn/provider/card_provider.dart';
import 'package:textrecogn/widgets/floatingactionbutton.dart';

// i used a provider state management for the application to run
// using of multiprovider,ChangeNotifierProvider,and consumer
//used google_ml_kit for text recognize


void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CardDetailProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // here i set a custom color for app
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green,
          secondary: Colors.green,
        ),
        fontFamily: 'Georgia',
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cardDetailProvider = Provider.of<CardDetailProvider>(context);
    cardDetailProvider.loadCardDetails();
    // these are the two field which will help application to responsive

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Card Info Extraction")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //here i created some custom widgets to show that i have knowledge about them
          KFloatingActionButton(
            heroTag: 'btn1',
            onPressed: () async {
              //here i used image picker for getting a image from gallery
              try {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final imageFile = File(pickedFile.path);
                  await _extractTextFromImage(context, imageFile);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Something went wrong please try again later'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            icon: Icons.add_circle,
          ),

          SizedBox(
            height: height / 80,
          ),
          KFloatingActionButton(
            heroTag: 'btn2',
            onPressed: () async {
              //this button will automatically deletes the data from app
              await cardDetailProvider.deleteCardDetails();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Card details removed from SharedPreferences'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            icon: Icons.delete,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(width / 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: height / 80),
            //here consumer widget will help update the ui when notifylistener calls in the provider class
            Consumer<CardDetailProvider>(
              builder: (context, provider, child) {
                if (provider.cardDetails.isNotEmpty) {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, i) {
                        return Divider();
                      },
                      itemCount: provider.cardDetails.length,
                      itemBuilder: (context, index) {
                        final card = provider.cardDetails[index];
                        return ListTile(
                          title: Text(
                            "Name : ${card.name ?? ''}",
                            style: TextStyle(fontSize: width / 22),
                          ),
                          subtitle: Text(
                            "Phone : ${card.phoneNumber ?? ''}\nEmail : ${card.email!.toUpperCase().contains('COM') || card.email == 'None' ? card.email! : "${card.email}.com"}",
                            style: TextStyle(
                                fontSize: width / 22, color: Colors.black),
                          ),
                          //this buttomn will help to edit already existing card details in shared preference
                          trailing: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditDetails(
                                              cardDetail: card,
                                            )));
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.black,
                              )),
                        );
                      },
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: width / 15,
                        ),
                      ),
                      Text(
                          'Please select the appropriate image for data extraction using the buttons below.',
                          style: TextStyle(fontSize: width / 26))
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _extractTextFromImage(
      BuildContext context, File imageFile) async {
    try {
      final textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await textRecognizer.processImage(inputImage);
      if(recognizedText.text.isNotEmpty){
      String mailAddress = "None";
      outerLoop:
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            if (element.text.toUpperCase().endsWith('COM') ||
                element.text.contains('@')) {
              mailAddress = element.text;
              break outerLoop;
            }
          }
        }
      }

      _showImageDialog(context, imageFile, recognizedText.text, mailAddress);

      textRecognizer.close();
    }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please use a appropriate image to extract data or Maybe the image is not suitable (Blured)"),
            backgroundColor: Colors.redAccent,
          ),
        );

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong please try again later"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showImageDialog(
      BuildContext context, File imageFile, String text, String mail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.file(
                imageFile,
                fit: BoxFit.fitHeight,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Extract'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ExtractTextPage(text: text, email: mail)));
              },
            ),
          ],
        );
      },
    );
  }
}
