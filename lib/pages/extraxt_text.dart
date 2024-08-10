import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textrecogn/models/Card_details.dart';
import 'package:textrecogn/provider/card_provider.dart';
import 'package:textrecogn/widgets/buttons.dart';
import 'package:uuid/uuid.dart';
//
//this page will help in edit the extracted text and double checking the text

class ExtractTextPage extends StatefulWidget {
  final String? text;
  final String? email;

  const ExtractTextPage({super.key, required this.text, required this.email});

  @override
  State<ExtractTextPage> createState() => _ExtractTextPageState();
}

class _ExtractTextPageState extends State<ExtractTextPage> {
  TextEditingController textEditingController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    // these are the two field which will help application to responsive

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(width/25),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 0,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding:  EdgeInsets.all(width/30),
                    child: TextFormField(
                      controller:textEditingController..text=widget.text ??'' ,
                      maxLines: 8,
                      decoration:  const InputDecoration(
                          hintText: "Enter your text here",

                        border: OutlineInputBorder(

                        ),
                      ),
                    ),
                  )
              ),
               Padding(
                padding: EdgeInsets.symmetric(horizontal:width/30,vertical: height/50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('\n=> Please double check the data which is above area and correct it if you need any changes.\n'
                    ,style: TextStyle(
                        fontSize: width/30
                      ),),
                    Text('=> Remove unnecessary character extracted from image.',
                      style: TextStyle(
                          fontSize: width/30
                      ),),

                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KButton(
                    onPressed: () async {
                      try{
                      await _processExtractedText( context,  textEditingController.text.trim() ?? '');
                      Navigator.pop(context);}catch(e){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Something went wrong... Try again later"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }

                    },
                    child: const Text('Save',style:TextStyle(
                        color: Colors.white
                    )),
                  ),
                  SizedBox(width: width/30,),
                  KButton(
                    onPressed: () async {
                      Navigator.pop(context);

                    },
                    child: const Text('Cancel',style: TextStyle(
                      color: Colors.white
                    ),),
                  ),



                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processExtractedText(BuildContext context, String text) async {
    final nameRegex =
    RegExp(r'\b[A-Z][a-z]*\s[A-Z][a-z]*\b', caseSensitive: false

    );

    final phoneRegex =
    RegExp(r"(\+?\d{1,4}[\s-]?)?(\(?\d{3}\)?[\s-]?)?\d{3}[\s-]?\d{4}");



    var uuid = const Uuid();

    final cardDetails = CardDetail(
      name: nameRegex
          .firstMatch(text)
          ?.group(0)!, // Example: Adjust based on actual data
      phoneNumber: phoneRegex.firstMatch(text)?.group(0),
      email:widget.email ?? 'Please provide correct image to extract email correctly ',
      id:uuid.v4()
    );
    List<CardDetail> updateCardDetails =
        Provider.of<CardDetailProvider>(context, listen: false).cardDetails;

    updateCardDetails.add(cardDetails);
    await Provider.of<CardDetailProvider>(context, listen: false)
        .saveCardDetails(updateCardDetails);
  }
}
