// employee_documents_screen.dart

import 'package:doc_proc/employee_doc_upload.dart';
import 'package:flutter/material.dart';

class DocumentSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<UploadedFile> files;
  final VoidCallback onBrowse;
  final int maxFiles;

  const DocumentSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.files,
    required this.onBrowse,
    required this.maxFiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (subtitle != null) Text(subtitle!),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Drag & drop files or'),
                  TextButton(
                    onPressed: onBrowse,
                    child: const Text('Browse'),
                  ),
                ],
              ),
              const Text(
                'Supported formats: JPEG, PNG, PDF, Word',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            for (var file in files)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(file.name),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.red,
                      onPressed: () {
                        // Handle file removal
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (files.length >= maxFiles)
          const Text(
            'Max upload limit reached!',
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}

class Employee {
  final String name;
  final String title;

  Employee(this.name, this.title);
}
