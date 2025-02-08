import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class SupabaseService {
  static final _logger = Logger('SupabaseService');
  static const String supabaseUrl = "https://glqmcbtatdcqntsdbbnz.supabase.co";
  static const String supabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdscW1jYnRhdGRjcW50c2RiYm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYzMzQ3NjIsImV4cCI6MjA1MTkxMDc2Mn0.-rgbe9tz3FioPEGMsF33gk1Z8Bs7VU_djzjXpsdtFHw";

  // Secure storage instance
  static final _storage = const FlutterSecureStorage();

  // Initialize Supabase
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
        localStorage: SecureLocalStorage(), // Use custom secure storage
        debug: false,
      );
      _logger.info('Supabase initialized successfully');
    } catch (e, stackTrace) {
      _logger.severe('Failed to initialize Supabase', e, stackTrace);
      rethrow;
    }
  }

  // Get the Supabase client
  static SupabaseClient get client => Supabase.instance.client;

  // Check if the user is signed in
  static bool get isSignedIn => client.auth.currentSession != null;

  // Persist the session securely
  static Future<void> persistSession(String sessionString) async {
    try {
      if (sessionString.isEmpty)
        throw ArgumentError('Session string cannot be empty');
      await _storage.write(
        key: 'session',
        value: sessionString,
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
        iOptions:
            const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );
      _logger.fine('Session persisted successfully');
    } catch (e, stackTrace) {
      _logger.severe('Failed to persist session', e, stackTrace);
      rethrow;
    }
  }

  // Clear the session from secure storage
  static Future<void> clearSession() async {
    try {
      await _storage.delete(key: 'session');
    } catch (e) {
      print('Failed to clear session: $e');
    }
  }

  // Restore the session from secure storage
  static Future<String?> restoreSession() async {
    try {
      return await _storage.read(key: 'session');
    } catch (e) {
      print('Failed to restore session: $e');
      return null;
    }
  }
}

class SecureLocalStorage implements LocalStorage {
  SecureLocalStorage();
  final _logger = Logger('SecureLocalStorage');
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<String?> Function() get accessToken => () async {
        return await _storage.read(key: 'access_token');
      };

  @override
  Future<bool> Function() get hasAccessToken => () async {
        final token = await _storage.read(key: 'access_token');
        return token != null && token.isNotEmpty;
      };

  @override
  Future<void> Function() get initialize => () async {
        // Initialization logic if needed
      };

  @override
  Future<void> Function(String sessionString) get persistSession =>
      (String sessionString) async {
        try {
          if (sessionString.isEmpty)
            throw ArgumentError('Session string cannot be empty');
          await _storage.write(
            key: 'session',
            value: sessionString,
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
            iOptions: const IOSOptions(
                accessibility: KeychainAccessibility.first_unlock),
          );
          _logger.fine('Session persisted to secure storage');
        } catch (e, stackTrace) {
          _logger.severe(
              'Failed to persist session to secure storage', e, stackTrace);
          rethrow;
        }
      };

  @override
  Future<String?> get refreshToken async {
    return await _storage.read(key: 'refresh_token');
  }

  @override
  Future<void> Function() get removePersistedSession => () async {
        try {
          await _storage.delete(key: 'session');
          await _storage.delete(key: 'access_token');
          await _storage.delete(key: 'refresh_token');
        } catch (e) {
          _logger.severe('Failed to remove persisted session: $e');
          rethrow;
        }
      };

  @override
  Future<void> setAccessToken(String value) async {
    try {
      await _storage.write(key: 'access_token', value: value);
    } catch (e) {
      print('Failed to set access token: $e');
    }
  }

  @override
  Future<void> setRefreshToken(String value) async {
    try {
      await _storage.write(key: 'refresh_token', value: value);
    } catch (e) {
      print('Failed to set refresh token: $e');
    }
  }

  @override
  Future<String?> getItem(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Failed to read item from secure storage: $e');
      return null;
    }
  }

  @override
  Future<void> setItem(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Failed to write item to secure storage: $e');
    }
  }

  @override
  Future<void> removeItem(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Failed to remove item from secure storage: $e');
    }
  }
}
