import 'package:flutter/material.dart';
import 'package:wellpage/apps_style2.dart';
import 'package:wellpage/pet/booking.dart';
import 'package:wellpage/pet/formbooking.dart';
import 'package:wellpage/pet/profile.dart';
import 'package:wellpage/screen/welcome.dart';
import 'package:wellpage/sizes_config2.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wellpage/pet/dasboard.dart';

class PenitipanPage extends StatefulWidget {
  const PenitipanPage({super.key});

  @override
  State<PenitipanPage> createState() => _PenitipanPageState();
}

class _PenitipanPageState extends State<PenitipanPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeScreen(), // First Page (previously the HomeScreen)
          FormBooking(), // Replace with your actual ChatPage widget
          const PenitipanPage(), // Replace with your actual NewPostPage widget
          const HomeScreens(), // Replace with your actual Signin widget
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    List<String> dogs = [
      'dog_marly.png',
      'dog_cocoa.png',
      'dog_walt.png',
    ];

    List<String> cats = [
      'cat_alyx.png',
      'cat_brook.png',
      'cat_marly.png',
    ];

    List<String> dogsName = [
      'Kiko',
      'Coco',
      'Moli',
    ];

    List<String> catsName = [
      'Ucup',
      'Opet',
      'Siti',
    ];

    return SafeArea(
      child: SingleChildScrollView( // Add this to allow scrolling
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/nav_icon.svg',
                    width: 18,
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: kRed,
                    backgroundImage: NetworkImage(
                      'https://cdn3d.iconscout.com/3d/premium/thumb/boy-avatar-6299533-5187865.png',
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 19),
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/welcome_message.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: SizeConfig.blockSizeHorizontal! * 38,
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: kSourceSansProLight.copyWith(
                                fontSize: SizeConfig.blockSizeHorizontal! * 5.5,
                                color: kBlack,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Osama',
                              style: kSourceSansProMedium.copyWith(
                                fontSize: SizeConfig.blockSizeHorizontal! * 5.5,
                                color: kBlack,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '👋',
                              style: kSourceSansProMedium.copyWith(
                                fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                                color: kBlack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Ready for an amazing and lucky experience 🐈 🐕',
                          style: kSourceSansProregular.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                            color: kBlack,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Row(
                children: [
                  Text(
                    'Dogs',
                    style: kSourceSansProBold.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal! * 6,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '🐕',
                    style: kSourceSansProBold.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal! * 3,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 169,
              child: ListView.builder(
                itemCount: dogs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 169,
                    width: 150,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 30 : 15,
                      right: index == dogs.length - 1 ? 30 : 0,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadiusList),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14,
                          offset: const Offset(0, 3),
                          color: kBoxShadowColor.withOpacity(0.18),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(kBorderRadiusList),
                            child: Image.asset(
                              'assets/images/${dogs[index]}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: SizeConfig.blockSizeVertical! * 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.5),
                                color: kLightOrange,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              child: Center(
                                child: Text(
                                  'Happy Paws',
                                  style: kSourceSansProBold.copyWith(
                                    fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                                    color: kOrange,
                                  ),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.favorite_outline,
                              color: kRed,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              dogsName[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kSourceSansProBold.copyWith(
                                fontSize: SizeConfig.blockSizeHorizontal! * 3,
                                color: kGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '17 jun 2021',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kSourceSansProregular.copyWith(
                                fontSize: SizeConfig.blockSizeHorizontal! * 2,
                                color: kLightGrey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Row(
                children: [
                  Text(
                    'Cats',
                    style: kSourceSansProBold.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal! * 6,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '🐈',
                    style: kSourceSansProBold.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal! * 3,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 169,
              child: ListView.builder(
                itemCount: cats.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 169,
                    width: 150,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 30 : 15,
                      right: index == cats.length - 1 ? 30 : 0,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadiusList),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 14,
                          offset: const Offset(0, 3),
                          color: kBoxShadowColor.withOpacity(0.18),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(kBorderRadiusList),
                            child: Image.asset(
                              'assets/images/${cats[index]}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: SizeConfig.blockSizeVertical! * 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.5),
                                color: kLightOrange,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              child: Center(
                                child: Text(
                                  'Happy Paws',
                                  style: kSourceSansProBold.copyWith(
                                    fontSize: SizeConfig.blockSizeHorizontal! * 2.5,
                                    color: kOrange,
                                  ),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.favorite_outline,
                              color: kRed,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              catsName[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kSourceSansProBold.copyWith(
                                fontSize: SizeConfig.blockSizeHorizontal! * 3,
                                color: kGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '17 jun 2021',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kSourceSansProregular.copyWith(
                                fontSize: SizeConfig.blockSizeHorizontal! * 2,
                                color: kLightGrey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}