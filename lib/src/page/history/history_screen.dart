import 'dart:async';

import 'package:app_debt_tracker/src/configs/constants/constants.dart';
import 'package:app_debt_tracker/src/configs/widget/text/paragraph.dart';
import 'package:app_debt_tracker/src/resource/firebase/firebase_debt.dart';
import 'package:app_debt_tracker/src/resource/model/debt_model.dart';
import 'package:app_debt_tracker/src/utils/app_fomat_money.dart';
import 'package:app_debt_tracker/src/utils/date_format_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DebtModel> listDebt = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      readDataTodoFirebase();
      Timer.periodic(const Duration(seconds: 2), (Timer t) => setState(() {}));
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> readDataTodoFirebase() async {
    final idUser = FirebaseAuth.instance.currentUser?.uid;
    final data = await FirebaseFirestore.instance
        .collection('debt_AppDebtTracker')
        .where('idUser', isEqualTo: idUser)
        .get();
    if (data.docs.isEmpty) {
      return;
    } else {
      FirebaseFirestore.instance
          .collection('debt_AppDebtTracker')
          .where('idUser', isEqualTo: idUser)
          .orderBy('dateTime', descending: false)
          .snapshots()
          .map((snapshots) => snapshots.docs.map((doc) {
                final data = doc.data();
                return DebtModel.fromJson(data);
              }).toList())
          .listen((data) {
        listDebt = data;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          centerTitle: true,
          title: Paragraph(
            content: 'History',
            style: STYLE_BIG.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
            height: MediaQuery.sizeOf(context).height - 150,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: AppColors.BLACK_200,
                ),
                Visibility(
                  visible: listDebt.isNotEmpty ? true : false,
                  child: Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: listDebt.length,
                      itemBuilder: (context, index) => buildItemToDo(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void doNothing(BuildContext context, String id) async {
    await FireStoreSpending.removeTodoFirebase(id);
    setState(() {});
  }

  Widget buildItemToDo(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 2,
              onPressed: (_) {
                doNothing(context, listDebt[index].idDebt!);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(SizeToPadding.sizeMedium),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(BorderRadiusSize.sizeMedium)),
              color: Colors.grey.withOpacity(0.08)),
          child: Column(
            children: [
              buildMoney(index),
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeVerySmall),
                child: buildInfoCard(
                  title: 'Note:',
                  content: listDebt[index].note,
                ),
              ),
              buildInfoCard(
                title: 'Debtor:',
                content: listDebt[index].nameUserDebt
              ),
              Padding(
                padding: EdgeInsets.only(top: SizeToPadding.sizeVerySmall),
                child: buildInfoCard(
                  iconData: Icons.calendar_month,
                  content: AppDateUtils.formatDateTime(listDebt[index].dateTime)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoney(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: 'Debt money',
          style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width - 200,
          alignment: Alignment.centerRight,
          child: Paragraph(
            content: (listDebt[index].isIOwe ?? false)
                ? '- ${AppCurrencyFormat.formatMoneyD(listDebt[index].debtMoney ?? 0)}'
                : '+ ${AppCurrencyFormat.formatMoneyD(listDebt[index].debtMoney ?? 0)}',
            style: STYLE_MEDIUM.copyWith(
                color: (listDebt[index].isIOwe ?? false)
                    ? AppColors.PRIMARY_RED
                    : AppColors.Green_Money,
                fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard({String? title, String? content, IconData? iconData}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconData != null
            ? Icon(iconData)
            : Paragraph(
                content: title,
                style: STYLE_MEDIUM.copyWith(fontWeight: FontWeight.w600),
              ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeSmall),
          width: MediaQuery.sizeOf(context).width - 150,
          child: Paragraph(
            content: content,
            style: STYLE_MEDIUM.copyWith(),
          ),
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }
}
