# Runtime

- The `runtime` folder organizes together all the dependencies required for running Signal-Server
- Inside `scripts`, you can run `bash runtime.sh` which will bundle all dependencies into `runtime` and copy in your `personal-config`. Make sure you have `secets.sh`, as EC2 doesn't like `secrets.env`
- The goal of this system is to only use one Signal-Server.jar, so that way you can generate certificates for it once (already done in `runtime.sh`), put it in your `config-secrets-bundle.yml`, and forget about it