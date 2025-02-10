import 'package:doc_proc/doc_section.dart';
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

class _DocumentUploadFormState extends State<DocumentUploadForm> {
  int _currentStep = 0;
  double _analysisProgress = 0.0;
  final List<String> extractionResults = [
    'Name: John Doe ✓',
    'Birth Date: 1990-05-15 ✓',
    'Document Number: XYZ12345 ✗',
    'Expiry Date: 2025-12-31 ✓'
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ...extractionResults.map((result) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    result.contains('✓') ? Icons.check_circle : Icons.error,
                    color: result.contains('✓') ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(result.replaceAll(RegExp(r' [✓✗]'), '')),
                ],
              ),
            )),
      ],
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
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Finish'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
