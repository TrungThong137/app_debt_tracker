class DebtModel {
  DebtModel({
    this.idUser,
    this.note,
    this.dateTime,
    this.idDebt,
    this.debtMoney,
    this.nameUserDebt,
    this.isCustomerOwe,
    this.isIOwe,
  });

  final String? idUser;
  final String? note;
  final String? dateTime;
  final String? nameUserDebt;
  final String? idDebt;
  final double? debtMoney;
  final bool? isIOwe;
  final bool? isCustomerOwe;

  static DebtModel fromJson(Map<String, dynamic> json) => DebtModel(
      idUser: json['idUser'],
      note: json['note'],
      dateTime: json['dateTime'],
      idDebt: json['idDebt'],
      debtMoney: json['debtMoney'],
      nameUserDebt: json['nameUserDebt'],
      isCustomerOwe: json['isCustomerOwe'],
      isIOwe: json['isIOwe'],
    );

  Map<String, dynamic> toJson() => {
      // 'isCheckBox': isCheckBox,
    };
}
