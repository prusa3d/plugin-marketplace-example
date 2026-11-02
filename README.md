# Plugin Marketplace example

[![Check](https://github.com/prusa3d/plugin-marketplace-example/actions/workflows/check.yml/badge.svg)](https://github.com/prusa3d/plugin-marketplace-example/actions/workflows/check.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A minimal PrusaSlicer Lua plugin that publishes itself to the
[Prusa Plugin Marketplace](https://plugin-marketplace.prusa3d.com) from GitHub Actions with
[prusa3d/plugin-marketplace-publish](https://github.com/prusa3d/plugin-marketplace-publish).
Copy it as the starting point for your own plugin.

> [!NOTE]
> The Prusa Plugin Marketplace is in beta.

*Hello Marketplace* puts a cube on the plate with a word embossed on top.

## What's inside

```
.
├── .github/workflows/
│   ├── check.yml      builds and signs the bundle on every push (throwaway key, no upload)
│   └── release.yml    signs and publishes the plugin when you publish a GitHub release
└── hello/             the plugin bundle: everything in it ships
    ├── manifest.json  id, version, author, required APIs
    └── main.lua       the plugin
```

## Make it yours

1. **Author profile.** Sign in to the [marketplace](https://plugin-marketplace.prusa3d.com) and
   become an author. Put the author id from *Profile* into `hello/manifest.json` as `author`
   (this example carries Prusa Research's).
2. **Plugin id.** Change `id` to an id in a namespace you own: `io.github.<your-account>.<plugin>`
   works without any setup, a domain of yours (`com.example.<plugin>`) after you prove it in the
   author console under *Namespaces*. The id never changes after the first release. Ids with
   "prusa" in them are reserved for Prusa Research.
3. **Signing key.** Create an RSA key pair and register `public_key.pem` in the author console
   under *Signing keys*:

   ```bash
   openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
   openssl rsa -pubout -in private_key.pem -out public_key.pem
   ```

   Keep `private_key.pem` out of the repository (`.gitignore` already ignores `*.pem`) and back it
   up somewhere safe, such as a password manager. Whoever has it can sign plugins as you; if it
   leaks, revoke it under *Signing keys* and register a new one.
4. **Trusted publisher.** In the author console under *Trusted publishing*, add your plugin id,
   `<owner>/<repository>`, the workflow file `release.yml` and the environment `release`. That is
   the only credential the marketplace needs: there is no password or API key to store.
5. **Release environment.** In the repository settings, create the environment `release`, allow
   only tags `v*` to deploy to it, add yourself as a required reviewer, and store the key there
   instead of as a repository secret:

   ```bash
   gh secret set PRUSA_SLICER_PLUGIN_MARKETPLACE_SIGNING_KEY --env release < private_key.pem
   ```

   Then a workflow pushed on some branch cannot read the key, and every publish waits for you.

## Release

Bump `version` in `hello/manifest.json`, commit, and publish a GitHub release whose tag is that
version:

```bash
gh release create v0.2.0 --title "Hello Marketplace 0.2.0" --notes "Rounder cube"
gh release create v0.3.0-beta.1 --prerelease --notes "Try the new font"   # beta channel
```

The release notes become the changelog. The run waits until a reviewer of the `release`
environment approves it. Every release is scanned and reviewed before it is public;
the run's summary links to it in the author console.

For more plugins in one repository, required reviewers and all inputs, see the
[action's README](https://github.com/prusa3d/plugin-marketplace-publish#readme).

## Contributing

This repository is a template, so it takes [issues](https://github.com/prusa3d/plugin-marketplace-example/issues)
rather than pull requests. Changes to the publishing action itself are welcome in
[prusa3d/plugin-marketplace-publish](https://github.com/prusa3d/plugin-marketplace-publish).

## License

[MIT](LICENSE)
