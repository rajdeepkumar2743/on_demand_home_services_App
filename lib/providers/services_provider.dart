import 'package:flutter/material.dart';
import '../models/service.dart';

class ServicesProvider with ChangeNotifier {
  final List<Service> _services = [
    Service(id: '1', name: 'Plumbing', description: 'Fix your plumbing issues.', price: 400.0),
    Service(id: '2', name: 'Cleaning', description: 'Get your house cleaned.', price: 300.0),
    Service(id: '3', name: 'Electrical', description: 'Solve electrical problems and installations.', price: 500.0),
    Service(id: '4', name: 'Painting', description: 'Professional house and wall painting services.', price: 400.0),
    Service(id: '5', name: 'Carpentry', description: 'Custom furniture and woodwork services.', price: 450.0),
    Service(id: '6', name: 'Gardening', description: 'Maintain and beautify your garden.', price: 350.0),
    Service(id: '7', name: 'HVAC Repair', description: 'Repair and maintain your heating and cooling systems.', price: 800.0),
    Service(id: '8', name: 'Pest Control', description: 'Get rid of pests and insects from your home.', price: 700.0),
    Service(id: '9', name: 'Moving Services', description: 'Professional movers for your home relocation.', price: 1000.0),
    Service(id: '10', name: 'Appliance Repair', description: 'Fix and maintain your home appliances.', price: 550.0),
  ];

  List<Service> get services => _services;

  // Add a service
  void addService(Service service) {
    _services.add(service);
    notifyListeners(); // Notify listeners to update UI
  }

  // Remove a service
  void removeService(String id) {
    _services.removeWhere((service) => service.id == id);
    notifyListeners(); // Notify listeners to update UI
  }

  // Get a service by ID
  Service getServiceById(String id) {
    return _services.firstWhere((service) => service.id == id);
  }
}
