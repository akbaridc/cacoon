import 'package:get/get.dart';


class HomeController extends GetxController {
  final stories = [
    {'name': 'Your Story', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Ethan', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Olivia', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Noah', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Emma', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Liam', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Sophia', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Mason', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Ava', 'profileImage': 'https://placehold.co/100x100'},
    {'name': 'Lucas', 'profileImage': 'https://placehold.co/100x100'},
  ];

  final posts = [
    {
      'name': 'Liam Carter',
      'profileImage': 'https://placehold.co/100x100',
      'time': '1d ago',
      'postImage': 'https://picsum.photos/seed/picsum/200/300', // Bisa ganti pakai gambar kamu
      'likes': 234,
      'caption': 'Exploring the beauty of modern interior design. #interiordesign #homedecor',
      'comments': 12,
    },
    {
      'name': 'Emma Johnson',
      'profileImage': 'https://placehold.co/100x100',
      'time': '2d ago',
      'postImage': 'https://picsum.photos/seed/picsum/200/300', // Bisa ganti pakai gambar kamu
      'likes': 150,
      'caption': 'A cozy corner for reading and relaxation. #cozycorner #readingnook',
      'comments': 5,
    },
    {      'name': 'Olivia Brown',
      'profileImage': 'https://placehold.co/100x100',
      'time': '3d ago',
      'postImage': 'https://picsum.photos/seed/picsum/200/300', // Bisa ganti pakai gambar kamu
      'likes': 300,
      'caption': 'Nature-inspired decor for a fresh look. #naturedecor #freshvibes',
      'comments': 20,
    },
    // Tambahkan post lain jika perlu
  ];
}
