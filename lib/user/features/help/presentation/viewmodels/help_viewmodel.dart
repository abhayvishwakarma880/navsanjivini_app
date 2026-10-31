import 'package:flutter/foundation.dart';
import '../../domain/entities/help_resource.dart';

class HelpViewModel extends ChangeNotifier {
  final List<HelpResource> _resources = const [
    HelpResource(
      id: 'telemanas',
      name: 'Tele-MANAS (Govt. of India)',
      description: 'National tele-mental health programme providing free 24/7 psychological support across India.',
      contactNumber: '14416',
      operatingHours: '24 Hours, 7 Days a Week',
      isTollFree: true,
    ),
    HelpResource(
      id: 'kiran',
      name: 'KIRAN Mental Health Helpline',
      description: 'Helpline by Department of Empowerment of Persons with Disabilities.',
      contactNumber: '1800-599-0019',
      operatingHours: '24/7 Support',
      isTollFree: true,
    ),
    HelpResource(
      id: 'vandrevala',
      name: 'Vandrevala Foundation Helpline',
      description: 'Free crisis intervention and mental health support by trained clinical counsellors.',
      contactNumber: '+91 9999 666 555',
      operatingHours: '24/7 Support',
      isTollFree: false,
    ),
  ];

  List<HelpResource> get resources => _resources;
}
