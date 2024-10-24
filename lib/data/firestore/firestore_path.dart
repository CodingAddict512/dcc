class FirestorePath {
  static String driver(String organisation, String driverId) => 'organisations/$organisation/drivers/$driverId';
  static String routes() => 'routes';
  static String route(String routeId) => 'routes/$routeId';
  static String pickup(orderId) => 'registrations/$orderId';
  static String pickups() => 'registrations';
  static String customers() => 'customers';
  static String cars(String transporterId) => 'transporters/$transporterId/cars';
  static String car(String transporterId, String carId) => 'transporters/$transporterId/cars/$carId';
  static String transporter(String transporterId) => 'transporters/$transporterId';
  static String customer(String customerId) => 'customers/$customerId';
  static String locations(String customerId) => 'customers/$customerId/locations/';
  static String location(String customerId, String locationId) => 'customers/$customerId/locations/$locationId';
  static String metadataDefaultLocations() => 'metadata/default-locations';
  static String finalDispositions() => 'metadata/final-dispositions';
  static String metricTypes() => 'metadata/metric-types';
}
