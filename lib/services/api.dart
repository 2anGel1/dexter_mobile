const online = "https://backend-dexter.invest-ci.com";
const local = "http://192.168.1.5:8000";

const String url = online;
const String imageUrl = "$url/public/public";
const String urlApi = "$url/api";

class Links {
  //auth
  static const String resetpassword = '$urlApi/password';
  static const String logout = '$urlApi/logout';
  static const String signup = '$urlApi/users';
  static const String login = '$urlApi/login';

  //get
  static const String getuserpaymentsencours = '$urlApi/getOwnerEnCours';
  static const String someresidences = '$urlApi/getUnreserveResidences';
  static const String getuserpayments = '$urlApi/getOwnerPayments';
  static const String getuserproperties = '$urlApi/proprietaire';
  static const String getmunicipalities = '$urlApi/municipalite';
  static const String getuserprograms = '$urlApi/clientvs';
  static const String getcategories = '$urlApi/categories';
  static const String getcomodities = '$urlApi/comodites';
  static const String getproperty = '$urlApi/proprietes';
  static const String getuserbyid = '$urlApi/users';
  static const String getcities = '$urlApi/cities';
  static const String gettypes = '$urlApi/types';
  static const String search = '$urlApi/search';

  //post
  static const String requestupdateproperty = '$urlApi/ProprietyModify';
  static const String updatepropertystatus = '$urlApi/updateStatus';
  static const String validatepayment = '$urlApi/payementValider';
  static const String updateproperty = '$urlApi/updatePropriete';
  static const String makereservation = '$urlApi/reservations';
  static const String checkpayment = '$urlApi/payment/notify';
  static const String createproperty = '$urlApi/proprietes';
  static const String initpayment = '$urlApi/start-payment';
  static const String makerequest = '$urlApi/visites';
  static const String makevisite = '$urlApi/visites';
  static const String addimages = '$urlApi/photos';

  //put
  static const String updateuserpassword = '$urlApi/modifyPassword';
  static const String cancelreservation = '$urlApi/reservations';
  static const String cancelvisit = '$urlApi/updateStatusV';
  static const String updateuser = '$urlApi/updateusers';

  //delete
  static const String removeimage = '$urlApi/photos';
  static const String deletereservation = '$urlApi/reservations';
  static const String deletevisite = '$urlApi/visites';

  //notifications
  static const String notifications = '$urlApi/notifications';


  // other
  static String policy = "https://lce-ci.com/dexter-policies.html";
  static String cinetpayapikey = "971408392655f1a56284615.67795424";
  static String cinetpaysiteid = "5866028";
}
