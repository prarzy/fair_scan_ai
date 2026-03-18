const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { preprocessImage } = require('../preprocess');
const { extractTextFromImage } = require('../ocr');
const pdf = require('pdf-poppler');

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => {
    const unique = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, unique + path.extname(file.originalname));
  }
});

const fileFilter = (req, file, cb) => {
  const allowed = ['image/jpeg', 'image/png', 'image/webp', 'application/pdf', 'application/octet-stream'];
  const ext = path.extname(file.originalname).toLowerCase();
  const allowedExt = ['.jpg', '.jpeg', '.png', '.webp', '.pdf'];

  // Check both MIME type AND file extension
  // Flutter on Windows sometimes sends PDFs as application/octet-stream
  if (allowed.includes(file.mimetype) && allowedExt.includes(ext)) {
    cb(null, true);
  } else {
    cb(new Error(`Unsupported file type: ${file.mimetype} (${ext})`), false);
  }
};

const upload = multer({
  storage,
  fileFilter,
  limits: { fileSize: 20 * 1024 * 1024 } // 20MB for PDFs
});

// Converts each PDF page to image, OCRs each, stitches results
async function extractTextFromPDF(pdfPath) {
  const outputDir = path.dirname(pdfPath);
  const baseName = path.basename(pdfPath, path.extname(pdfPath));

  const opts = {
    format: 'jpeg',
    out_dir: outputDir,
    out_prefix: baseName,
    page: null // all pages
  };

  await pdf.convert(pdfPath, opts);

  // Find all generated page images, sorted by page number
  const pageFiles = fs.readdirSync(outputDir)
    .filter(f => f.startsWith(baseName) && f.endsWith('.jpg'))
    .sort()
    .map(f => path.join(outputDir, f));

  if (pageFiles.length === 0) {
    throw new Error('PDF conversion produced no images. Check Poppler installation.');
  }

  let allText = '';
  const allBlocks = [];

  for (let i = 0; i < pageFiles.length; i++) {
    console.log(`  Processing page ${i + 1} of ${pageFiles.length}...`);
    const processedPath = await preprocessImage(pageFiles[i]);
    const result = await extractTextFromImage(processedPath);

    allText += `\n\n--- Page ${i + 1} ---\n` + result.full_text;

    result.blocks.forEach(block => {
      allBlocks.push({ ...block, page: i + 1 });
    });

    // Clean up page images
    fs.unlinkSync(pageFiles[i]);
    if (fs.existsSync(processedPath)) fs.unlinkSync(processedPath);
  }

  return { full_text: allText.trim(), blocks: allBlocks };
}

router.post('/upload', upload.single('document'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  const originalPath = req.file.path;
  const isPDF = req.file.mimetype === 'application/pdf' || 
              path.extname(req.file.originalname).toLowerCase() === '.pdf';

  try {
    let ocrResult;

    if (isPDF) {
      console.log(`\n PDF received: ${req.file.originalname}`);
      ocrResult = await extractTextFromPDF(originalPath);
      if (fs.existsSync(originalPath)) fs.unlinkSync(originalPath);
    } else {
      console.log(`\n Image received: ${req.file.originalname}`);
      const processedPath = await preprocessImage(originalPath);
      ocrResult = await extractTextFromImage(processedPath);
      if (fs.existsSync(originalPath)) fs.unlinkSync(originalPath);
      if (fs.existsSync(processedPath)) fs.unlinkSync(processedPath);
    }

    console.log('--- OCR RESULT ---');
    console.log('Preview:', ocrResult.full_text.substring(0, 400));
    console.log('Blocks:', ocrResult.blocks.length);
    console.log('------------------\n');

    res.status(200).json({
      status: 'success',
      full_text: ocrResult.full_text,
      blocks: ocrResult.blocks,
      block_count: ocrResult.blocks.length
    });

  } catch (err) {
    console.error('OCR error:', err.message);
    if (fs.existsSync(originalPath)) fs.unlinkSync(originalPath);
    res.status(500).json({ error: 'OCR failed', details: err.message });
  }
});

module.exports = router;