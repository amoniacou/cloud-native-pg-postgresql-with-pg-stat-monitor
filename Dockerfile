ARG PG_VERSION=17.6
ARG DEB_VERSION=standard-trixie
ARG IMAGE_VARIANT=${PG_VERSION}-${DEB_VERSION}

FROM ghcr.io/cloudnative-pg/postgresql:${IMAGE_VARIANT}
ARG PG_VERSION
USER 0
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/tmp \
    set -ex \
    && PG_MAJOR=$(echo "${PG_VERSION}" | cut -d. -f1) \
    && mkdir -p /var/lib/apt/lists/partial \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       curl gnupg2 lsb-release \
    && curl -fsSL https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb \
       -o /tmp/percona-release.deb \
    && dpkg -i /tmp/percona-release.deb \
    && percona-release setup ppg-${PG_MAJOR} \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       percona-pg-stat-monitor${PG_MAJOR} \
    && apt-get purge -y --auto-remove curl gnupg2 lsb-release \
    && apt-get clean
USER 26
