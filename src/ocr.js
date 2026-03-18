const Tesseract = require('tesseract.js');

async function extractTextFromImage(imagePath) {
  const result = await Tesseract.recognize(imagePath, 'eng', {
    logger: m => {
      if (m.status === 'recognizing text') {
        process.stdout.write(`\r  OCR Progress: ${Math.round(m.progress * 100)}%`);
      }
    }
  });

  console.log('\n  OCR complete.');

  const { data } = result;
  const blocks = [];

const paragraphs = data.paragraphs || [];

  for (const paragraph of paragraphs) {
    if (!paragraph.text || !paragraph.text.trim()) continue;
    if (!paragraph.bbox) continue;

    blocks.push({
      text: paragraph.text.trim(),
      bounding_box: {
        x: paragraph.bbox.x0,
        y: paragraph.bbox.y0,
        width: paragraph.bbox.x1 - paragraph.bbox.x0,
        height: paragraph.bbox.y1 - paragraph.bbox.y0,
      },
      confidence: parseFloat((paragraph.confidence / 100).toFixed(2)),
      page: 1
    });
  }

  // Fallback: if paragraphs gave nothing, use the raw lines instead
  if (blocks.length === 0 && data.lines) {
    for (const line of data.lines) {
      if (!line.text || !line.text.trim()) continue;
      if (!line.bbox) continue;

      blocks.push({
        text: line.text.trim(),
        bounding_box: {
          x: line.bbox.x0,
          y: line.bbox.y0,
          width: line.bbox.x1 - line.bbox.x0,
          height: line.bbox.y1 - line.bbox.y0,
        },
        confidence: parseFloat((line.confidence / 100).toFixed(2)),
        page: 1
      });
    }
  }

  return {
    full_text: data.text,
    blocks
  };
}

module.exports = { extractTextFromImage };