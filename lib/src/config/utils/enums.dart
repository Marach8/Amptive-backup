enum AmptiveHomeScreenPages { marach, emmanuel, nnanna }


enum LogLevel {
  debug,
  info,
  warn,
  error;

  int get value => switch (this) {
    LogLevel.debug => 500,
    LogLevel.info  => 800,
    LogLevel.warn  => 900,
    LogLevel.error => 1000,
  };
}

enum ProfileTabType { scheduled, ended, shows, events }