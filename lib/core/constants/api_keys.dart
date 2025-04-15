import 'package:flutter_dotenv/flutter_dotenv.dart';

final String superbase_key = dotenv.env['SUPABASE_KEY'] ?? "";
