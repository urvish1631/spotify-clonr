// Last Year
const int lastYear = 50;

// Debounce timer
const Duration debounceTimer = Duration(milliseconds: 500);

//AppBar size
const double appBarSize = 100.0;

// Image Picked Quality
const int imageQuality = 80;

// Regex Pattern
const String validEmailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const String validPasswordRegex =
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~%]).{7,32}$';
const String validMobileRegex = r'(^(?:[+0]9)?[0-9]{10,12}$)';

//Locale languageCode
const String en = "en";
const String english = "english";
const String arabic = "arabic";
const String ar = "ar";
const List<double> audioSpeedRates = [0.25, 0.5, 0.75, 1, 1.5, 1.75, 2];

const String profileImage = 'image';
const String userImage = 'user-image';
const String article = 'article';
const String comment = 'comment';
const String recordedArticle = 'record';
const String writtenArticle = 'write';
const String creator = 'creator';
const String user = 'user';
