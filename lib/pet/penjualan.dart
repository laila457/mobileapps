import 'package:flutter/material.dart';
import 'package:wellpage/apps_style2.dart';
import 'package:wellpage/sizes_config2.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const Penjualan());
}

class Penjualan extends StatefulWidget {
  const Penjualan({super.key});

  @override
  State<Penjualan> createState() => _PenjualanState();
}

class _PenjualanState extends State<Penjualan> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Kembali ke beranda.dart
            },
          ),
        ),
        body: const HomeScreen(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kWhite,
          items: [
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? SvgPicture.asset('assets/home_selected.svg')
                  : SvgPicture.asset('assets/home_unselected.svg'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? SvgPicture.asset('assets/cart_selected.svg')
                  : SvgPicture.asset('assets/cart_unselected.svg'),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? SvgPicture.asset('assets/profile_selected.svg')
                  : SvgPicture.asset('assets/profile_unselected.svg'),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
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
      'rca1.jpeg',
      'rca2.jpeg',
      'rca3.jpg',
    ];

    List<String> cats = [
      'rck1.jpg',
      'rck2.jpg',
      'rck3.jpg',
    ];

    List<String> hamsters = [
      'hm1.jpg',
      'hm2.jpg',
      'hm3.jpg',
    ];

    List<String> bunny = [
      'kl1.jpg',
      'kl2.jpg',
      'kl3.jpg',
    ];

    List<String> dogsName = [
      'Rp 400.000',
      'Rp 400.000',
      'Rp 400.000',
    ];

    List<String> catsName = [
      'Rp 300.000',
      'Rp 300.000',
      'Rp 300.000',
    ];

    List<String> hamstersName = [
      'Rp 20.000',
      'Rp 118.000',
      'Rp 18.000',
    ];

    List<String> bunnyName = [
      'Bitter Bunny',
      'SmarterHeart',
      'SmarterHeart',
    ];

    // List of texts for each dog
    List<String> dogDescriptions = [
      'Royal Canin',
      'Royal Canin',
      'Royal Canin',
    ];

    // List of texts for each cat
    List<String> catDescriptions = [
      'Royal Canin',
      'Royal Canin',
      'Royal Canin',
    ];

    // List of texts for each hamster
    List<String> hamsterDescriptions = [
      'Royal Canin',
      'Royal Canin',
      'Royal Canin',
    ];

    // List of texts for each guinea pig
    List<String> bunnyDescriptions = [
      'Bitter Bunny',
      'SmarterHeart',
      'SmarterHeart',
    ];

    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/nav_icon.svg', width: 18),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: kRed,
                  backgroundImage: NetworkImage(
                    'https://cdn3d.iconscout.com/3d/premium/thumb/boy-avatar-6299533-5187865.png',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 19),
          // Welcome message section
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
                            'Sinta',
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
                        'Nutrisi Sehat, Hewan Bahagia! 🐈 🐕',
                        style: kSourceSansProregular.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                          color: kBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Dogs section
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Row(
              children: [
                Text(
                  'Dogs',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 5,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '🐕',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: dogs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 250,
                  width: 160,
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
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
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
                      Flexible(
                        child: Text(
                          dogDescriptions[index],
                          style: kSourceSansProBold.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                            color: kOrange,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dogsName[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProBold.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          color: kGrey,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '300 stock',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProregular.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 2,
                          color: kLightGrey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          // Cats section
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Row(
              children: [
                Text(
                  'Cats',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 5,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '🐈',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: cats.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 250,
                  width: 160,
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
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
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
                      Flexible(
                        child: Text(
                          catDescriptions[index],
                          style: kSourceSansProBold.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                            color: kOrange,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        catsName[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProBold.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          color: kGrey,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '263 stock',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProregular.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 2,
                          color: kLightGrey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          // Hamsters section
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Row(
              children: [
                Text(
                  'Hamsters',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 5,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '🐹',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: hamsters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 250,
                  width: 160,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 30 : 15,
                    right: index == hamsters.length - 1 ? 30 : 0,
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
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kBorderRadiusList),
                          child: Image.asset(
                            'assets/images/${hamsters[index]}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          hamsterDescriptions[index],
                          style: kSourceSansProBold.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                            color: kOrange,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        hamstersName[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProBold.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          color: kGrey,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '290 stock',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProregular.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 2,
                          color: kLightGrey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          // Guinea Pigs section
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Row(
              children: [
                Text(
                  'Bunnys',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 5,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '🐰',
                  style: kSourceSansProBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: bunny.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 250,
                  width: 160,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 30 : 15,
                    right: index == bunny.length - 1 ? 30 : 0,
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
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kBorderRadiusList),
                          child: Image.asset(
                            'assets/images/${bunny[index]}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          bunnyDescriptions[index],
                          style: kSourceSansProBold.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                            color: kOrange,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bunnyName[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProBold.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          color: kGrey,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '310 stock',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kSourceSansProregular.copyWith(
                          fontSize: SizeConfig.blockSizeHorizontal! * 2,
                          color: kLightGrey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}