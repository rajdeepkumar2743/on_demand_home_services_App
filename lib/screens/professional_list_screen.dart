import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/professionals_provider.dart';
import '../models/professional.dart';
import 'professional_details_screen.dart';

class ProfessionalListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final professionalsProvider = Provider.of<ProfessionalsProvider>(context);
    final professionals = professionalsProvider.professionals;

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Professionals'),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(21),
          itemCount: professionals.length,
          itemBuilder: (ctx, i) {
            final professional = professionals[i];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfessionalDetailsScreen(professional: professional),
                  ),
                );
              },
              child: Hero(
                tag: professional.id,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.purple.shade50],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.deepPurple.shade50,
                        child: Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                          size: 40,
                        ),
                      ),
                      title: Text(
                        professional.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            professional.specialty,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              5,
                                  (index) => Icon(
                                index < professional.rating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
