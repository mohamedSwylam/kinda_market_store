abstract class StoreAppStates {}

class StoreInitialState extends StoreAppStates {}

class StoreChangeBottomNavState extends StoreAppStates {}

class StoreChangeDropdownState extends StoreAppStates {}

class StoreAppBottomBarChangeState extends StoreAppStates {}

class StoreAppBottomBarSearchState extends StoreAppStates {}

class StoreAppBottomBarUserState extends StoreAppStates {}

class StoreAppBottomBarHomeState extends StoreAppStates {}

class StoreAppBottomBarCartState extends StoreAppStates {}

class StoreAppChangeThemeModeState extends StoreAppStates {}

class StoreAppChangeLanguageState extends StoreAppStates {}

class StoreAppGetLanguageState extends StoreAppStates {}

class StoreAppAddToCartSuccessState extends StoreAppStates {}

class StoreAppReduceCartItemByOneSuccessState extends StoreAppStates {}

class StoreAppClearCartSuccessState extends StoreAppStates {}

class StoreAppRemoveCartItemSuccessState extends StoreAppStates {}

class StoreAppClearWishListSuccessState extends StoreAppStates {}

class StoreAppRemoveWishListItemSuccessState extends StoreAppStates {}

class StoreAppAddItemToWishListSuccessState extends StoreAppStates {}

class StoreAppSearchQuerySuccessState extends StoreAppStates {}

class GetUserLoadingStates extends StoreAppStates {}

class GetUserSuccessStates extends StoreAppStates {}

class GetUserErrorStates extends StoreAppStates {}

class GetProductLoadingStates extends StoreAppStates {}

class GetProductSuccessStates extends StoreAppStates {}

class GetProductErrorStates extends StoreAppStates {}

class SignOutSuccessState extends StoreAppStates {}

//brandScreen
class SelectAddidasBrandState extends StoreAppStates {}

class SelectAppleBrandState extends StoreAppStates {}

class SelectDellBrandState extends StoreAppStates {}

class SelectHmBrandState extends StoreAppStates {}

class SelectNikeBrandState extends StoreAppStates {}

class SelectSamsungBrandState extends StoreAppStates {}

class SelectHuaweiBrandState extends StoreAppStates {}

class SelectAllBrandState extends StoreAppStates {}

class ChangeIndexState extends StoreAppStates {}

///////////uploadOrder
class CreateOrderSuccessState extends StoreAppStates {}

class CreateOrderErrorState extends StoreAppStates {}

class OnTapBrandItemState extends StoreAppStates {}

class OnTapBrandItemStatee extends StoreAppStates {}

////////////get order
class GetOrdersLoadingStates extends StoreAppStates {}

class GetOrdersSuccessStates extends StoreAppStates {}

class GetOrdersErrorStates extends StoreAppStates {}

//////////////////get banner
class GetBannersLoadingStates extends StoreAppStates {}

class GetBannersSuccessStates extends StoreAppStates {}

class GetBannersErrorStates extends StoreAppStates {
  final String error;

  GetBannersErrorStates(this.error);
}

/////////////////////////faceBook
class LoginWithFacebookLoadingStates extends StoreAppStates {}

class LoginWithFacebookSuccessStates extends StoreAppStates {}

////////////////
class GetCartsLoadingStates extends StoreAppStates {}

class GetCartsSuccessStates extends StoreAppStates {}

class GetCartsErrorStates extends StoreAppStates {
  final String error;

  GetCartsErrorStates(this.error);
}
/////////////////loginScreen

class LoginInitialState extends StoreAppStates {}

class LoginLoadingState extends StoreAppStates {}

class LoginSuccessState extends StoreAppStates {
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends StoreAppStates {
  final String error;

  LoginErrorState(this.error);
}

class ForgetPasswordLoadingState extends StoreAppStates {}

class ForgetPasswordSuccessState extends StoreAppStates {}

class ForgetPasswordErrorState extends StoreAppStates {
  final String error;

  ForgetPasswordErrorState(this.error);
}

class LoginAnonymousLoadingState extends StoreAppStates {}

class LoginAnonymousSuccessState extends StoreAppStates {}

class LoginAnonymousErrorState extends StoreAppStates {
  final String error;

  LoginAnonymousErrorState(this.error);
}

class LoginWithFacebookLoadingState extends StoreAppStates {}

class LoginWithFacebookSuccessState extends StoreAppStates {}

class LoginWithFacebookErrorState extends StoreAppStates {
  final String error;

  LoginWithFacebookErrorState(this.error);
}

class LoginPasswordVisibilityState extends StoreAppStates {}

class LoginState extends StoreAppStates {}

class GetUserLoginLoadingStates extends StoreAppStates {}

class GetUserLoginSuccessStates extends StoreAppStates {}

class GetUserLoginErrorStates extends StoreAppStates {}

class CreateCartItemSuccessState extends StoreAppStates {}

class CreateCartItemErrorState extends StoreAppStates {}
////////////////////////////watchedRecently
class UploadWatchedItemSuccessState extends StoreAppStates {}

class UploadWatchedItemErrorState extends StoreAppStates {}

class GetWatchedLoadingStates extends StoreAppStates {}

class GetWatchedSuccessStates extends StoreAppStates {}

class GetWatchedErrorStates extends StoreAppStates {
  final String error;

  GetWatchedErrorStates(this.error);
}
class RemoveFromWatchedLoadingStates extends StoreAppStates {}

class RemoveFromWatchedSuccessStates extends StoreAppStates {}

class RemoveFromWatchedErrorStates extends StoreAppStates {}
//////////////////////////////
///////////wishlist
class UploadWishListItemSuccessState extends StoreAppStates {}

class UploadWishListItemErrorState extends StoreAppStates {}

class GetWishListLoadingStates extends StoreAppStates {}

class GetWishListSuccessStates extends StoreAppStates {}

class GetWishListErrorStates extends StoreAppStates {
  final String error;

  GetWishListErrorStates(this.error);
}
class RemoveFromWishListLoadingStates extends StoreAppStates {}

class RemoveFromWishListSuccessStates extends StoreAppStates {}

class RemoveFromWishListErrorStates extends StoreAppStates {}

class RemoveFromCartLoadingStates extends StoreAppStates {}

class RemoveFromCartSuccessStates extends StoreAppStates {}

class RemoveFromCartErrorStates extends StoreAppStates {}

class AddCartItemByOneLoadingStates extends StoreAppStates {}

class AddCartItemByOneSuccessStates extends StoreAppStates {}

class AddCartItemByOneErrorStates extends StoreAppStates {}

class ReduceCartItemByOneLoadingStates extends StoreAppStates {}

class ReduceCartItemByOneSuccessStates extends StoreAppStates {}

class ReduceCartItemByOneErrorStates extends StoreAppStates {}

//updateprofile

class UpdateErrorState extends StoreAppStates {
  final String error;

  UpdateErrorState(this.error);
}

class UpdateLoadingState extends StoreAppStates {}

/////signUp

class SignUpInitialState extends StoreAppStates {}

class SignUpLoadingState extends StoreAppStates {}

class SignUpSuccessState extends StoreAppStates {}

class SignUpErrorState extends StoreAppStates {
  final String error;

  SignUpErrorState(this.error);
}

class CreateUserSuccessState extends StoreAppStates {}

class CreateUserErrorState extends StoreAppStates {
  final String error;

  CreateUserErrorState(this.error);
}

class SignUpPasswordVisibilityState extends StoreAppStates {}

class SignUpPickedProfileImageSuccessState extends StoreAppStates {}

class SignUpPickedProfileImageErrorState extends StoreAppStates {}

class UploadProfileImageLoadingState extends StoreAppStates {}

class UploadPickedProfileImageSuccessState extends StoreAppStates {}

class UploadPickedProfileImageErrorState extends StoreAppStates {}

class SignUpPickedProfileImageCameraSuccessState extends StoreAppStates {}

class SignUpRemoveProfileImageSuccessState extends StoreAppStates {}

//////////write comment
class WriteCommentLoadingState extends StoreAppStates {}

class WriteCommentSuccessState extends StoreAppStates {}

class WriteCommentErrorState extends StoreAppStates {}

class GetCommentsLoadingStates extends StoreAppStates {}

class GetCommentsSuccessStates extends StoreAppStates {}

class GetCommentsErrorStates extends StoreAppStates {}

class ChangeRateSuccessStates extends StoreAppStates {}
//////////////////// notification
class PushNotificationLoadingState extends StoreAppStates {}
class PushNotificationSuccessState extends StoreAppStates {}
class PushNotificationErrorState extends StoreAppStates {}
//////////////phone
class CodeSentState extends StoreAppStates {}
class CodeAutoRetrievalTimeoutState extends StoreAppStates {}
class StartTimerState extends StoreAppStates {}
class SetDataState extends StoreAppStates {}
class OnPinCompletedState extends StoreAppStates {}
class PhoneSignInSuccessState extends StoreAppStates {
  final String uId;

  PhoneSignInSuccessState(this.uId);
}
class PhoneSignInErrorState extends StoreAppStates {
  final  error;

  PhoneSignInErrorState(this.error);
}