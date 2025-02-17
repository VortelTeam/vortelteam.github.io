import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';

class Employee {
  final String name;
  final String title;
  final String phoneNumber;
  final String streetAddress;
  final String city;
  final String postalCode;

  Employee(this.name, this.title, this.phoneNumber, this.streetAddress, this.city, this.postalCode);
}

class EmployeeRepo {
  final List<Employee> _employees = [
    Employee(
      'Samuel L. Ement',
      'Software Engineer Intern',
      '(555) 123-4567',
      '420 Tech Lane',
      'Austin',
      '78701',
    ),
    Employee(
      'Lurch Schpellchek',
      'IT Technician I',
      '(555) 234-5678',
      '789 Pine Street',
      'Seattle',
      '98101',
    ),
    Employee(
      'Eileen Dover',
      'Software Engineer',
      '(555) 345-6789',
      '567 Pearl Avenue',
      'Portland',
      '97201',
    ),
    Employee(
      'Seymour Butz',
      'Software Engineer',
      '(555) 456-7890',
      '901 Mountain View Drive',
      'Denver',
      '80202',
    ),
    Employee(
      'Ivana Tinkle',
      'Software Engineer',
      '(555) 567-8901',
      '234 Commonwealth Avenue',
      'Boston',
      '02108',
    ),
    Employee(
      'Anita Bath',
      'Software Engineer',
      '(555) 678-9012',
      '456 Market Street',
      'San Francisco',
      '94105',
    ),
  ];
  List<Employee> get employees => _employees;

  void add(Employee employee) {
    _employees.add(employee);
  }

  void exportToCsv() {
    try {
      final csvData = const ListToCsvConverter().convert([
        // Header row with all fields
        ['Name', 'Title', 'Phone Number', 'Street Address', 'City', 'Postal Code'],

        // Data rows mapping all fields from each employee
        ...employees.map((e) => [
              e.name,
              e.title,
              e.phoneNumber,
              e.streetAddress,
              e.city,
              e.postalCode,
            ])
      ]);

      // Convert CSV string to UTF-8 bytes
      final bytes = utf8.encode(csvData);

      // Create blob with CSV MIME type
      final blob = html.Blob([bytes], 'text/csv; charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Trigger download
      final fileName = 'employees_${DateTime.now().millisecondsSinceEpoch}.csv';
      html.AnchorElement(href: url)
        ..download = fileName
        ..click();

      // Cleanup
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }
}
