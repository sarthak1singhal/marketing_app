class Variables {

  static String baseUrl ="http://ec2-13-235-17-220.ap-south-1.compute.amazonaws.com:3000/";



  static String signUp = "signup";
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





  //These names are used as variables in shared preferences
  static String tokenString = "token";
  static String accessString = "access";
  static String mailVerifiedString = "mailVerified";
  static String firstNameString = "firstName";
  static String lastNameString = "lastName";
  static String isYoutubeString = "isYoutube";
  static String isFacebookString = "isFacebook";
  static String isInstagramString = "isInstagram";





  //These are the variables which are used across the app
  static String token = "token";
  static String access = "access";
  static String mailVerified = "mailVerified";
  static String firstName = "firstName";
  static String lastName = "lastName";
  static int isInstagram = 0;
  static int isFacebook = 0;
  static int isYoutube = 0;






}