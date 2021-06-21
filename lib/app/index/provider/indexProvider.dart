import 'package:http/http.dart' as http;
import 'package:test_twiscode/util/config/uriConfig.dart';

class IndexProvider {
  Future<String> products() async {
    final url = Uri.parse(UriConfig.productURI);
    final r = await http.post(url);
    print("${r.statusCode} || ${r.request}");
    if (r.statusCode == 200) {
      return r.body;
    } else {
      throw Exception((e) => e.errors());
    }
  }
}
