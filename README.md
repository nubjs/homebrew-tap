# homebrew-tap

The official [Homebrew](https://brew.sh/) tap for [nub](https://github.com/nubjs/nub), a fast TypeScript runtime and package manager that augments Node. Use it to install nub on macOS and Linux with `brew`.

## Install

```sh
brew install nubjs/tap/nub
```

Or tap first, then install:

```sh
brew tap nubjs/tap
brew install nub
```

## Upgrade

A Homebrew-installed nub updates through Homebrew, not `nub upgrade`. The `nub upgrade` self-updater detects the Homebrew install and defers to brew, so run:

```sh
brew upgrade nub
```

## Uninstall

```sh
brew uninstall nub
brew untap nubjs/tap
```

## Other install methods

Homebrew is one of several ways to install nub. The install script and npm package are documented at [github.com/nubjs/nub](https://github.com/nubjs/nub):

```sh
curl -fsSL https://nubjs.com/install.sh | bash
```

```sh
npm install -g --ignore-scripts=false @nubjs/nub
```

## About the formula

`Formula/nub.rb` is generated and bumped automatically by the [nubjs/nub](https://github.com/nubjs/nub) release pipeline on each tagged release. Do not hand-edit it; changes belong in the release tooling upstream.
