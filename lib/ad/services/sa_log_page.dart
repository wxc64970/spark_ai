import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/sa_ad_log_model.dart';
import 'sa_ad_log_service.dart';

class SAAdLogPage extends StatefulWidget {
  const SAAdLogPage({super.key});

  @override
  State<SAAdLogPage> createState() => _SAAdLogPageState();
}

class _SAAdLogPageState extends State<SAAdLogPage> {
  final _adLogService = AdLogService();
  List<AdLogModel> _logs = [];
  bool _isLoading = true;
  String _filterType = 'all'; // all, pending, failed

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final box = await _adLogService.box;
      var logs = box.values.toList();

      // Apply filter
      switch (_filterType) {
        case 'pending':
          logs = logs.where((log) => !log.isUploaded).toList();
          break;
        case 'failed':
          logs = logs.where((log) => !log.isSuccess).toList();
          break;
      }

      // Sort by createTime descending
      logs.sort((a, b) => b.createTime.compareTo(a.createTime));

      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Failed to load logs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad Logs'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _filterType = value);
              _loadLogs();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Logs')),
              const PopupMenuItem(value: 'pending', child: Text('Pending Logs')),
              const PopupMenuItem(value: 'failed', child: Text('Failed Logs')),
            ],
            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.filter_list)),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? const Center(child: Text('No logs found'))
          : RefreshIndicator(
              onRefresh: _loadLogs,
              color: Colors.blue,
              child: ListView.builder(
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];

                  var name = '';
                  try {
                    var dic = jsonDecode(log.data);
                    name = dic["wow"];
                  } catch (e) {}

                  return ListTile(
                    title: Text('Event: ${log.eventType}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('id: ${log.id}', style: const TextStyle(color: Colors.blue)),
                        if (name.isNotEmpty) Text('name: $name', style: const TextStyle(color: Colors.blue)),
                        Text('Created: ${DateTime.fromMillisecondsSinceEpoch(log.createTime)}'),
                        if (log.uploadTime != null) Text('Uploaded: ${DateTime.fromMillisecondsSinceEpoch(log.uploadTime!)}'),
                        Row(
                          children: [
                            Icon(log.isUploaded ? Icons.cloud_done : Icons.cloud_upload, color: log.isUploaded ? Colors.green : Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(log.isUploaded ? 'Uploaded' : 'Pending', style: TextStyle(color: log.isUploaded ? Colors.green : Colors.orange)),
                            const SizedBox(width: 8),
                            if (log.isUploaded) Icon(log.isSuccess ? Icons.check_circle : Icons.error, color: log.isSuccess ? Colors.green : Colors.red, size: 16),
                            const SizedBox(width: 4),
                            if (log.isUploaded) Text(log.isSuccess ? 'Success' : 'Failed', style: TextStyle(color: log.isSuccess ? Colors.green : Colors.red)),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Log Details - ${log.eventType}'),
                          content: SingleChildScrollView(
                            child: SelectableText(log.data), // 替换为SelectableText
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                            IconButton(
                              icon: const Icon(Icons.content_copy),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: log.data));
                                Get.snackbar('Copied', 'Log data copied to clipboard');
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
