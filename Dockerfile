# ArchiveBox wrapper for Railway. Upstream defaults to SERVER_SECURITY_MODE=auto, which on a one-domain host (Railway) answers
# every write, sign-in token request and API call with 403 "control plane disabled on this host", publishes the snapshot index to
# anonymous visitors (PUBLIC_INDEX=True), generates a new SECRET_KEY at every start, and listens on a fixed :5797 instead of
# Railway's PORT. The wrapper pins a one-domain security mode with the control plane on, closes the public index and public add,
# takes the secret key and administrator password from variables, and listens on PORT.
# upstream: ArchiveBox/ArchiveBox
FROM archivebox/archivebox:0.9.77@sha256:f63170551ec48d7aa087c71e2d093156dbf4b4ed8680e2f97f22483e3bc71e55

COPY boot.sh /usr/local/bin/railway-boot.sh
RUN chmod +x /usr/local/bin/railway-boot.sh

ENV PORT=8080 \
    ADMIN_USERNAME=admin \
    SERVER_SECURITY_MODE=safe-onedomain-nojsreplay \
    PUBLIC_INDEX=False \
    PUBLIC_ADD_VIEW=False
EXPOSE 8080
# upstream's ENTRYPOINT (dumb-init + docker_entrypoint.sh: repairs the root-owned /data mount, drops to the archivebox user) is kept;
# only the CMD changes, so boot.sh runs as the archivebox user.
CMD ["/usr/local/bin/railway-boot.sh"]
