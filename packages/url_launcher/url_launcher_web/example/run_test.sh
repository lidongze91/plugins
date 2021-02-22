#!/usr/bin/bash
if pgrep -lf chromedriver > /dev/null; then
  echo "chromedriver is running."

  flutter pub get

  echo "(Re)generating mocks."
  flutter pub run build_runner build --delete-conflicting-outputs

  if [ $# -eq 0 ]; then
    echo "No target specified, running all tests..."
    find integration_test/ -iname *_test.dart | xargs -n1 -i -t flutter drive -d web-server --web-port=7357 --browser-name=chrome --driver=test_driver/integration_test_driver.dart --target='{}'
  else
    echo "Running test target: $1..."
    set -x
    flutter drive -d web-server --web-port=7357 --browser-name=chrome --driver=test_driver/integration_test_driver.dart --target=$1
  fi

  else
    echo "chromedriver is not running."
    echo "Please, check the README.md for instructions on how to use run_test.sh"
fi

