import 'dart:async';

import 'package:app_debt_tracker/src/configs/constants/constants.dart';
import 'package:app_debt_tracker/src/configs/widget/form_field/app_form_field.dart';
import 'package:app_debt_tracker/src/configs/widget/text/paragraph.dart';
import 'package:app_debt_tracker/src/utils/app_valid.dart';
import 'package:app_debt_tracker/src/utils/date_format_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configs/widget/button/button.dart';
import '../../configs/widget/loading/loading_diaglog.dart';
import '../../resource/firebase/firebase_debt.dart';
import '../../resource/model/debt_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectButton = 0;

  late TextEditingController noteController;
  late TextEditingController moneyController;
  late TextEditingController debtorController;
  late DateTime dateTime;

  String? messageMoney;
  String? messageDebtor;

  bool isEnableButton = false;

  List<String> listButtonSelect = [
    'Me',
    'Customer',
  ];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      noteController = TextEditingController();
      moneyController = TextEditingController();
      debtorController= TextEditingController();
      dateTime = DateTime.now();
      timer = Timer.periodic(
          const Duration(seconds: 2), (Timer t) => setState(() {}));
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          leading: null,
          centerTitle: true,
          title: Paragraph(
            content: 'Home',
            style: STYLE_LARGE_BIG.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeToPadding.sizeMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: AppColors.BLACK_200,
                ),
                buildFormInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleChooseDebtor(){
    return Paragraph(
      content: 'Choose the debtor',
      style: STYLE_SMALL.copyWith(
        fontWeight: FontWeight.w600
      ),
    );
  }

  Widget buildButtonChooseDebtor() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeToPadding.sizeSmall),
      child: Center(
        child: CupertinoSlidingSegmentedControl(
          groupValue: selectButton,
          thumbColor: AppColors.PRIMARY_MAROON,
          children: <int, Widget>{
            for (int i = 0; i < listButtonSelect.length; i++)
              i: Container(
                alignment: Alignment.center,
                width: 80,
                height: 40,
                child: Paragraph(
                  content: listButtonSelect[i],
                  style: STYLE_MEDIUM.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selectButton == i
                        ? AppColors.COLOR_WHITE
                        : AppColors.BLACK_500,
                  ),
                ),
              )
          },
          onValueChanged: (i) async{
            await onChangeButtonSelect(i ?? 0);
          },
        ),
      ),
    );
  }

  Widget buildFormInput() {
    return Container(
      height: MediaQuery.sizeOf(context).height-170,
      margin: EdgeInsets.only(
        top: SizeToPadding.sizeMedium,
      ),
      padding: EdgeInsets.only(
        bottom: SizeToPadding.sizeVeryBig,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleChooseDebtor(),
          buildButtonChooseDebtor(),
          buildFieldDebtor(),
          buildFieldMoney(),
          buildFieldNoteCard(),
          buildChooseDate(),
          const Expanded(child: SizedBox()),
          buildButtonCard(),
        ],
      ),
    );
  }

  Widget buildFieldDebtor(){
    return AppFormField(
      validator: messageDebtor,
      textEditingController: debtorController,
      keyboardType: TextInputType.text,
      labelText: 'Debtor',
      hintText: 'Enter Debtor',
      onChanged: (value) async {
        if(selectButton==1){
          await validDebtor(value);
        }
        await onEnableButton();
      },
    );
  }

  Widget buildFieldMoney() {
    return AppFormField(
      validator: messageMoney,
      textEditingController: moneyController,
      keyboardType: TextInputType.number,
      labelText: selectButton == 0 ? 'Money I owe' : 'Money owed by customers',
      hintText: 'Enter money',
      onChanged: (value) async {
        await validMoney(value);
        await onEnableButton();
      },
    );
  }

  Widget buildFieldNoteCard() {
    return AppFormField(
      textEditingController: noteController,
      labelText: 'Note',
      hintText: 'Enter Note',
      maxLines: 3,
      onChanged: (value) => onEnableButton(),
    );
  }

  Widget buildChooseDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Paragraph(
          content: 'Chọn ngày: ',
          style: STYLE_LARGE.copyWith(
            fontWeight: FontWeight.w600
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Paragraph(
              content: AppDateUtils.formatDateTime(dateTime),
              style: STYLE_LARGE.copyWith(
                fontWeight: FontWeight.w600
              ),
            ),
            IconButton(
              onPressed: (){
                onShowDatePicker();
              },
              icon: const Icon(Icons.calendar_month, size: 40,)
            )
          ],
        )
      ],
    );
  }

  Widget buildButtonCard() {
    return AppButton(
      enableButton: isEnableButton,
      content: 'Save',
      onTap: () => onSave(),
    );
  }

  void onSave() {
    LoadingDialog.showLoadingDialog(context);
    FireStoreSpending.createSpendingFirebase(DebtModel(
      dateTime: dateTime.toString(),
      idUser: FirebaseAuth.instance.currentUser?.uid,
      note: noteController.text.trim(),
      debtMoney: double.parse(moneyController.text.trim()),
      isCustomerOwe: selectButton==0? false: true,
      isIOwe: selectButton==0? true: false,
      nameUserDebt: (selectButton==0 && debtorController.text.trim()=='')
        ? 'Me': debtorController.text.trim()
    )).then((value) async {
      LoadingDialog.hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Paragraph(
        content: 'Add Success',
      )));
      await clearData();
    }).catchError((onError) {
      LoadingDialog.hideLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Paragraph(
        content: '$onError',
      )));
    });
  }

  Future<void> validDebtor(String? value) async {
    final result = AppValid.validateName(value);
    if (result != null) {
      messageDebtor = result;
    } else {
      messageDebtor = null;
    }
    setState(() {});
  }

  Future<void> validMoney(String? value) async {
    final result = AppValid.validMoney(value);
    if (result != null) {
      messageMoney = result;
    } else {
      messageMoney = null;
    }
    setState(() {});
  }

  Future<void> onEnableButton() async {
    if(selectButton==1){
      if (moneyController.text == '' || messageMoney != null 
      || debtorController.text=='' || messageDebtor!=null) {
        isEnableButton = false;
      } else {
        isEnableButton = true;
      }
    }else{
      if (moneyController.text == '' || messageMoney != null) {
        isEnableButton = false;
      } else {
        isEnableButton = true;
      }
    }
    setState(() {});
  }

  Future<void> clearData() async {
    noteController.text = '';
    moneyController.text = '';
    debtorController.text='';
    dateTime=DateTime.now();
    await onEnableButton();
    setState(() {});
  }

  Future<void> onChangeButtonSelect(int i) async{
    selectButton = i;
    debtorController.clear();
    messageDebtor=null;
    await onEnableButton();
    setState(() {});
  }

  Future<void> onShowDatePicker() async{
    final DateTime? picked = await showDatePicker(
      context: context, 
      firstDate: DateTime(1970), 
      lastDate: DateTime(2100),
      initialDate: dateTime,
    );
    if(picked!=null && picked != dateTime){
      dateTime=picked;
      setState(() { });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
