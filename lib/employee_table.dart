import 'package:vortel_doc_app/data/employee_repo.dart';
import 'package:vortel_doc_app/employee_details.dart';
import 'package:vortel_doc_app/doc_section.dart';
import 'package:vortel_doc_app/employee_doc_upload.dart';
import 'package:flutter/material.dart';

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({super.key});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  late List<(bool, {String name, String title})> _employees;
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
          return (false, name: e.name, title: e.title);
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
        _employees = _employees.map((emp) => (false, name: emp.name, title: emp.title)).toList();
      } else {
        // Select new employee
        _employees = _employees.map((emp) {
          return (emp.name == employee.name, name: emp.name, title: emp.title);
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

              repo.add(Employee('John Doe', 'Consultant'));
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
                    Employee(employee.name, employee.title),
                  ),
                  cells: [
                    DataCell(Text(employee.name)),
                    DataCell(Text(employee.title)),
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
