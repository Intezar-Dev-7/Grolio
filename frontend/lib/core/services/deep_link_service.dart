import 'dart:async';
import 'package:uni_links/uni_links.dart';

class DeepLinkService {
  Stream<Uri> linkStream() {
    // urilinkStream emits Uri? - we filter nulls and cast
    return uriLinkStream.where((u) => u != null).cast<Uri>();
  }

  Future<Uri?> getInitialLink() => getInitialUri();

  void dispose() {
    // nothing to dispose here; BLoC will cancel its sub
  }
}
