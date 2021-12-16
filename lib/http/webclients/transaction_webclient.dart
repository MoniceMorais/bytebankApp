import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebclient {

  Future<List<Transaction>> findAll() async {
    final url = Uri.parse(baseUrl);
    final Response response = await client.get(url).timeout(const Duration(seconds: 5));

    return _toTransactions(response);
  }

  Future<Transaction> save(Transaction transaction) async {
    final String transactionJson = jsonEncode(transaction.toJson());
    final url = Uri.parse(baseUrl);
    final Response response = await client.post(url, headers: {
      'Content-type': 'application/json',
      'password': '1000',
    }, body: transactionJson);

    return _toTransaction(response);
  }

  List<Transaction> _toTransactions(Response response) {

    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];
    for (Map<String, dynamic> transactionJson in decodedJson) {
      transactions.add(Transaction.fromJson(transactionJson));
    }
    return transactions;
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> json = jsonDecode(response.body);
    return Transaction.fromJson(json);
  }
  
}