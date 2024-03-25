import 'package:app_debt_tracker/src/resource/model/debt_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreSpending {
  static Future<void> createSpendingFirebase(DebtModel debtModel) async {
    final doc = FirebaseFirestore.instance.collection('debt_AppDebtTracker');
    await doc.add({
      'idUser': debtModel.idUser,
    }).then((value) => FirebaseFirestore.instance.collection('debt_AppDebtTracker').doc(value.id)
      .set({
        'idUser': debtModel.idUser,
        'dateTime': debtModel.dateTime,
        'idDebt': value.id,
        'note': debtModel.note,
        'debtMoney': debtModel.debtMoney,
        'nameUserDebt': debtModel.nameUserDebt,
        'isCustomerOwe': debtModel.isCustomerOwe,
        'isIOwe': debtModel.isIOwe,
      })
    );
  }

  static Future<void> removeTodoFirebase(String id) async{
    final bodyIndex= FirebaseFirestore.instance.collection('debt_AppDebtTracker');
    await bodyIndex.doc(id).delete();
  }

  static Future<void> removeAllTodoFirebase(String id) async{
    final bodyIndex= FirebaseFirestore.instance.collection('debt_AppDebtTracker');
    final userSnapshot= await bodyIndex.where('idUser', isEqualTo: id).get();
    for (DocumentSnapshot doc in userSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<void> updateTodoFirebase(DebtModel todo)async{
     await FirebaseFirestore.instance.collection('debt_AppDebtTracker')
        .doc(todo.idDebt)
        .update(
          todo.toJson()
        );
  }
}
