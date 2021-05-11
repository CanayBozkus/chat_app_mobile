extension StringExtension on String{
  String getCleanPhoneNumber(){
    String phone =  this.replaceAll(RegExp(r'[A-Za-z\*\(\)\s#\.,\+\/\;-]'), '');
    phone = phone[0] == '0' ? phone.substring(1) : phone;
    return phone;
  }
}