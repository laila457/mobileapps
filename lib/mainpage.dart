import 'package:flutter/material.dart';

void main() {
  runApp(PetAdoptionApp());
}

class PetAdoptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, String>> pets = [
    {
      "name": "Sola",
      "breed": "Abyssinian cat",
      "age": "2.0 years old",
      "distance": "3.6 km",
      "image": "assets/images/cat1.jpg",
      "description": "My job requires moving to another country. I don’t have the opportunity to take the cat with me. I am looking for good people who will shelter Sola.",
      "owner": "Maya Berkovskaya",
    },
    {
      "name": "Orion",
      "breed": "Siamese cat",
      "age": "1.5 years old",
      "distance": "7.8 km",
      "image": "assets/images/cat2.jpg",
      "description": "Orion is a friendly cat looking for a new home.",
      "owner": "John Doe",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Adoption'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Location: Shahdara, Delhi',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CategorySection(),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return PetDetailCard(pet: pets[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryItem('Cats'),
        CategoryItem('Dogs'),
        CategoryItem('Parrots'),
        CategoryItem('Fish'),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String name;

  CategoryItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(name, style: TextStyle(fontSize: 16)),
    );
  }
}

class PetDetailCard extends StatelessWidget {
  final Map<String, String> pet;

  PetDetailCard({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(pet['image']!),
        title: Text(pet['name']!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pet['breed']!),
            Text(pet['age']!),
            Text(pet['distance']!),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetDetailPage(pet: pet),
            ),
          );
        },
      ),
    );
  }
}

class PetDetailPage extends StatelessWidget {
  final Map<String, String> pet;

  PetDetailPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet['name']!),
      ),
      body: Column(
        children: [
          Image.asset(pet['image']!),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pet['breed']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pet['description']!,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Owner: ${pet['owner']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}       