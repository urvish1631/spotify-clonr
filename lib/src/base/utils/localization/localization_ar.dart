import 'localization.dart';

class LocalizationAR implements Localization {
  @override
  String get appName => "صوت";

  @override
  String get ok => "موافق";

  @override
  String get cancel => "إلغاء";

  @override
  String get alertPermissionNotRestricted =>
      "يرجى منح الإذن من الإعدادات للوصول إلى هذه الميزة";

  @override
  String get alertMicrophonePermission =>
      "يرجى منح الإذن للميكروفون من الإعدادات للوصول إلى ميزة التسجيل هذه";

  @override
  String get alertPhotosPermission =>
      "يرجى منح الإذن للصور من الإعدادات لتحميل صورة ملفك الشخصي";

  @override
  String get alertCameraPermission =>
      "يرجى منح الإذن للكاميرا من الإعدادات لتحميل صورة ملفك الشخصي";

  @override
  String get internetNotConnected =>
      "لا يوجد اتصال بالإنترنت. يرجى التحقق من اتصالك بالإنترنت";

  @override
  String get poorInternetConnection =>
      "اتصال إنترنت ضعيف. يرجى التحقق من اتصالك بالإنترنت";

  @override
  String get delete => "حذف";

  @override
  String get edit => "تعديل";

  @override
  String get done => "تم";

  @override
  String get cameraTitle => "الكاميرا";

  @override
  String get galleryTitle => "المعرض";

  @override
  String get no => "لا";

  @override
  String get yes => "نعم";

  @override
  String get logout => "تسجيل الخروج";

  @override
  String get save => "حفظ";

  @override
  String get search => "بحث";

  @override
  String get submit => "إرسال";

  @override
  String get getStarted => "ابدأ";

  @override
  String get podcastForEveryone => "بودكاست للجميع.";

  @override
  String get otp => "رمز التحقق";

  @override
  String get resendOtp => "إعادة إرسال رمز التحقق؟";

// Auth Strings
  @override
  String get phoneNumber => "هاتف (اختياري)";

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get haveAccount => ' هل لديك حساب؟';

  @override
  String get register => "تسجيل";

  @override
  String get supportText => 'إذا كنت بحاجة إلى أي دعم ';

  @override
  String get clickHere => "انقر هنا";

  @override
  String get forgotPassword => "هل نسيت كلمة المرور؟";

  @override
  String get forgotPasswordHeader => "نسيت كلمة المرور";

  @override
  String get resetPassword => "إعادة تعيين كلمة المرور";

  @override
  String get updatePassword => "تطوير كلمة السر";

  @override
  String get oldPassword => "كلمة المرور القديمة";

  @override
  String get password => "كلمة المرور";

  @override
  String get confirmPassword => "تأكيد كلمة المرور";

  @override
  String get verificationText =>
      'لقد تلقيت رمز التحقق في عنوان بريدك الإلكتروني المسجل';

  @override
  String get email => "البريد الإلكتروني";

  @override
  String get msgEmailEmpty => "البريد الإلكتروني فارغ";

  @override
  String get msgEmailInvalid => "البريد الإلكتروني غير صالح";

  @override
  String get welcomeText =>
      "مرحبًا بك في سادة. منصة لصنع ومشاركة قصص صوتية مؤثرة في مدة 5 دقائق فقط. اطلق العنان لإبداعك، وصل إلى جمهورك، ودع صوتك يُسمع.";

  @override
  String get msgPhoneEmpty => "رقم الجوال فارغ";

  @override
  String get msgPhoneInvalid => "رقم الجوال غير صالح";

  @override
  String get msgVerificationCodeEmpty => "الرجاء إدخال رمز التحقق";

  @override
  String get msgVerificationCodeInvalid => "رمز التحقق غير صالح";

  @override
  String get msgPasswordEmpty => "كلمة المرور فارغة";

  @override
  String get msgNameEmpty => "الاسم فارغ";

  @override
  String get msgConfirmPasswordEmpty => "تأكيد كلمة المرور فارغ";

  @override
  String get msgNoArticlesInPlaylist =>
      "لم يتم إضافة مقالات في قائمة التشغيل هذه";

  @override
  String get msgPasswordNotMatch => "كلمة المرور غير متطابقة";

  @override
  String get msgPasswordError =>
      "يجب أن تكون كلمة المرور على الأقل 8 أحرف وتحتوي على حرف كبير واحد وحرف رقمي واحد على الأقل.";

  @override
  String get login => "تسجيل الدخول";

//Home screen strings
  @override
  String get home => "الرئيسية";

  @override
  String get recent => "مؤخرًا";

  @override
  String get playList => "قائمة التشغيل";

  @override
  String get profile => "الملف الشخصي";

  @override
  String get recentlyPlayed => "تم تشغيلها مؤخرًا";

  @override
  String get artists => "الفنانين";

  @override
  String get articles => "مقالات";

  @override
  String get category => "الفئة";

  @override
  String get recommended => "التوصيات";

  @override
  String get mostlyPlayed => "الأكثر تشغيلًا";

  @override
  String get creator => "المبدع";

  @override
  String get pause => "يوقف";

  @override
  String get comments => "تعليقات";

  @override
  String get create => "إنشاء";

  @override
  String get playListDeleteText =>
      "هل أنت متأكد من أنك تريد حذف قائمة التشغيل هذه؟";

  @override
  String get selectRole => "اختر الدور";

  @override
  String get user => "المستخدم";

  @override
  String get continueText => "متابعة";

  @override
  String get nowPlaying => "الآن يعمل";

  @override
  String get language => "اللغة";

  @override
  String get editProfile => "تعديل الملف الشخصي";

  @override
  String get editArticle => "تحرير المقال";

  @override
  String get deleteArticle => "هل أنت متأكد أنك تريد حذف هذه المقالة؟";

  @override
  String get settings => "الإعدادات";

  @override
  String get playlistName => "اسم قائمة التشغيل";

  @override
  String get logoutText => "هل تريد بالتأكيد تسجيل الخروج؟";

  @override
  String get termsCondition => "الشروط والأحكام";

  @override
  String get followers => "متابعون";

  @override
  String get follow => "متابعة";

  @override
  String get following => "يتابع";

  @override
  String get english => "English";

  @override
  String get arabic => "عربي";

  @override
  String get record => "سِجِلّ";

  @override
  String get remove => "يزيل";

  @override
  String get myArticles => "مقالاتي";

  @override
  String get name => "اسم";

  @override
  String get update => "تحديث";

  @override
  String get msgWrittenArticleEmpty => 'من فضلك اكتب شيئا عن مقالتك';

  @override
  String get noCreatedArticles => "لم تقم بإنشاء أي مقال حتى الآن";

  @override
  String get msgArticleNameEmpty => "اسم المقال فارغ";

  @override
  String get msgCommentsEmpty => "لم يكن هذا المقال أي تعليقات";

  @override
  String get msgPlaylistNameEmpty => "اسم قائمة التشغيل فارغ";

  @override
  String get noArticleCategory => "لا توجد مقالات في هذه الفئة";

  @override
  String get noArtistArticle => "لم ينشئ الفنان أي مقال حتى الآن";

  @override
  String get publish => "نشر المقال";

  @override
  String get article => "شرط";

  @override
  String get dataNotFound => "لم يتم العثور على بيانات";

  @override
  String get addArticle => "أضف المقال";

  @override
  String get start => "يبدأ";

  @override
  String get stop => "قف";

  @override
  String get writeArticleHere => "اكتب مقالتك هنا";

  @override
  String get write => "يكتب";

  @override
  String get uploadPhoto => "حمل الصورة";

  @override
  String get loginSuccessfully => "تم تسجيل الدخول بنجاح";

  @override
  String get searchArticle => "بحث المادة ، الفنانين ، الفئة";

  @override
  String get selectCategory => "اختر الفئة";

  @override
  String get addToPlaylist => "أضف إلى قائمة التشغيل";

  @override
  String get selectLanguage => "اختار اللغة";

  @override
  String get selectImageMessage => "الرجاء تحديد صورة";

  @override
  String get noPlaylistMessage =>
      "لا توجد قائمة تشغيل الآن الرجاء إنشاء قائمة تشغيل جديدة";

  @override
  String get resume => "سيرة ذاتية";

  @override
  String get createPlaylist => "إنشاء قائمة التشغيل";

  @override
  String get selectOption => "حدد الخيار";

  @override
  String get privacyPolicy => "سياسة الخصوصية";

  @override
  String get noRecentPlayArticle => "أنت لم تلعب أي مقال حتى الآن";

  @override
  String get msgDeleteAccount =>
      "هل انت متأكد انك تريد حذف حسابك؟ بمجرد حذف الحساب لن يتم استرداد أي معلومات.";

  @override
  String get deleteAccount => "حذف الحساب";
}
