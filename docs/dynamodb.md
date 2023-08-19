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