class APIErrorCodeHandler{
  static int RequestTimeout=408;
  static int UnAuthorized=401;
  static int TooManyRequests=429;
  static int InternalServerError=500;
  static int BadGateway=502;
  static int ServiceUnavailable=503;
  static int GatewayTimeout=504;
  static int LoginTimeout=440;
  static int ClientClosedRequest =460;
  static int WebServerReturnedUnknownError=520;
  static int WebServerIsDown=521;
  static int ConnectionTimedOut=522;
  static int OriginIsUnreachable=523;
  static int TimeoutOccurred=524;
  static int SSLHandshakeFailed=525;
  static int RailgunError=527;
  static int NetworkReadTimeoutError=598;
  static int NetworkConnectTimeoutError=599;
}