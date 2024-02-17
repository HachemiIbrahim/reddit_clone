import 'package:reddit_clone/features/feed/feed_screen.dart';
import 'package:reddit_clone/features/posts/screen/add_post_screen.dart';

class Constants {
  static const logoPath = "assets/images/logo.png";
  static const googlePath = "assets/images/google.png";
  static const loginEmotePath = "assets/images/loginEmote.png";

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];
}
