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

- did all of android from madeindra

- added openid permission to GCloud

- Cognito > Identity pools > User Acccess > Identity Providers

- AppConfig:

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