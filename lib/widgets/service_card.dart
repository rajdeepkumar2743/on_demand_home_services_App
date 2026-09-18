import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({required this.service, Key? key}) : super(key: key);

  // Maps service names to FontAwesome icons
  IconData getServiceIcon() {
    switch (service.name.toLowerCase()) {
      case 'plumbing':
        return FontAwesomeIcons.faucet;
      case 'cleaning':
        return FontAwesomeIcons.broom;
      case 'electrical':
        return FontAwesomeIcons.bolt;
      case 'painting':
        return FontAwesomeIcons.paintRoller;
      case 'carpentry':
        return FontAwesomeIcons.hammer;
      case 'gardening':
        return FontAwesomeIcons.seedling;
      case 'hvac repair':
        return FontAwesomeIcons.snowflake;
      case 'pest control':
        return FontAwesomeIcons.bug;
      case 'moving services':
        return FontAwesomeIcons.truckMoving;
      case 'appliance repair':
        return FontAwesomeIcons.screwdriverWrench;
      default:
        return FontAwesomeIcons.toolbox;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/booking', // Ensure this route is defined in MaterialApp
          arguments: service,
        );
      },
      child: Hero(
        tag: 'service-${service.name}',
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.shade50,
                  ),
                  child: Icon(
                    getServiceIcon(),
                    size: 38,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        service.description,
                        style: TextStyle(color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
