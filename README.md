# archivebox-railway

Wrapper image for [ArchiveBox](https://github.com/ArchiveBox/ArchiveBox) (v0.9.77) on [Railway](https://railway.com).

On a one-domain host, upstream's default security mode (`auto`) turns on subdomain routing and answers every write, the API token
request and the whole REST API with `403 control plane disabled on this host`. It also publishes the snapshot index to anonymous
visitors (`PUBLIC_INDEX=True`), generates a new `SECRET_KEY` at every start (every sign-in is dropped on a redeploy) and listens on
a fixed port 5797 instead of Railway's injected `PORT`. The wrapper pins `SERVER_SECURITY_MODE=safe-onedomain-nojsreplay`, closes
the public index and public add, takes the administrator password and the secret key from variables, derives `BASE_URL` from the
Railway domain, and listens on `PORT`. Upstream's entrypoint is kept: it repairs Railway's root-owned `/data` mount and drops to
the `archivebox` user.

- Variables: `ADMIN_PASSWORD` (required, at least 8 characters), `SECRET_KEY` (required). Administrator username `admin`.
- Optional variables: `BASE_URL` (custom domain, `https://archive.example.com`), `PUBLIC_INDEX=True` to publish the snapshot list
- Volume: `/data` (SQLite index, archived pages, logs)
- Health: `GET /health/`

Published as `ghcr.io/bon5co/archivebox-railway`. Template: see the Railway marketplace listing.
