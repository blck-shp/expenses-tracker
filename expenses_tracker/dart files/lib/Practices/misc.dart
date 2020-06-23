// ========================= Generate hash ===========================

  // String generateMd5(String input){
  //   return md5.convert(utf8.encode(input)).toString();
  // }


// bool email = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_controller2.text);
// print('The value of email is $email');
// if(email == false){
//   showDialog(
//     context: context,
//     builder: (_) => ErrorMessage(header: "Error" , text: "Invalid email address. Please try again."),                        
//   );                              
// }else if(_controller3.text != _controller4.text){
//   showDialog(
//     context: context,
//     builder: (_) => ErrorMessage(header: "Error" , text: "Passwords don't match. Please try again."),                        
//   );
// }else{
//   print('hehehehe');

//   bool flag = false;
//   int number;

//   do{
//     Random value = new Random();
//     number = value.nextInt(1000000);

//     bool loop = false;

//     for(var i = 0 ; i < numbers.length; i++){
//       if(numbers[i] == number){
//         loop = true;
//         break;
//       }
//     }

//     if(loop == false){
//       flag = true;
//     }

//   }while(flag == false);

//   if(flag == true){
//     print('The number is $number');

//     numbers.add(number);

//     var hash = generateMd5(number.toString());

//     for(var i = 0; i < numbers.length; i++){
//       print('The array of number is ${numbers[i]}');
//     }
//     createAccount(_controller1.text , _controller2.text , _controller3.text , hash);
//   }
// }



// class SampleData{
//   int id;
//   String name;
//   String icon;

//   SampleData({this.id, this.name , this.icon});
// }