  accounts:
    tableName: Accounts - `U`
    phoneNumberTableName: Accounts_PhoneNumbers `P`
    phoneNumberIdentifierTableName: Accounts_PhoneNumberIdentifiers `P`
    usernamesTableName: Accounts_Usernames - `U`
    scanPageSize: 100

  issuedReceipts:
    tableName: IssuedReceipts `B`
    expiration: P30D # Duration of time until rows expire
    generator: abcdefg12345678= # random base64-encoded binary sequence

  ecKeys: - `S`
    tableName: Keys

  pqKeys: - `P`
    tableName: PQ_Keys

  pqLastResortKeys:
    tableName: PQ_Last_Resort_Keys - `U` - sort - `DK`

  messages:
    tableName: Messages
    expiration: P30D # Duration of time until rows expire

  pendingAccounts:
    tableName: PendingAccounts - `P`

  pendingDevices: - `P` - uncertain
    tableName: PendingDevices

  phoneNumberIdentifiers:
    tableName: PhoneNumberIdentifiers

  profiles:
    tableName: Profiles

  pushChallenge:
    tableName: PushChallenge

  redeemedReceipts:
    tableName: RedeemedReceipts - `A`
    expiration: P30D # Duration of time until rows expire

  registrationRecovery:
    tableName: RegistrationRecovery
    expiration: P300D # Duration of time until rows expire

  remoteConfig:
    tableName: RemoteConfig

  verificationSessions:
    tableName: VerificationSessions - `K`

## Not Needed Yet

  deletedAccounts:
    tableName: DeletedAccounts

  deletedAccountsLock: - `P`
    tableName: DeletedAccountsLock

  reportMessage:
    tableName: ReportMessage

  subscriptions:
    tableName: Subscriptions

### Notes

- Followed the full [Signal-Android guide from Madeindra](https://github.com/madeindra/signal-setup-guide/tree/master/signal-android)

  - For the step with `ndk-build`, install it from Android Studio > `Tools` > `SDK Manager` > `SDK Tools` tab > check `NDK (Side by side)` and `CMake`
  
  - `ndk-build` is a mess, you will probably need to call the script, like this:

```
"$HOME"/Android/Sdk/ndk/25.2.9519653/build/ndk-build
```

  - And possibly also set an evironmental variable `NDK_PROJECT_PATH=/path/to/project`
  - If you get an error about not being able to find `Android.mk`, you might need to set that variable in your `Android.mk`

  - The new `libnative-utils.so` will already be in their directories
  
  - Make sure to put the `UnidentifiedDelivery` into that section of your `build.gradle` (and make sure it is from your current server, and matches the one in `config.yml`)

- For this section below, you'll need to add an `openid` permission to the specific IAM account in GCloud (just search `openid` and there should only be one result)

```
credentialConfigurationJson: |
  {
    "example": "example"
  }
```

- In GCloud, go to `APIs & Services` and create a new `OAuth Client ID`

  - Enter in the new package name from Firebase and the SHA1 from your `debug.store` (probably located in `.android`)

- Cognito > Identity pools > User Acccess > Identity Providers > Select Google and enter the credentials from above

- Go to HCaptcha and get a sitekey and secret. put the secret in `config-secrets-bundle.yml` and the sitekey in AppConfig:

```
captcha:
  scoreFloor: 1.0
  allowHCaptcha: true
  hCaptchaSiteKeys:
    challenge:
      - sitekey
    registration:
      - sitekey
```

**registration-service**

- You'll need to run on bare metal until I update the docker-container

- There are naming conflicts, reclone the signalapp registration-service and git checkout `33d2447`

- Add this to your `src/main/resources/application.yml`

```
grpc:
  server:
    ssl:
      enabled: true
      cert-chain: classpath:fullchain.pem
      private-key: classpath:privkey.pem
```

- Which will let the server recognize your https requests. I'm not sure what certs the server looks at, so replace the contents of `signal.pem` with the contents of `chain.pem`, then add `fullchain.pem` and `privkey.pem` to `registration-service` and to `src/main/resources/` and make sure your NGINX is configured to work with the gRPC server


And update your DynamoDb with the ones above

If all went well, there should be no errors on Signal-Server when running the app, but in `adb` there are errors about trying to send a sms OTP