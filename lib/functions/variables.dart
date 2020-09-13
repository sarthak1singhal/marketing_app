class Variables {

  static String baseUrl ="http://ec2-13-235-17-220.ap-south-1.compute.amazonaws.com:443/";
  static String ourImage = "http://via.placeholder.com/350x350";



  static String signUp = "signup";
  static String signUp_mail = "signup-mail";
  static String verify_otp = "verify-mail-otp";
  static String signIn = "login";
  static String AllCampaigns = "get_campaigns"; //page
  static String forMeCampaigns = "influencer/getclients";   //page

  static String bid = "influencer/bid"; //
/*
  campaign_key,
  currency (rs for now),
  bid_platform (youtube, instagram or facebook),
  bid_value (numeric value of the bid)
*/


  static String deleteBid = "influencer/del_bid";
  //id (Bid id)

  static String viewAd = "/view_ad";
  //campaign_id

  static String registerInfluencer = "register/influencer/1";
/*
  countries - array
  languages- array
  category, category2(not mandatory), birthdate, region(not mandatory), gender(male, female, all)
*/


  static String registerYoutube = "register/youtube";
  static String registerFacebook = "register/facebook";
  static String registerInstagram = "register/instagram";
  static String getProfile = "profile";
  static String editProfile = "edit-profile";
  static String uploadProfileImg = "uploadProfileImage_app"; //


  static String changePassword = "change-password";




  //These names are used as variables in shared preferences
  static final  String tokenString = "token";
  static final String accessString = "access";
  static final String mailVerifiedString = "mailVerified";
  static final String firstNameString = "firstName";
  static final String lastNameString = "lastName";
  static final String isYoutubeString = "isYoutube";
  static final String isFacebookString = "isFacebook";
  static final String isInstagramString = "isInstagram";
  static final String profileImageString = "profileImg";
  static final  String refreshTokenString = "refreshToken";





  //These are the variables which are used across the app
  static String token = "token";
  static String refreshToken = "refreshToken";
  static String access = "access";
  static String mailVerified = "mailVerified";
  static String profile_image = "";
  static String firstName = "firstName";
  static String lastName = "lastName";
  static int isInstagram = 0;
  static int isFacebook = 0;
  static int isYoutube = 0;







  static final String fontName = "OpenSans";


  static List<String> contentCategories = ["Animals","Art","Beauty","Business","Causes","Comedy","Dance","Education","Entertainment","Family","Fashion","Film","Fitness","Food",
  "Gaming","Investment","Lifestyle","Memes","Music","News","Photography","Politics","Science","Sport","Technology","Travel", "Others"];


  static List<String> languages = ["English", "Hindi", "Marathi", "Tamil", "Telugu", "Bengali", "Gujrati"];
  static List<String> genders = ["Male", "Female", "Prefer not to say","1"];










  static final String connErrorMessage = "Connection Error";




  static final privacyPolicyUrl = "https://google.com";
  static final termsConditionsUrl = "https://google.com";
}