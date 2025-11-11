import 'package:shared_preferences/shared_preferences.dart';
import 'package:prac5/services/image_service.dart';

class UserProfile {
  final String id;
  String nickname;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.nickname,
    required this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'avatarUrl': avatarUrl,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'],
        nickname: json['nickname'],
        avatarUrl: json['avatarUrl'],
      );
}

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final ImageService _imageService = ImageService();

  static const String _keyUserId = 'user_id';
  static const String _keyNickname = 'user_nickname';
  static const String _keyAvatarUrl = 'user_avatar_url';

  Future<UserProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString(_keyUserId);
    String? nickname = prefs.getString(_keyNickname);
    String? avatarUrl = prefs.getString(_keyAvatarUrl);

    if (userId == null) {
      userId = DateTime.now().millisecondsSinceEpoch.toString();
      nickname = 'Повар';

      avatarUrl = await _imageService.getNextAvatar();

      if (avatarUrl == null) {
        avatarUrl = 'https://picsum.photos/seed/user$userId/400/400';
      }

      await prefs.setString(_keyUserId, userId);
      await prefs.setString(_keyNickname, nickname);
      await prefs.setString(_keyAvatarUrl, avatarUrl);
    }

    if (nickname == 'Читатель' || nickname == 'Р§РёС‚Р°С‚РµР»СЊ') {
      nickname = 'Повар';
      await prefs.setString(_keyNickname, nickname);
    }

    return UserProfile(
      id: userId,
      nickname: nickname ?? 'Повар',
      avatarUrl: avatarUrl ?? 'https://picsum.photos/seed/user$userId/400/400',
    );
  }

  Future<void> updateNickname(String newNickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNickname, newNickname);
  }

  Future<void> updateAvatar(String newAvatarUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAvatarUrl, newAvatarUrl);
  }
}

