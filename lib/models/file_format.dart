enum FileFormat {
  PNG,
  JPG,
  JPEG,
  NONE,
}

class FileFormatHelper {
  /**
   * Extension must include '.' e.g. '.png'
   */
  static FileFormat fromExtension(String extension) {
    switch (extension) {
      case '.png':
        return FileFormat.PNG;
      case '.jpg':
        return FileFormat.JPG;
      case '.jpeg':
        return FileFormat.JPEG;
      default:
        return FileFormat.NONE;
    }
  }

  /**
   * Extension will include '.' e.g. '.png'
   */
  static String toExtension(FileFormat format) {
    switch (format) {
      case FileFormat.PNG:
        return '.png';
      case FileFormat.JPG:
        return '.jpg';
      case FileFormat.JPEG:
        return '.jpeg';
      default:
        return ''; // Unknown FileFormat
    }
  }
}
