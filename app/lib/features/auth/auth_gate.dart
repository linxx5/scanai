// Login only when needed. Free work never asks.
// Gated: big batch, cloud AI, sync, share forms, pay.
enum GatedFeature { batchOverFree, cloudAi, sync, publishForm, pay }

class AuthGate {
  final bool loggedIn;
  const AuthGate({this.loggedIn = false});

  bool needsAccount(GatedFeature f) {
    switch (f) {
      case GatedFeature.batchOverFree:
      case GatedFeature.cloudAi:
      case GatedFeature.sync:
      case GatedFeature.publishForm:
      case GatedFeature.pay:
        return !loggedIn;
    }
  }

  String wallText(GatedFeature f) {
    switch (f) {
      case GatedFeature.batchOverFree:
        return 'Big batch needs an account. Your work is kept.';
      case GatedFeature.cloudAi:
        return 'Cloud AI needs an account + your tap.';
      case GatedFeature.sync:
        return 'Sync needs an account. Papers stay on phone till then.';
      case GatedFeature.publishForm:
        return 'Share forms needs an account.';
      case GatedFeature.pay:
        return 'Pay needs an account. Test mode is free.';
    }
  }
}
