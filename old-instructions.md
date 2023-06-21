# Old Signal Deployment Instructions

### [Aqnouch's Guide](https://github.com/aqnouch/Signal-Setup-Guide)

- Complete instructions for 2021 Signal
- Signal-Server notes very old
- Signal-Android relavent?
  - Has instructions on certificates and other setup bits

### [Madeindra's Guide](https://github.com/madeindra/signal-setup-guide)

- Much more info and newer than Aqnouch's. It mentions alot of steps that I haven't covered

### Notes

- Signal-Android needs to manually enable certificates in order to connect to Signal-Server on `localhost`
- There are a bunch more steps to follow [here](https://github.com/madeindra/signal-setup-guide/tree/master/signal-android)

- All postgres dependancies have been migrated to DynamoDB in AWS

- `curl -X POST/HOST <domain>
- `logcat` in Android Studio
- pain