# marqius-wkhtmltopdf for macOS on Apple silicon, compiled on Linux with zig as the other programs
# are (no Mac needed: the program links only libSystem, libiconv and libcharset, which every Mac
# has, and the linker signs it ad hoc as Apple's does). Built by .github/workflows/release.yml
# from the engine's source:  docker buildx build -f macos.Dockerfile -o type=local,dest=out <engine>
FROM rust:1-alpine AS base
RUN apk add --no-cache musl-dev zig \
 && cargo install --locked cargo-zigbuild \
 && rustup target add aarch64-apple-darwin
WORKDIR /src
COPY Cargo.toml Cargo.lock ./
COPY vendor ./vendor
RUN mkdir src && echo 'fn main() {}' > src/main.rs && cargo fetch --locked && rm -rf src
COPY src ./src

FROM base AS build
# set only by a run that times a code change (release.yml's recompile): it makes the compile run again
ARG RECOMPILE
# the libraries marqius uses stay compiled in a cache between runs (release.yml keeps it), as in the
# engine's Dockerfile.wkhtmltopdf; only marqius itself is compiled again
# (marqius's own files and the vendored crates are touched first: COPY can give changed files older
# times than the kept build, and cargo would then keep the old program)
# Thin LTO, as the engine's Linux and Windows programs are: marqius in 16 parts, each library in one,
# and the step's open-file limit raised to its hard limit for zig's linker (see Dockerfile.wkhtmltopdf)
RUN --mount=type=cache,target=/usr/local/cargo/registry,sharing=locked \
    --mount=type=cache,id=marqius-wkhtmltopdf-target-macos,target=/src/target \
    { du -sh /src/target /usr/local/cargo/registry; ls /src/target/aarch64-apple-darwin/release/.fingerprint | wc -l; } 2>&1 | sed 's/^/KEPT /'; \
    find src vendor -type f -exec touch {} + && \
    ulimit -n "$(ulimit -Hn)" && \
    CARGO_PROFILE_RELEASE_STRIP=true CARGO_PROFILE_RELEASE_LTO=thin CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16 \
    cargo zigbuild -v --config 'profile.release.package."*".codegen-units=1' \
      --release --locked --features wkhtmltopdf-edition --target aarch64-apple-darwin \
 && install -D target/aarch64-apple-darwin/release/marqius /out/marqius-wkhtmltopdf

FROM scratch
COPY --from=build /out/marqius-wkhtmltopdf /marqius-wkhtmltopdf
