import 'package:vortel_doc_app/doc_section.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class UploadedFile {
  final String name;

  UploadedFile(this.name);
}

class DocumentUploadForm extends StatefulWidget {
  const DocumentUploadForm({super.key});

  @override
  State<DocumentUploadForm> createState() => _DocumentUploadFormState();
}

class EmployeeField {
  final String name;
  final String description;
  final bool isRequired;
  String? extractedValue;
  bool? isValid;
  String? sourceFile;

  EmployeeField({
    required this.name,
    required this.description,
    this.isRequired = true,
    this.extractedValue,
    this.isValid,
    this.sourceFile,
  });
}

class _DocumentUploadFormState extends State<DocumentUploadForm> {
  int _currentStep = 0;
  double _analysisProgress = 0.0;

  // Replace extractionResults with employeeFields
  final List<EmployeeField> employeeFields = [
    EmployeeField(
        name: 'fullName',
        description: 'Full Name',
        extractedValue: 'John Doe',
        isValid: true,
        sourceFile: 'Passport.pdf'),
    EmployeeField(
        name: 'birthDate',
        description: 'Date of Birth',
        extractedValue: '1990-05-15',
        isValid: true,
        sourceFile: 'Passport.pdf'),
    EmployeeField(
        name: 'documentNumber',
        description: 'ID Document Number',
        extractedValue: 'XYZ12345',
        isValid: false,
        sourceFile: 'LicenseImage.jpeg'),
    EmployeeField(
        name: 'expiryDate',
        description: 'Document Expiry Date',
        extractedValue: '2025-12-31',
        isValid: true,
        sourceFile: 'Passport.pdf'),
    EmployeeField(
        name: 'nationality', description: 'Nationality', extractedValue: null, isValid: null, sourceFile: null),
  ];

  final List<UploadedFile> idFiles = [
    UploadedFile('Passport.pdf'),
    UploadedFile('LicenseImage.jpeg'),
  ];

  final List<UploadedFile> additionalFiles = [
    UploadedFile('AthenaOnboardingFile.pdf'),
    UploadedFile('TaxReturn_2025.pdf'),
    UploadedFile('Medicalfiles_2018.pdf'),
    UploadedFile('Attendance_Record.csv'),
  ];

  void _startAnalysis() {
    setState(() {
      _analysisProgress = 0.0;
      _currentStep = 1;
    });

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _analysisProgress += 0.05;
        if (_analysisProgress >= 1.0) {
          timer.cancel();
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() => _currentStep = 2);
          });
        }
      });
    });
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildUploadStep();
      case 1:
        return _buildAnalysisStep();
      case 2:
        return _buildValidationStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUploadStep() {
    return DocumentSection(
      title: 'ID Verification',
      subtitle: 'Upload 2 Files',
      files: idFiles,
      onBrowse: () {/* Implement file browsing */},
      maxFiles: 2,
    );
  }

  Widget _buildAnalysisStep() {
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const Text('Analyzing Documents...'),
        LinearProgressIndicator(
          value: _analysisProgress,
          backgroundColor: Colors.grey[200],
          minHeight: 8,
        ),
        Text('${(_analysisProgress * 100).toStringAsFixed(0)}% Complete'),
      ],
    );
  }

  Widget _buildValidationStep() {
    final extractedFields = employeeFields.where((f) => f.extractedValue != null).toList();
    final missingFields = employeeFields.where((f) => f.extractedValue == null).toList();

    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExtractionSummary(extractedFields, missingFields),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Successfully Extracted Fields',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 12),
              ...extractedFields.map(_buildExtractedField),
              if (missingFields.isNotEmpty) ...[
                const Divider(height: 24),
                Text(
                  'Missing Fields',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                ...missingFields.map(_buildMissingField),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExtractedField(EmployeeField field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                field.isValid == true ? Icons.check_circle : Icons.error,
                color: field.isValid == true ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: Text(
                  field.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  field.extractedValue!,
                  style: TextStyle(
                    color: field.isValid == true ? Colors.black87 : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              'Source: ${field.sourceFile}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingField(EmployeeField field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            field.description,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractionSummary(
    List<EmployeeField> extracted,
    List<EmployeeField> missing,
  ) {
    final validFields = extracted.where((f) => f.isValid == true).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Extraction Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text('• $validFields fields successfully validated'),
          Text('• ${extracted.length - validFields} fields need review'),
          Text('• ${missing.length} fields not found in documents'),
          const SizedBox(height: 12),
          if (missing.isNotEmpty)
            Text(
              'Action Required: Upload additional documents or manually input missing fields.',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 24,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ['Document Upload', 'Analysis', 'Validation'][_currentStep],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          _buildStepContent(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                TextButton(
                  onPressed: () => setState(() => _currentStep--),
                  child: const Text('Back'),
                ),
              const Spacer(),
              if (_currentStep < 2)
                ElevatedButton(
                  onPressed: _currentStep == 0
                      ? _startAnalysis
                      : () {
                          setState(() => _currentStep++);
                        },
                  child: Text(_currentStep == 0 ? 'Next' : 'Analyze'),
                ),
              if (_currentStep == 2)
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('Export to Excel'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data exported to Excel file'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Validate and create employee'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Employee data successfully saved to database'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
