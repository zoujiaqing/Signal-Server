# Config Documentation

- This is documentation for filling out `sample.yml` and `sample-secrets-bundle.yml` inside `/service/config/`
  - Currently unfinished, but hopefully most of the parts in [Unknown](#unknown-will-get-sorted-into-the-above) will be unnecessary
  - Everything in the [Optional](#optional)/[Unknown](#unknown-will-get-sorted-into-the-above) sections are notes to myself for ironing out kinks in Signal-Server/Signal-Android, and can be ignored for configuration purposes

- [Here](documented-sample.yml) is an example of `sample.yml` with extra comments
- [Here](documented-sample-secrets-bundle.yml) is an example of `sample-secrets-bundle.yml` with added comments

## Dependancies

### Required

[AWS](#aws)
- In `sample.yml`
  - dynamoDbClientConfiguration
  - dynamoDbTables
  - awsAttachments
  - cdn
  - appConfig
- In `sample-secrets-bundel.yml`
  - awsAttachments.accessKey
  - awsAttachments.accessSecret
  - cdn.accessKey
  - cdn.accessSecret
  
[Braintree](#braintree)
- In `sample.yml`
  - braintree

[Google Cloud](#google-cloud)
- In `sample.yml`
  - adminEventLoggingConfiguration
  - gcpAttachments
- In `sample-secrets-bundel.yml`
  - gcpAttachments.rsaSigningKey

[Redis](#redis-notes)
- In `Sample.yml`
  - cacheCluster
  - clientPresenceCluster
  - pubsub
  - pushSchedulerCluster
  - rateLimitersCluster
  - messageCache
  - metricsCluster

[UnidentifiedDelivery](#unidentifieddelivery)
- In `sample.yml`
  - unidentifiedDelivery
- In `sample-secrets-bundle.yml`
  - unidentifiedDelivery.certificate
  - unidentifiedDelivery.privateKey

[ZkConfig](#zkconfig)
- In `sample.yml`
  - zkConfig
  - genericZkConfig
- In `sample-secrets-bundle.yml`
  - zkConfig.serverSecret
  - genericZkConfig.serverSecret

[Certificate Generation](#certificate-generation)
- In `sample.yml`
  - svr2
  - storageService
  - backupService
  - registrationService
- In `sample-secrets-bundle.yml`
  - svr2.userAuthenticationTokenSharedSecret
  - svr2.userIdTokenSharedSecret
  - storageService.userAuthenticationTokenSharedSecret
  - backupService.userAuthenticationTokenSharedSecret

### Optional

Leave untouched:
- In `sample.yml`
  - Datadog
  - Stripe
  - paymentsService 
  - subscription
  - oneTimeDoncations
- In `sample-secrets-bundle.yml`
  - datadog.apiKey
  - stripe.apiKey
  - stripe.idempotencyKeyGenerator
  - braintree.privateKey
  - paymentsService.userAuthenticationTokenSharedSecret
  - paymentsService.fixerApiKey
  - paymentsService.coinMarketCapApiKey

I believe that you can use Signal's url in `Signal-Android` (untested)
- In `sample.yml`
  - recaptcha
  - hCaptcha
  - badges
- In `sample-secrets-bundle.yml`
  - hCaptcha.apiKey

### Unknown (will get sorted into the above)

In `sample.yml`

- DirectoryV2
- apn
- fcm
- remoteConfig  
- artService

In `sample-secrets-bundle.yml`

- directoryV2.client.userAuthenticationTokenSharedSecret
- directoryV2.client.userIdTokenSharedSecret
- apn.signingKey
- fcm.credentials
- remoteConfig.authorizedTokens
- artService.userAuthenticationTokenSharedSecret
- artService.userAuthenticationTokenUserIdSecret
- currentReportingKey.secret
- currentReportingKey.salt

## AWS

### AWS IAM Configuration

- Create an account with AWS

- Go to IAM and create a user with full access (this is definitely not entirely safe but hey, it gets the job done)
  
- Copy the access key and access secret, and paste them into `awsAttachments.accessKey` and `awsAttachments.accessSecret`, and `cdn.accessKey` and `cdn.accessSecret` in [sample-secrets-bundle](/service/config/sample-secrets-bundle.yml)
  
- If you give the IAM user full access, you can reuse the same access key and secret for both buckets

### AWS Environmental Variables

- Specify AWS dependancies with `sudo nano ~/.bashrc`, then add:

```
export AWS_REGION=your-region
export AWS_ACCESS_KEY_ID=key
export AWS_SECRET_ACCESS_KEY=secret
```

- Don't forget to run `. ~/.bashrc`!

- Instead of setting these environmental variables in `.bashrc`, you can create a `secrets.sh` file with the same three lines that `quickstart.sh` calls when starting Signal-Server

### AWS appConfig

- Search for `AWS AppConfig` and hit `Create Application`

- Under `Configuration Profiles and Feature Flags`, hit `CREATE` and choose `Feature Flag`. Enter a name and hit `Freeform configuration profile`

- Select `JSON` as the type of `Feature Flag`

  - Enter the following lines:

```

# By far the most important bit - this section isn't included anywhere in config.yml but necessary for Signal-Server to run    
captcha:
  scoreFloor: 1.0

# I'm not sure if you need the DynamoDB section, but I haven't had time to exhaustively test it
dynamoDbClientConfiguration:
  region: us-west-1 # AWS Region

dynamoDbTables:
  accounts:
    tableName: Accounts
    phoneNumberTableName: Accounts_PhoneNumbers
    phoneNumberIdentifierTableName: Accounts_PhoneNumberIdentifiers
    usernamesTableName: Accounts_Usernames
    scanPageSize: 100
  deletedAccounts:
    tableName: DeletedAccounts
  deletedAccountsLock:
    tableName: DeletedAccountsLock
  issuedReceipts:
    tableName: IssuedReceipts
    expiration: P30D # Duration of time until rows expire
    generator: abcdefg12345678= # random base64-encoded binary sequence
  ecKeys:
    tableName: Keys
  pqKeys:
    tableName: PQ_Keys
  pqLastResortKeys:
    tableName: PQ_Last_Resort_Keys
  messages:
    tableName: Messages
    expiration: P30D # Duration of time until rows expire
  pendingAccounts:
    tableName: PendingAccounts
  pendingDevices:
    tableName: PendingDevices
  phoneNumberIdentifiers:
    tableName: PhoneNumberIdentifiers
  profiles:
    tableName: Profiles
  pushChallenge:
    tableName: PushChallenge
  redeemedReceipts:
    tableName: RedeemedReceipts
    expiration: P30D # Duration of time until rows expire
  registrationRecovery:
    tableName: RegistrationRecovery
    expiration: P300D # Duration of time until rows expire
  remoteConfig:
    tableName: RemoteConfig
  reportMessage:
    tableName: ReportMessage
  subscriptions:
    tableName: Subscriptions
  verificationSessions:
    tableName: VerificationSessions
  
# I'm not convinced that this is required at all, since it is outdated compared to what I have in my config.yml with no problems. You are probably fine to leave it out
registrationService:
  host: registration.example.com
  port: 443
  credentialConfigurationJson: |
    {
      "example": "example"
    }
  secondaryCredentialConfigurationJson: |
    {
      "example": "example"
    }
  identityTokenAudience: https://registration.example.com
  registrationCaCertificate: | # Registration service TLS certificate trust root
    -----BEGIN CERTIFICATE-----
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ/0123456789+abcdefghijklmnopqrstuvwxyz
    AAAAAAAAAAAAAAAAAAAA
    -----END CERTIFICATE-----

# Currently there is alot more that I might need to add here - do I have to add all pem key-related bits?
```

- In the `Environments` tab, select `Create Environment`, enter a name, and ceate the environment

- Do something with versions

- Hit `Create Application` and choose immediately for the timeframe

- Enter the names of the application, environment, and configuration into their sections under `appConfig` in `sample.yml`:

```
appConfig:
  application:
  environment:
  configuration:
```

### AWS Buckets Configuration

- Go to S3 and create the two buckets below (I don't think you need to change any other settings)
  
  - aws-attachments
  
  - cdn
  
### AWS DynamoDb Configuration
  
- Sign into AWS, look up DynamoDb, and make tables of all of the following (not sure what to do about Partition Keys)

- If you change these names, also change them in [sample.yml](/service/config/sample.yml)
  
  - Accounts
  - Accounts_PhoneNumbers
  - Accounts_PhoneNumberIdentifiers
  - Accounts_Usernames
  - DeletedAccounts
  - DeletedAccountsLock
  - IssuedReceipts
    - expiration: P30D
    - generator: abcdefg12345678=
  - Keys
  - PQ_Keys
  - PQ_Last_Resort_Keys
  - Messages
    - expiration: P30D
  - PendingAccounts
  - PendingDevices
  - PhoneNumberIdentifiers
  - Profiles
  - PushChallenge
  - RedeemedReceipts
    - expiration: P30D
  - RegistrationRecovery
    - expiration: P30D
  - RemoteConfig
  - ReportMessage
  - Subscriptions
  - VerificationSessions

## Braintree

- Set the `envrionment` for `braintree` in `sample.yml` to `sandbox`

## Google Cloud

1. Create a Google Cloud accont and enter info / payment

2. Make a project

    2.1. The option should be in the top left, and select `NEW PROJECT`

3. Make a bucket

    3.1. Select `Buckets`, located under `Cloud Storage` inside the left-hand hamburger menu

    3.2. Create a bucket - exact configuration doesn't matter

    3.3. On the `CONFIGURATION` tab inside the bucket, copy the `Cloud Console URL` and paste it into the `domain` section of `gcpAttachments` in `sample.yml`

4. Make a service account and a key

    4.1. Select `Service Accounts`, located under `IAM & Admin` inside hamburger menu

    4.2. In the top middle, select `CREATE SERVICE ACCOUNT`

    4.3. Make sure to add the roles `Owner` and `Cloud KMS CryptoKey Encrypter/Decrypter`

    4.4. Copy the email address of the service account and paste it into the `email` section of `gcpAttachments` in `sample.yml`

    4.5. Select the service account and select the `KEYS` tab

    4.6. Hit `ADD KEY`, then `Create new key` and select `JSON` as the format for the downloaded key

    4.7. Copy and paste the all the contents of the `JSON` into `credentials` under `adminEventLoggingConfiguration` (replacing the existing `key` and curly brackets) in `sample.yml`

5. Make a secret

    5.1. Open `Secret Manager` inside `Security` from the hamburger menu

   5.2. Select `CREATE SECRET` and enter a secret value matching the format from `gcpAttachments.rsaSigningKey` inside `sample-secrets-bundle.yml`

   5.3. Specifically, keep the line breaks and the `-----BEGIN/END PRIVATE KEY-----` (and make sure what is in the Google Cloud Secret and the `rsaSigningKey` match)

## Redis Notes

- Currently the [docker-compose.yml](docker-compose.yml) file has a redis-cluster generated by ChatGPT, using `Localhost` and ports 7000-7002

  - I am currently working both from my MacBook and an Ubuntu desktop, and the MacBook doesn't like this port selection. It could be a firewall or a vpn issue though

## UnidentifiedDelivery

- Signal-Server wants a certificate in `sample-secrets-bundle.yml` that the server generates:

```
java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-0.0.0-SNAPSHOT.jar certificate -ca
```

- Which will output something like this:

```
Public key : aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
Private key: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
```

- Then take the private key and generate a certificate:

```
java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-0.0.0-SNAPSHOT.jar certificate --key <Private key> --id <any string of letters or numbers>
```

- Which will output something like this:

```
Certificate: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
Private key: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
```

- I recommend keeping all the outputs somewhere - I put them, commented out, in [`secrets.sh`](sample-secrets.sh)

- Then fill out `unidentifiedDelivery` in `sample.yml`:

```
unidentifiedDelivery:
  certificate: secret://unidentifiedDelivery.certificate
  privateKey: secret://unidentifiedDelivery.privateKey
  expiresDays: 7 # Probably change this to a much larger number so you don't have to worry about it expiring
```

- And in `sample-secrets-bundle.yml`:

```
unidentifiedDelivery.certificate: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
unidentifiedDelivery.privateKey: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
```

## ZkConfig

- Generate a `public` and `private` value:

```
java -jar -Dsecrets.bundle.filename=service/config/sample-secrets-bundle.yml service/target/TextSecureServer-0.0.0-SNAPSHOT.jar zkparams
```

- Which will output this:

```
Public: a really long string
Private: an even longer string
```

- I (again) recommend putting these values into [`secrets.sh`](sample-secrets.sh)

- Put the output into `zkConfig` in `sample.yml`

```
zkConfig:
  serverPublic: the Public: string
  serverSecret: secret://zkConfig.serverSecret
```

- In `sample-secrets-bundle.yml`

```
zkConfig.serverSecret: the even longer Private: string

genericZkConfig.serverSecret: I'm not sure what goes here
```

## Certificate Generation

- This section is placed out of alphabetical order because it depends on AWS and Google Cloud (yes it annoys me too)

- `svr2` > `svrCaCertificates`, `storageService` > `storageCaCertificates`, `backupService` > `backupCaCertificates`, and `registrationService` > `registrationCaCertificate` all only look for a valid key of any kind

- Using an example copy-pasted key works fine for all of these sections:

```
-----BEGIN CERTIFICATE-----
MIICUTCCAfugAwIBAgIBADANBgkqhkiG9w0BAQQFADBXMQswCQYDVQQGEwJDTjEL
MAkGA1UECBMCUE4xCzAJBgNVBAcTAkNOMQswCQYDVQQKEwJPTjELMAkGA1UECxMC
VU4xFDASBgNVBAMTC0hlcm9uZyBZYW5nMB4XDTA1MDcxNTIxMTk0N1oXDTA1MDgx
NDIxMTk0N1owVzELMAkGA1UEBhMCQ04xCzAJBgNVBAgTAlBOMQswCQYDVQQHEwJD
TjELMAkGA1UEChMCT04xCzAJBgNVBAsTAlVOMRQwEgYDVQQDEwtIZXJvbmcgWWFu
ZzBcMA0GCSqGSIb3DQEBAQUAA0sAMEgCQQCp5hnG7ogBhtlynpOS21cBewKE/B7j
V14qeyslnr26xZUsSVko36ZnhiaO/zbMOoRcKK9vEcgMtcLFuQTWDl3RAgMBAAGj
gbEwga4wHQYDVR0OBBYEFFXI70krXeQDxZgbaCQoR4jUDncEMH8GA1UdIwR4MHaA
FFXI70krXeQDxZgbaCQoR4jUDncEoVukWTBXMQswCQYDVQQGEwJDTjELMAkGA1UE
CBMCUE4xCzAJBgNVBAcTAkNOMQswCQYDVQQKEwJPTjELMAkGA1UECxMCVU4xFDAS
BgNVBAMTC0hlcm9uZyBZYW5nggEAMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEE
BQADQQA/ugzBrjjK9jcWnDVfGHlk3icNRq0oV7Ri32z/+HQX67aRfgZu7KWdI+Ju
Wm7DCfrPNGVwFWUQOmsPue9rZBgO
-----END CERTIFICATE-----
```

- `registrationService` also requires extra configuration with AWS and Google Cloud:

- In AWS, go to `Cognito`

- Select `Create user pool`

- Choose `Federated identity providers` and select `Google` from the options that appear

- Most of the configuration is personal preference, so I went for the least hassle: no MFA, send emails with Cognito, etc

  - In Step 5, make sure to select `Confidential client` under `Initial app client`
  
- Under the `App integration` tab, find the `Cognito Domain` and paste it into `sample.yml` > `registrationService` > `host` without the `https://`

  - If there isn't a domain already listed there, create one (there should be a button on the right of that section) and name it anything
  
- Integrating this Cognito User Pool with Google Cloud (heavily following [this guide](https://cloud.google.com/iam/docs/workload-identity-federation-with-other-clouds))

  - Go to hamburger menu > `IAM and Admin` > `Workload Identity Federation` and hit `CREATE POOL`
  
  - Select `AWS` as the pool's provider
  
  - For `Provider ID`: go to AWS > `Cognito` > the created User Pool > `App integration` > scroll to the bottom to the `App clients and analytics` section and copy the `Client ID`
  
  - For `AWS account ID`: click on your name in the top right, and the dropdown will have your account ID then create the pool
  
  - Create a new service account (hamburger menu > `IAM and Admin` > `Service Accounts`) with the roles: `Admin` and `IAM Workload Identity Pool Admin`
  
  - Back in `Workload Identity Federation` > the created pool, hit `GRANT ACCESS` in the top middle-ish, and select the new service account that was just created
  
  - On the right, select `CONNECTED SERVICE ACCOUNTS` and hit `Download` under `Client Library Config`
  
    - Open the `.json` and make sure that it looks something like this:

```
{
  "type": "external_account",
  "audience": "//iam.googleapis.com/projects/<example_url>",
  "subject_token_type": "gibberish:gibberish",
  "service_account_impersonation_url": "https://iamcredentials.googleapis.com/<example_url>",
  "token_url": "https://sts.googleapis.com/<example_url>",
  "credential_source": {
    "environment_id": "aws1",
    "region_url": "http://169.254.169.254/<example_url>",
    "url": "http://169.254.169.254/<example_url>",
    "regional_cred_verification_url": "https://sts.{region}.amazonaws.com<example-url>"
  }
}
```

  - If everything looks right, paste the `.json` into `sample.yml` > `registrationService` > `credentialConfigurationJson` and possibly also `secondaryCredentialConfigurationJson`