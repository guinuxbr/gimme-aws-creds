FROM python:3.13-alpine AS build

WORKDIR /opt/gimme-aws-creds

COPY . .

ENV PACKAGES="cargo gcc libffi-dev libgcc musl-dev openssl-dev python3-dev"

RUN apk --update add $PACKAGES \
    && pip install --upgrade pip setuptools-rust build \
    && pip install . \
    && apk del --purge $PACKAGES

FROM python:3.13-alpine AS runtime

WORKDIR /opt/gimme-aws-creds

COPY --from=build /opt/gimme-aws-creds /opt/gimme-aws-creds
COPY --from=build /usr/local/bin/gimme-aws-creds* /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/gimme-aws-creds"]
