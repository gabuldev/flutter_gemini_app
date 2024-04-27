import 'package:google_generative_ai/google_generative_ai.dart';

import 'apikey.dart';

class Gemini {
  final model = GenerativeModel(
    model: 'gemini-pro-vision',
    apiKey: apiKey,
  );
}
