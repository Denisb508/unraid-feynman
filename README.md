# Feynman for Unraid

Unofficial Docker image and Unraid Community Applications template for [Feynman](https://github.com/advaitpaliwal/feynman), the open-source AI research agent by Advait Paliwal.

This repository packages the upstream Feynman npm release into a small Debian/Node container and starts the browser-based **Feynman Science Workbench**.

## Unraid quick start

The intended image is:

```text
ghcr.io/denisb508/unraid-feynman:latest
```

Default WebUI:

```text
http://UNRAID-IP:8787
```

Persistent paths:

| Container path | Suggested Unraid path | Purpose |
|---|---|---|
| `/config` | `/mnt/user/appdata/feynman/config` | Feynman state, settings, sessions and credentials |
| `/workspace` | `/mnt/user/appdata/feynman/workspace` | Research projects, outputs, papers and notes |

## Security

The Unraid template defaults to `FEYNMAN_NO_AUTH=true` so the WebUI opens directly from the Unraid Docker page. Upstream Feynman documents `--no-auth` for trusted local-only use.

**Do not expose port 8787 directly to the Internet.** If remote access is required, put Feynman behind an authenticated reverse proxy/VPN, or set `FEYNMAN_NO_AUTH=false`. With authentication enabled, Feynman generates a token URL at startup; retrieve that URL from the container logs.

## First run

1. Start the container.
2. Open `http://UNRAID-IP:8787`.
3. Complete the Feynman Workbench onboarding.
4. Configure a model provider supported by Feynman. Provider state is persisted under `/config`.

For local OpenAI-compatible model servers, configure the provider from Feynman and use the server address reachable from the container. Do not use `localhost` unless the model server runs inside the same container.

## Docker Compose

```bash
docker compose up -d
```

The included `compose.yaml` stores persistent data below `./data/`.

## Command-line use

You can invoke Feynman commands instead of starting the Workbench:

```bash
docker run --rm \
  -v "$PWD/config:/config" \
  -v "$PWD/workspace:/workspace" \
  ghcr.io/denisb508/unraid-feynman:latest \
  feynman doctor
```

## Updates

GitHub Actions resolves the current published version of `@advaitpaliwal/feynman`, builds the container, and publishes these GHCR tags:

- `latest`
- the upstream Feynman version, for example `0.3.49`
- `sha-...` for the packaging commit

A scheduled weekly build checks for newer upstream npm releases.

## Community Applications

The Community Applications template is located at:

```text
templates/feynman.xml
```

The repository also contains `ca_profile.xml` in the format expected by the current Unraid Community Applications submission workflow.

Before submitting to Community Applications:

1. Ensure the GHCR package is public.
2. Verify the raw `TemplateURL` works.
3. Validate and scan the repository in the Unraid Community Applications `/submit` flow.
4. Test a clean install on Unraid.

## Upstream

- Feynman: https://github.com/advaitpaliwal/feynman
- Feynman website/docs: https://feynman.is
- Upstream license: MIT

This packaging repository is unofficial and is not affiliated with the upstream Feynman project or Unraid.
