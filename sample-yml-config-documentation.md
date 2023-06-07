Sample.yml Config Documentation
=================

Dependancies
-----------------

- Required:

  - [AWS](#aws-iam-configuration)
  
  - [GCP](#gcp-configuration)

  - [Redis](#redis-notes)

- Optional, just make sure the values aren't empty (`unset` should work)

  - Braintree

  - Datadog

  - Stripe
  
  - paymentsService
  
  - subscription
  
  - oneTimeDoncations
  
- Unknown (will get sorted into the above)
  
  - DirectoryV2
  
  - svr2
  
  - apn
  
  - fcm
  
  - unidentifiedDelivery
  
  - recaptcha
  
  - hCaptcha
  
  - storageService
  
  - backupService
  
  - zkConfig
  
  - genericZkConfig
  
  - appConfig
  
  - remoteConfig
  
  - artService
  
  - badges
  
  - registrationService

- [Here is an example of sample.yml with some shorthand comments](sample-with-added-comments.yml) (unfinished)

General / Misc
-----------------

- Specify your AWS region with `sudo nano ~/.bashrc`, add `export AWS_REGION=your-region` to the end of the file, then run `. ~/.bashrc`

AWS IAM Configuration
-----------------

- Create an account with AWS

- Go to IAM and create a user with full access (this is definitely not entirely safe but hey, it gets the job done)
  
- Copy the access key and access secret, and paste them into `awsAttachments.accessKey` and `awsAttachments.accessSecret`, and `cdn.accessKey` and `cdn.accessSecret` in [sample-secrets-bundle](/service/config/sample-secrets-bundle.yml)
  
- If you give the IAM user full access, you can reuse the same access key and secret for both buckets

AWS Buckets Configuration
-----------------

- Go to S3 and create the two buckets below (I don't think you need to change any other settings)
  
  - aws-attachments
  
  - cdn
  
AWS DynamoDb Configuration
-----------------
  
- Sign into AWS, look up DynamoDb, and make tables of all of the following(not sure what to do about Partition Keys)

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

GCP Configuration
-----------------

1. Make a Google Cloud account and two projects

  1.1. Create an account with Google Cloud - you can you a pre-existing Google account, but you will have to add a payment method in order to use Google Cloud

  1.2. Make a new project for the bucket, and another for the encryption key

2. Create a service account to manage the encryption key

  2.1. Select the bucket project

  2.2. In the left navigation panel, select `Service Accounts` under `IAM & ADMIN`

  2.3. In the middle top, select `Create Service Account`

  2.4. Under `Grant this service account access to project`, add the role `Owner` and the role `Cloud KMS CryptoKey Encrypter/Decrypter`

3. Create the bucket

   3.1. In the left navigation panel, select `Buckets` under `Cloud Storage`

  3.2. Hit `CREATE` in the top middle of the screen
  
  3.3. Configure it (I think the config doesn't super matter outside of how it handles keys), and select the region you want to use - I used `us (multiple regions in the United States)`

4. Create the encryption key

  4.1. Switch to the key project

  4.2. Select `Key Management` from the left sidebar nested inside `Security`

  4.3. A screen asking to enable `KMS` should appear - hit `ENABLE`, wait for it to load, then reload the browser

  4.4. Once here, there should be a button in the top middle of the sceen labelled `Create Key ring`

  4.5. Create a key ring with a matching region to the bucket
  
  4.6. The rest of the default configuration should be fine, so create the key

5. Linking the KMS created key to the bucket

  5.1. Switch back to the bucket project

  5.2. Click on the created bucket, and open the tab `CONFIGURATION`

  5.3. Near the bottom, there is a line: `Encryption Type`. Hit the edit button

  5.4. Select the option for `Customer Managed Key (CMEK)`, and choose the key from the drop-down
  
  5.5. The key probably won't show up by default, so hit `SWITCH PROJECT` and select the key project. The key should appear now
  
  5.6 `SAVE`

6. Downloading the generated key

- I think you have to get 3rd party software to generate a key for you, then create a new key and import it (that way you can also generate a json on your own)
- Notes to self: install `gcloud` tools, and create a key and keyring using the cli
  - Acutally, this might not work either :(

Redis Notes
-----------------

- Currently the [docker-compose.yml](docker-compose.yml) file has a redis-cluster generated by ChatGPT, using `Localhost` and ports 7000-7002

  - I am currently working both from my MacBook and an Ubuntu desktop, and the MacBook doesn't like this port selection. It could be a firewall or a vpn issue though.