import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textrecogn/models/Card_details.dart';
import 'package:textrecogn/provider/card_provider.dart';
import 'package:textrecogn/widgets/buttons.dart';

class EditDetails extends StatefulWidget {
  final CardDetail? cardDetail;



  const EditDetails({super.key, required this.cardDetail, });

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController =TextEditingController();
  TextEditingController phoneController =TextEditingController();
  TextEditingController emailController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(width/25),
          child: Column(
            children: [
            Form(
            key: _formKey, // Assign the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height/30),
                TextFormField(

                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  name';
                    }
                    return null; // Valid input
                  },
                  controller: nameController..text=widget.cardDetail!.name!,

                ),
                SizedBox(height: height/40),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter your Phone number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  phone number';
                    }
                    return null; // Valid input
                  },
                  controller: phoneController..text=widget.cardDetail!.phoneNumber!,


                ),
                SizedBox(height: height/40),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter  email';
                    }
                    return null; // Valid input
                  },
                  controller: emailController..text=widget.cardDetail!.email!,


                ),
                 SizedBox(height: height/40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    KButton(
                      onPressed: ()async {


                        if (_formKey.currentState?.validate() ?? false) {
                          try{

                          List<CardDetail> updateCardDetails =
                              Provider.of<CardDetailProvider>(context, listen: false).cardDetails;
                          updateCardDetails.removeWhere((element) => element.id==widget.cardDetail!.id);
                          final cardDetails = CardDetail(
                              name: nameController.text.trim(), // Example: Adjust based on actual data
                              phoneNumber: phoneController.text.trim(),
                              email:emailController.text.trim() ?? 'Please provide correct image to extract email correctly ',
                              id:widget.cardDetail!.id
                          );
                          updateCardDetails.add(cardDetails);
                          await Provider.of<CardDetailProvider>(context, listen: false)
                              .saveCardDetails(updateCardDetails);



                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Card details updated successfully'),
                            ),
                          );
                          Navigator.pop(context);}catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Something went wrong... Try again later"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }


                        }
                      },
                      child: const Text('Submit',style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
                    SizedBox(width: width/30,),
                    KButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel',style: TextStyle(
                          color: Colors.white
                      ),),
                    ),
                  ],
                ),
              ],
            ),
          ),


            ],
          ),
        ),
      ),
    );
  }
}
