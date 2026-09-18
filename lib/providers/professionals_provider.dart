import 'package:flutter/material.dart';
import '../models/professional.dart';

class ProfessionalsProvider with ChangeNotifier {
  List<Professional> _professionals = [
    Professional(
      id: '1',
      name: 'John Doe',
      specialty: 'Plumbing',
      rating: 4.5,
      description: 'John Doe has over 15 years of experience in plumbing. He is known for his expertise in both residential and commercial plumbing services. He is a certified plumber and has received numerous accolades for his work.',
    ),
    Professional(
      id: '2',
      name: 'Jane Smith',
      specialty: 'Cleaning',
      rating: 4.7,
      description: 'Jane Smith is a highly skilled cleaner with 10 years of experience. She specializes in deep cleaning and organizing, and is known for her meticulous attention to detail and customer satisfaction.',
    ),
    Professional(
      id: '3',
      name: 'Mike Johnson',
      specialty: 'Electrical',
      rating: 4.6,
      description: 'Mike Johnson is an experienced electrician with 12 years of experience. He is skilled in both residential and commercial electrical systems and is known for his reliable and safe work.',
    ),
    Professional(
      id: '4',
      name: 'Emily Davis',
      specialty: 'Painting',
      rating: 4.8,
      description: 'Emily Davis has a talent for painting and decorating. With over 8 years in the industry, she provides high-quality and creative painting solutions for both interior and exterior projects.',
    ),
    Professional(
      id: '5',
      name: 'Daniel Wilson',
      specialty: 'Carpentry',
      rating: 4.9,
      description: 'Daniel Wilson is a master carpenter with over 20 years of experience. He specializes in custom furniture and cabinetry, and is known for his exceptional craftsmanship and attention to detail.',
    ),
    Professional(
      id: '6',
      name: 'Sarah Brown',
      specialty: 'Gardening',
      rating: 4.4,
      description: 'Sarah Brown is an expert gardener with extensive knowledge of landscape design and plant care. She has been transforming outdoor spaces for over 7 years with her creative and sustainable approaches.',
    ),
    Professional(
      id: '7',
      name: 'James Taylor',
      specialty: 'HVAC Repair',
      rating: 4.7,
      description: 'James Taylor is a certified HVAC technician with 15 years of experience in heating, ventilation, and air conditioning. He is known for his prompt and efficient service in both installations and repairs.',
    ),
    Professional(
      id: '8',
      name: 'Laura White',
      specialty: 'Pest Control',
      rating: 4.5,
      description: 'Laura White provides comprehensive pest control solutions with over 10 years of experience. She is skilled in safely removing pests and preventing future infestations with eco-friendly methods.',
    ),
    Professional(
      id: '9',
      name: 'Robert Clark',
      specialty: 'Moving Services',
      rating: 4.8,
      description: 'Robert Clark offers reliable and efficient moving services. With over 12 years in the industry, he ensures a smooth moving experience, from packing to transport, with a focus on customer satisfaction.',
    ),
    Professional(
      id: '10',
      name: 'Jessica Lewis',
      specialty: 'Appliance Repair',
      rating: 4.6,
      description: 'Jessica Lewis is a skilled appliance repair technician with 8 years of experience. She handles a wide range of appliances with precision and is known for her quick diagnostics and effective solutions.',
    ),
  ];

  List<Professional> get professionals => _professionals;

  void addProfessional(Professional professional) {
    _professionals.add(professional);
    notifyListeners();
  }
}
