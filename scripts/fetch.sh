#!/bin/sh
# Install the pinned tui-do release into bin/, verified against the SHA-256 pinned here.
set -eu
version="v1.0.2"
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)              triple="aarch64-apple-darwin"
                             want="bb4af95bf02ed3f622b2b8c4ffd57a4b2447d30d2144673a86b9052a1e781e98" ;;
  Linux-x86_64)              triple="x86_64-unknown-linux-musl"
                             want="e5b9544ae847dabba99d7ba4ef7185a469026cf5ce4fb7302d21a54afe6cd02a" ;;
  Linux-aarch64|Linux-arm64) triple="aarch64-unknown-linux-musl"
                             want="6100cd42884d555d3560c6bd2676ad8001a7ef39b4fcd490f9873cf2229f447d" ;;
  *) echo "herdr-tuido: no tui-do $version release for $(uname -s) $(uname -m)" >&2; exit 1 ;;
esac
name="tui-do-$version-$triple"
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
curl -fsSL -o "$tmp/t.tgz" "https://github.com/sjwasko/tui-do/releases/download/$version/$name.tar.gz"
if command -v sha256sum >/dev/null 2>&1; then got=$(sha256sum "$tmp/t.tgz" | awk '{print $1}')
else got=$(shasum -a 256 "$tmp/t.tgz" | awk '{print $1}'); fi
[ "$got" = "$want" ] || { echo "herdr-tuido: checksum mismatch for $name ($got)" >&2; exit 1; }
tar -xzf "$tmp/t.tgz" -C "$tmp"
mkdir -p "$root/bin"
install -m 0755 "$tmp/$name/tui-do" "$root/bin/tui-do"
echo "herdr-tuido: installed tui-do $version ($triple)"
