import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'models/scan_record.dart';

class HistoryView extends StatefulWidget {
  final List<ScanRecord> scanHistory;
  final void Function(int index) onDelete;

  const HistoryView({
    super.key,
    required this.scanHistory,
    required this.onDelete,
  });

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {

  void _showScanDetail(BuildContext context, ScanRecord record) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    record.isPdf ? Icons.picture_as_pdf : Icons.image_outlined,
                    color: AppColors.accentNeon,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      record.fileName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.secondaryBrand),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Scanned: ${record.scannedDate}  ·  ${record.blockCount} blocks extracted',
                style: const TextStyle(color: AppColors.secondaryBrand, fontSize: 12),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              const Text(
                'Extracted Text',
                style: TextStyle(
                    color: AppColors.accentNeon,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      record.extractedText.isEmpty
                          ? 'No text extracted.'
                          : record.extractedText,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.7,
                        fontFamily: 'Courier New',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CLOSE',
                      style: TextStyle(color: AppColors.accentNeon)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Scan History",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(width: 16),
              // Live count badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentNeon.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.scanHistory.length} scans',
                  style: const TextStyle(
                      color: AppColors.accentNeon,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Empty state
          if (widget.scanHistory.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history_rounded,
                        size: 64,
                        color: AppColors.secondaryBrand.withValues(alpha: 0.2)),
                    const SizedBox(height: 16),
                    const Text(
                      'No scans yet',
                      style: TextStyle(
                          color: AppColors.secondaryBrand, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload a document in Analyze to get started',
                      style: TextStyle(
                          color: AppColors.secondaryBrand, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: widget.scanHistory.length,
                itemBuilder: (context, index) {
                  // Show newest first
                  final item = widget.scanHistory[
                      widget.scanHistory.length - 1 - index];
                  final realIndex = widget.scanHistory.length - 1 - index;

                  return InkWell(
                    onTap: () => _showScanDetail(context, item),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          // File type icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.accentNeon.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              item.isPdf
                                  ? Icons.picture_as_pdf
                                  : Icons.image_outlined,
                              color: AppColors.accentNeon,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.fileName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Scanned: ${item.scannedDate}  ·  ${item.blockCount} blocks',
                                  style: const TextStyle(
                                      color: AppColors.secondaryBrand,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // View button
                          TextButton(
                            onPressed: () => _showScanDetail(context, item),
                            child: const Text('VIEW',
                                style: TextStyle(
                                    color: AppColors.accentNeon,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.danger),
                            onPressed: () => widget.onDelete(realIndex),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}