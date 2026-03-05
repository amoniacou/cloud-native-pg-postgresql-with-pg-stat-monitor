ARG PG_VERSION=17.6
ARG PGSM_VERSION=2.1.1
ARG DEB_VERSION=standard-trixie
ARG IMAGE_VARIANT=${PG_VERSION}-${DEB_VERSION}

FROM ghcr.io/cloudnative-pg/postgresql:${IMAGE_VARIANT}
ARG PGSM_VERSION
USER 0
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,sharing=locked,target=${HOME}/.cache \
    --mount=type=tmpfs,target=/tmp \
    --mount=type=tmpfs,target=/var/tmp \
    set -ex \
    && mkdir -p /var/lib/apt/lists/partial \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       percona-pg-stat-monitor${PG_MAJOR}=${PGSM_VERSION} \
    && apt-get clean
USER 26
