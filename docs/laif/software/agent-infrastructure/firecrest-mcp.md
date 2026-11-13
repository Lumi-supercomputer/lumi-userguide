# FirecREST MCP Server

[firecrest]: ./../../../development/api/firecrest.md
[firecrest token]: ./../../../development/api/firecrest.md#how-to-get-access-to-the-api
[firecrest revoke]: ./../../../development/api/firecrest.md#revoking-access-tokens
[knowledge mcp]: ./knowledge-mcp.md
[LUMI AI agent guide]: ./../../../development/ai-tools/ai-agent-guide.md
[mcp]: https://modelcontextprotocol.io/docs/getting-started/intro
[pyfirecrest]: ./../../../development/api/firecrest.md#pyfirecrest
[terms of use]: https://lumi-supercomputer.eu/termsandpolicies/
[uv]: https://docs.astral.sh/uv/

The FirecREST MCP Server is a [Model Context Protocol (MCP)][mcp] server that lets an AI agent
work on LUMI through the [FirecREST HPC API][firecrest]. You run it on your own workstation with
[uv][uv], and it uses your personal FirecREST access token. This is different from the
[Knowledge MCP Server][knowledge mcp], which is a public service.

With the server, an agent on your workstation can:

- check the status of LUMI, for example partitions and reservations
- list, read and manage files on LUMI
- upload and download files between your workstation and LUMI
- submit Slurm jobs, and check or cancel your own jobs

The agent does not get SSH access. It can only use the tools the server offers, and a config file
in each project sets which paths, accounts, partitions, reservations and groups the tools accept.
Note that `submit` and `attach_to_job` can still run any command with your permissions. See
[Risks](#risks).

!!! Warning "Alpha version"
    The FirecREST MCP Server is an alpha version. Use it with care. Bug fixes can be released at
    any time, so [update your installation](#installation) regularly.

!!! Warning "Responsibility for running AI agents"
    You are always responsible for the actions of your AI agents. Everything done through the
    FirecREST MCP Server runs under your personal user account. As a LUMI user, you must always
    follow the [LUMI Terms of Use][terms of use].

    Your FirecREST access token gives the same access as your SSH login. Only connect the server
    to an agent running on a system you control, such as your own workstation, and never to an
    agent running on a third-party system. See also the [LUMI AI agent guide][LUMI AI agent guide].

## Tools

The server offers a subset of the [PyFirecREST][pyfirecrest] v2 client as tools. Every tool
checks its arguments before calling FirecREST, most of them against the
[project config](#project-config).

| Group | Tools |
|---|---|
| Status | `systems`, `partitions`, `reservations`, `userinfo` |
| Files | `list_files`, `read_file`, `checksum`, `stat`, `chmod`, `chgrp`, `symlink`, `mkdir`, `mv`, `cp`, `rm`, `compress`, `extract` |
| Transfer | `upload`, `download` |
| Jobs | `submit`, `job_info`, `job_metadata`, `cancel_job`, `attach_to_job` |

There is also a config tool that shows the agent which parts of the config apply to it. The job
query and cancel tools only work on your own jobs.

Some tools accept less than their PyFirecREST equivalents:

- `chmod` only takes numeric permissions, such as `750`. Symbolic forms such as `u+x` are
  rejected.
- `compress` always compresses the whole given path. You cannot select files by a pattern.
- There is no `chown`, because only root can change a file's owner. Use `chgrp` to change a
  file's group.

## Installation

You need [uv][uv] on your workstation. Install the server as a uv tool:

```bash
git clone <repo-url>    # TODO: repository URL
cd firecrest-mcp
uv tool install .
```

!!! Warning "Keep the server up to date"
    Pull the latest changes and reinstall the tool regularly:

    ```bash
    cd firecrest-mcp
    git pull
    uv tool install --reinstall .
    ```

## Setup

### Access token

Get a [FirecREST access token][firecrest token] and save it in `~/.firecrest-token`. The server
only uses the file if nobody else can read it:

```bash
touch ~/.firecrest-token
chmod 600 ~/.firecrest-token
nano ~/.firecrest-token   # paste the token and save
```

Tokens are valid for 24 hours, and the server refuses expired tokens. The server reads the file
on every request, so to refresh the token you only need to overwrite the file. To keep the token
somewhere else, set `FIRECREST_TOKEN_PATH`. If a token may have been exposed,
[revoke it][firecrest revoke].

### Project config

Every local project needs its own `.firecrest-mcp.toml`, which sets what the agent working in
that project may do on LUMI. Copy the example config from the cloned repository into the project
directory and edit it. For example, for a project called `example-project`:

```bash
cd /Users/<username>/example-project
cp path/to/firecrest-mcp/examples/firecrest-mcp.toml .firecrest-mcp.toml
```

The server reads the config from the directory it was started in. It reads the file on every
call, so changes apply without restarting the agent. Anything the file does not explicitly allow
is denied, and unknown keys are errors. `local_paths` is a top-level list, and the other keys go
in the `[lumi]` table:

| Key | Purpose |
|---|---|
| <code style="white-space: nowrap">local_paths</code> | Paths on your workstation that `upload`, `download` and `submit` may use. Use absolute paths, such as `/Users/<username>/example-project`. |
| <code style="white-space: nowrap">remote_paths</code> | Paths on LUMI that the file, transfer and job tools may use. Use a subdirectory of your own, such as `/scratch/project_xxxxxxxxx/<username>/example-project`. |
| <code style="white-space: nowrap">accounts</code><br><code style="white-space: nowrap">default_account</code> | Project accounts for `submit` and for the tools that may start a transfer job (`mv`, `cp`, `rm`, `compress`, `extract`, `upload`, `download`). If the agent does not give an account, the default is used. If there is no default either, the tool fails. |
| <code style="white-space: nowrap">partitions</code><br><code style="white-space: nowrap">default_partition</code> | Partitions for `submit`. If the agent does not give a partition, the default is used. If there is no default either, the tool fails. |
| <code style="white-space: nowrap">reservations</code> | Reservations for `submit` |
| <code style="white-space: nowrap">groups</code> | Groups that `chgrp` may set on a file, for example to share it with project members |

A path is allowed if it is listed or lies below a listed path. If `default_account` is not in
`accounts`, or `default_partition` is not in `partitions`, the config is invalid and every tool
that reads it fails.

`submit` always passes an account and a partition to Slurm. These override the `#SBATCH` lines in
the job script.

All keys are listed in `examples/firecrest-mcp.toml`. The status tools, and the job tools other
than `submit`, also work without a config.

### Risks

The config cannot stop everything. Keep the following in mind before giving the agent a token:

- Restrict `remote_paths` to a subdirectory of your own, such as
  `/scratch/project_xxxxxxxxx/<username>/example-project`, and not a whole project directory.
  Project directories are shared, so the agent could otherwise read, change or delete other
  project members' data.
- Do not put your home directory, `~/.ssh` or other places with credentials in `local_paths`. The
  server only protects the token file, the config file, `.mcp.json`, `.claude/` and `.git/`. The
  agent can send anything else in `local_paths` to LUMI.
- `submit` does not check the job script, and `attach_to_job` can run commands in a running job.
  Both run with all of your permissions, also outside `remote_paths`. A job script can also set a
  reservation that is not in `reservations` if the agent does not pass one.
- The server does not check where symlinks on LUMI lead, so a link inside `remote_paths` can
  point outside it.
- The file and transfer tools can start transfer jobs in FirecREST's transfer partition
  (`interactive` on LUMI), even if it is not in `partitions`.

## Connecting the agent

There are two ways to run the server:

- **stdio** (default): the agent starts the server itself, based on its MCP configuration.
- **HTTP** (recommended): the agent runs in a container and connects to the server running
  outside it. The agent can then only reach the files you mount into the container, and not your
  token or other credentials.

The examples below are for Claude Code. Other agents use similar settings. Ready-made entries are
in the repository's `examples/claude-code/` directory.

### stdio

!!! Note
    With stdio, the agent runs directly on your workstation and can reach your FirecREST token
    and other credentials. We strongly recommend running the agent in a container and using
    [HTTP](#http) instead.

Add the server to your agent's global MCP configuration. The entry starts the server with
`firecrest-mcp`, which is the version you installed with `uv tool install .`. For Claude Code
(from `examples/claude-code/mcp-stdio.json`):

```json
{
    "mcpServers": {
        "firecrest-lumi": {
            "type": "stdio",
            "command": "firecrest-mcp",
            "env": {
                "FIRECREST_URL": "https://api.lumi.csc.fi/v1"
            }
        }
    }
}
```

If your token is not in `~/.firecrest-token`, add for example
`"FIRECREST_TOKEN_PATH": "~/secrets/firecrest-token"` to `env`.

Always start the agent from the project directory, so that the server finds the project's config.

### HTTP

Start the server outside the container, in the project directory:

```bash
cd /Users/<username>/example-project
FIRECREST_URL=https://api.lumi.csc.fi/v1 firecrest-mcp --transport http
```

The server listens on `127.0.0.1:8000` until you stop it with Ctrl+C.

Mount the project into the container at the same path as on your workstation, so that a path
points to the same file on both sides. Because the server only listens on the workstation's
`127.0.0.1`, you need to forward its port into the container. For example, with Podman:

```bash
podman run --network pasta:-T,8000 <other options> <image> <agent command>
```

On macOS, the forwarding appears to be unnecessary.

Inside the container, add the server to the agent's MCP configuration. For Claude Code (from
`examples/claude-code/mcp-http.json`):

```json
{
    "mcpServers": {
        "firecrest-lumi": {
            "type": "http",
            "url": "http://127.0.0.1:8000/mcp"
        }
    }
}
```

Write `127.0.0.1` and not `localhost`. The server only listens on IPv4, and the agent may try the
IPv6 address first. If the agent reaches the server under another name, such as
`host.docker.internal`, start the server with `--allowed-host <name>`.

!!! Warning "Do not expose the server"
    Any process on your workstation can connect to the server's port and use the tools with your
    token, within the limits of the config. Never start the server with `--host 0.0.0.0`, because
    then other machines could do the same.

## Restricting the agent

With its own tools, an agent could edit `.firecrest-mcp.toml` to give itself more access, or read
your token. The server tells the agent not to do this, but an agent may ignore that, for example
after a prompt injection. If your agent has permission settings, use them to block writes to the
config and reads of the token file.

For Claude Code, add the following to `~/.claude/settings.json`, merged with your existing
settings, and start a new session:

```json
{
    "permissions": {
        "deny": ["Edit(.firecrest-mcp.toml)", "Read(~/.firecrest-token)"]
    },
    "sandbox": {
        "filesystem": {
            "denyWrite": ["//**/.firecrest-mcp.toml"],
            "denyRead": ["~/.firecrest-token"]
        }
    }
}
```

The `permissions` rules stop the Edit and Write tools from changing the config in any project,
and the Read tool from reading the token. The `sandbox` entries do the same for Bash commands,
but only when the sandbox is enabled. If you use `FIRECREST_TOKEN_PATH`, put that path here
instead. These settings make it harder for the agent to get more access, but not impossible.
