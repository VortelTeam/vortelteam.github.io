import 'package:vortel_doc_app/doc_section.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';

class EmployeeRepo {
  final List<Employee> _employees = [
    Employee('Samuel L. Ement', 'Software Engineer Intern'),
    Employee('Lurch Schpellchek', 'IT Technician I'),
    Employee('Eileen Dover', 'Software Engineer'),
    Employee('Seymour Butz', 'Software Engineer'),
    Employee('Ivana Tinkle', 'Software Engineer'),
    Employee('Anita Bath', 'Software Engineer'),
  ];

  List<Employee> get employees => _employees;

  void add(Employee employee) {
    _employees.add(employee);
  }

  void exportToCsv() {
    try {
      // Convert data to list format
      List<List<dynamic>> rows = [
        ['Name', 'Title'], // Header row
        ...employees.map((employee) => [
              employee.name,
              employee.title,
            ])
      ];

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(rows);

      // Create blob
      final bytes = csv.codeUnits;
      final blob = html.Blob([bytes], 'text/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create download link
      html.AnchorElement(href: url)
        ..setAttribute("download", "employees_${DateTime.now().millisecondsSinceEpoch}.csv")
        ..click(); // This triggers the download

      // Clean up by revoking URL
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Failed to export CSV: \$e');
    }
  }
}
