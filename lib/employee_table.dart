import 'package:vortel_doc_app/data/employee_repo.dart';
import 'package:vortel_doc_app/employee_details.dart';
import 'package:vortel_doc_app/employee_doc_upload.dart';
import 'package:flutter/material.dart';

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({super.key});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  late List<(bool, Employee)> _employees;
  Employee? _selectedEmployee;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final repo = EmployeeRepo();

  void refresh() {
    if (!mounted) return;
    setState(() {
      _employees = List.generate(
        repo.employees.length,
        (index) {
          final e = repo.employees[index];
          return (false, e);
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void _selectEmployee(Employee employee) {
    setState(() {
      final wasSelected = _selectedEmployee?.name == employee.name;

      // Deselect if clicking the same employee
      if (wasSelected) {
        _selectedEmployee = null;
        _employees = _employees.map((emp) => (false, employee)).toList();
      } else {
        // Select new employee
        _employees = _employees.map((emp) {
          return (emp.$2.name == employee.name, emp.$2);
        }).toList();
        _selectedEmployee = employee;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () async {
              await showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return AlertDialog(
                    content: const DocumentUploadForm(),
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
                barrierDismissible: true,
                barrierLabel: '',
              );

              repo.add(Employee('John Doe', 'Consultant', '123-456-7890', '993 Faker street', 'SF', '4D8 ER9'));
              refresh();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => repo.exportToCsv(),
            child: const Icon(Icons.download),
          ),
        ],
      ),
      key: _scaffoldKey,
      body: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DataTable(
              showCheckboxColumn: false,
              horizontalMargin: 20,
              dividerThickness: 0.0000001,
              columns: const [
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              rows: _employees.map((employee) {
                return DataRow(
                  selected: employee.$1,
                  onSelectChanged: (_) => _selectEmployee(
                    Employee(employee.$2.name, employee.$2.title, employee.$2.phoneNumber, employee.$2.streetAddress,
                        employee.$2.city, employee.$2.postalCode),
                  ),
                  cells: [
                    DataCell(Text(employee.$2.name)),
                    DataCell(Text(employee.$2.title)),
                  ],
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black.withValues(alpha: .7), width: 1),
              ),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(8),
              child: _selectedEmployee != null
                  ? EmployeeDetails(employee: _selectedEmployee!)
                  : Center(child: Text('Select an employee to view details')),
            ),
          ),
        ],
      ),
    );
  }
}
