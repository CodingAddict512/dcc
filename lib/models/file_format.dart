enum FileFormat {
  PNG,
  JPG,
  JPEG,
  NONE,
}

extension FileFormatExtension on FileFormat {
  static FileFormat fromString(String format) {
    switch (format.toUpperCase()) {
      case 'PNG':
        return FileFormat.PNG;
      case 'JPG':
        return FileFormat.JPG;
      case 'JPEG':
        return FileFormat.JPEG;
      default:
        return FileFormat.NONE;
    }
  }

  String toExtension() {
    switch (this) {
      case FileFormat.PNG:
        return '.png';
      case FileFormat.JPG:
        return '.jpg';
      case FileFormat.JPEG:
        return '.jpeg';
      case FileFormat.NONE:
      default:
        return ''; // Unknown FileFormat
    }
  }
}
