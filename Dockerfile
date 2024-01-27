FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive

# Install build dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl ca-certificates gpg dirmngr gpg-agent jq

# Set up Mono's APT repo
RUN gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list

# Set up CKAN's APT repo
RUN curl -sS -o /usr/share/keyrings/ksp-ckan-archive-keyring.gpg https://raw.githubusercontent.com/KSP-CKAN/CKAN/master/debian/ksp-ckan.gpg \
    && echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/ksp-ckan-archive-keyring.gpg] https://ksp-ckan.s3-us-west-2.amazonaws.com/deb nightly main' | tee /etc/apt/sources.list.d/ksp-ckan.list

# Install the necessary pieces of Mono and CKAN
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        mono-runtime ca-certificates-mono libmono-microsoft-csharp4.0-cil libmono-system-data4.0-cil libmono-system-runtime-serialization4.0-cil libmono-system-transactions4.0-cil libmono-system-net-http-webrequest4.0-cil \
        ckan

# Purge APT download cache, package lists, and logs
RUN apt-get clean \
    && rm -r /var/lib/apt/lists /var/log/dpkg.log /var/log/apt

RUN curl -sf -o ksp-builds.json https://raw.githubusercontent.com/KSP-CKAN/CKAN-meta/master/builds.json
RUN curl -sf -o ksp2-builds.json https://raw.githubusercontent.com/KSP-CKAN/KSP2-CKAN-meta/main/builds.json

ADD mod-installer.sh /usr/local/bin/.

ENTRYPOINT ["/usr/local/bin/mod-installer.sh"]
