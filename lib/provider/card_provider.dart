import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:textrecogn/models/Card_details.dart';
import 'package:provider/provider.dart';


//here i used provider package for updating the state
class CardDetailProvider extends ChangeNotifier {

  List<CardDetail> _cardDetails = [];

  List<CardDetail> get cardDetails => _cardDetails;

  // for getting all the card details
  Future<void> loadCardDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cardDetailsJson = prefs.getString('card_details');
    if (cardDetailsJson != null) {
      List<dynamic> jsonList = jsonDecode(cardDetailsJson);
      _cardDetails = jsonList.map((jsonItem) => CardDetail.fromJson(jsonItem)).toList();
      notifyListeners();
    }
  }

  // for saving  the card details


  Future<void> saveCardDetails(List<CardDetail> cardDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = cardDetails.map((card) => card.toJson()).toList();
    String cardDetailsJson = jsonEncode(jsonList);
    await prefs.setString('card_details', cardDetailsJson);
    _cardDetails = cardDetails;
    notifyListeners();
  }
  // for deleting all the card details


  Future<void> deleteCardDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('card_details');
    _cardDetails = [];
    notifyListeners();
  }
}


