const sharp = require('sharp');

async function preprocessImage(inputPath) {
  const outputPath = inputPath.replace(/(\.[\w]+)$/, '_processed.jpg');

  await sharp(inputPath)
    .grayscale()
    .normalise()
    .sharpen({ sigma: 1.5 })
    .resize({ width: 2000, withoutEnlargement: false })
    .jpeg({ quality: 95 })
    .toFile(outputPath);

  return outputPath;
}

module.exports = { preprocessImage };