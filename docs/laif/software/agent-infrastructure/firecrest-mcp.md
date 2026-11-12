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

The LUMI AI Factory provides a [Model Context Protocol (MCP)][mcp] server that gives AI agents
access to LUMI through the [FirecREST HPC API][firecrest]. Unlike the
[Knowledge MCP Server][knowledge mcp], it is not a public service: you run it locally on your own
workstation with [uv][uv], and it acts on LUMI using your personal FirecREST access token.

With the server, an agent on your workstation can work on LUMI for you without SSH access. It can:

- check the status of LUMI, such as partitions and reservations,
- list, read and manage files on LUMI,
- upload and download files between your workstation and LUMI,
- submit Slurm jobs, and check or cancel your own jobs.

The agent can only use the server's tools, and a per-project config file limits which paths,
accounts, partitions, reservations and groups they accept. The config does not limit everything:
`submit` and `attach_to_job` can still run any command with your permissions. See
[Risks](#risks).

!!! Warning "Alpha version"
    The FirecREST MCP Server is an alpha version. Use it with care. Bug fixes may be released at
    any time, so [update your installation](#installation) regularly.

!!! Warning "Responsibility for running AI agents"
    The user is always responsible for the actions of their AI agents. Any action taken through
    the FirecREST MCP Server is executed under your personal user account. As a LUMI user, you
    must always follow the [LUMI Terms of Use][terms of use].

    Your FirecREST access token gives the same access as your SSH login. Only connect the server
    to an agent running on a system you control, such as your own workstation. Do not use it with
    agents running on third-party systems. Read also the [LUMI AI agent guide][LUMI AI agent guide].

## Tools

The server offers a subset of the [PyFirecREST][pyfirecrest] v2 client as tools. Each tool checks
its arguments before it calls FirecREST, most of them against the [project config](#project-config).

| Group | Tools |
|---|---|
| Status | `systems`, `partitions`, `reservations`, `userinfo` |
| Files | `list_files`, `read_file`, `checksum`, `stat`, `chmod`, `chgrp`, `symlink`, `mkdir`, `mv`, `cp`, `rm`, `compress`, `extract` |
| Transfer | `upload`, `download` |
| Jobs | `submit`, `job_info`, `job_metadata`, `cancel_job`, `attach_to_job` |

A config tool also shows the agent which parts of the config apply to it. The job query and
cancel tools only act on your own jobs.

Some tools are more limited than in PyFirecREST: `chmod` takes only a numeric mode of three or
four octal digits, such as `750`; `compress` has no pattern argument; and there is no `chown`,
only `chgrp`.

## Installation

With [uv][uv] installed on your workstation, install the server as a uv tool:

```bash
git clone <repo-url>    # TODO: repository URL
cd firecrest-mcp
uv tool install .
```

!!! Warning "Keep the server up to date"
    Regularly pull the latest changes in the repository and reinstall the tool:

    ```bash
    cd firecrest-mcp
    git pull
    uv tool install --reinstall .
    ```

## Setup

### Access token

Get a [FirecREST access token][firecrest token] and save it in `~/.firecrest-token`. The file must
be readable only by you, or the server will not use it:

```bash
touch ~/.firecrest-token
chmod 600 ~/.firecrest-token
nano ~/.firecrest-token   # paste the token and save
```

Tokens are valid for 24 hours, and the server refuses an expired token. It reads the token on
every request, so you can refresh it by overwriting the file. To store the token elsewhere, set
`FIRECREST_TOKEN_PATH`. If a token may have been exposed, [revoke it][firecrest revoke].

### Project config

Each local project gets its own `.firecrest-mcp.toml`, which limits what the agent working in
that project can do on LUMI. Copy the example config into the project directory and edit it.
For example, for a project called `example-project`:

```bash
cd /Users/<username>/example-project
cp path/to/firecrest-mcp/examples/firecrest-mcp.toml .firecrest-mcp.toml   # the cloned repository
```

The server reads the config from the directory it starts in, on every call, so changes take
effect without restarting the agent. Anything the file does not explicitly allow is denied, and
unknown keys are errors. `local_paths` is a top-level list. The other keys go in the `[lumi]`
table:

| Key | Purpose |
|---|---|
| <code style="white-space: nowrap">local_paths</code> | Paths on your workstation that `upload`, `download` and `submit` may use. Use absolute paths, such as `/Users/<username>/example-project`. |
| <code style="white-space: nowrap">remote_paths</code> | Paths on LUMI that the file, transfer and job tools may use. Use a subdirectory of your own, such as `/scratch/project_xxxxxxxxx/<username>/example-project`. |
| <code style="white-space: nowrap">accounts</code><br><code style="white-space: nowrap">default_account</code> | Project accounts for `submit` and for the file and transfer tools that may start a transfer job (`mv`, `cp`, `rm`, `compress`, `extract`, `upload`, `download`). The default is used when the agent does not give an account, and the tool fails if neither is given. |
| <code style="white-space: nowrap">partitions</code><br><code style="white-space: nowrap">default_partition</code> | Partitions for `submit`. The default is used when the agent does not give a partition, and the tool fails if neither is given. |
| <code style="white-space: nowrap">reservations</code> | Reservations for `submit` |
| <code style="white-space: nowrap">groups</code> | Groups that `chgrp` may set on a file, e.g. to share it with project members |

A path is allowed if it is an entry of the list or lies below one. If `default_account` is not in
`accounts`, or `default_partition` is not in `partitions`, the config is invalid and every tool
that reads it fails.

`submit` always passes an account and a partition to Slurm, which override the job script's
`#SBATCH` lines.

See `examples/firecrest-mcp.toml` for every key. Status tools, and job tools other than submit,
work without a config.

### Risks

The config does not stop the agent from doing the following, so take them into account before
giving it a token:

- Restrict `remote_paths` to a subdirectory of your own, such as
  `/scratch/project_xxxxxxxxx/<username>/example-project`, not a whole project directory. Project
  directories are shared, so otherwise the agent can read, modify or delete data of other project
  members.
- Do not list your home directory or other places with credentials, such as `~/.ssh`, in
  `local_paths`. The server protects only the token file, the config file, `.mcp.json`, `.claude/`
  and `.git/`. The agent can send anything else in `local_paths` to LUMI.
- The `submit` tool does not check the job script, and `attach_to_job` can run commands in a
  running job. Both run with all of your permissions, including outside `remote_paths`. A job can
  also set a reservation that is not in `reservations` if the agent does not pass one.
- The server does not resolve symlinks on LUMI, so a link inside `remote_paths` can lead outside
  it.
- The file and transfer tools may start transfer jobs in FirecREST's transfer partition
  (`interactive` on LUMI), even if `partitions` does not list it.

## Connecting the agent

The server can run in two ways:

- **stdio** (default): the agent starts the server from its MCP configuration.
- **HTTP** (recommended): the agent runs in a container and connects to a server running outside
  it. The agent can then only reach the files you mount into the container, not your token or
  other credentials.

The examples below use Claude Code's MCP configuration format. Other agents use similar fields,
so adapt them to your agent. The repository's `examples/claude-code/` directory has ready-made
entries.

### stdio

!!! Note
    With stdio, the agent runs on your workstation, where it can reach your FirecREST token and
    other credentials. Running the agent in a container and connecting over [HTTP](#http) is
    strongly recommended, so that it can only reach the files you mount into it.

Add the server to your agent's global MCP configuration. It starts the server with
`firecrest-mcp`, the version installed with `uv tool install .`. For example, in Claude Code
(see `examples/claude-code/mcp-stdio.json`):

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

To keep the token elsewhere, add `"FIRECREST_TOKEN_PATH": "~/secrets/firecrest-token"` to `env`.

Start the agent from the project directory, so that the server reads that project's config.

### HTTP

Start the server outside the container, from the project directory:

```bash
cd /Users/<username>/example-project
FIRECREST_URL=https://api.lumi.csc.fi/v1 firecrest-mcp --transport http
```

The server listens on `127.0.0.1:8000` until you stop it with Ctrl+C.

Start the container with the project mounted at the same path as on your workstation, so that
paths mean the same file on both sides. The server listens only on the workstation's
`127.0.0.1`, so forward its port into the container. For example, with Podman:

```bash
podman run --network pasta:-T,8000 <other options> <image> <agent command>
```

On macOS, the forwarding appears to be unnecessary.

In the container, add the server to the agent's MCP configuration. For example, in Claude Code
(see `examples/claude-code/mcp-http.json`):

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

Use `127.0.0.1`, not `localhost`. The server listens only on IPv4, and the agent may try the IPv6
address first. Other agents use similar settings, so adapt them to your agent. If your setup
gives the agent another name for the server, such as `host.docker.internal`, allow it when
starting the server with `--allowed-host`.

!!! Warning "Do not expose the server"
    Any process on your workstation can connect to the server's port and use the tools with your
    token, within the limits of the config. Do not start the server with `--host 0.0.0.0`, as
    other machines could then do the same.

## Restricting the agent

An agent could widen its own access by editing `.firecrest-mcp.toml`, or read your token, with its
own tools. The server instructs the agent not to, but an agent may ignore this, for example after
a prompt injection. If your agent has permission settings, deny it writes to the config and
reads of the token file. For example, in Claude Code, merge the following into
`~/.claude/settings.json` and start a new session:

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

The `permissions` rules stop the Edit and Write tools from changing the config in any project, and
the Read tool from reading the token. The `sandbox` entries stop Bash commands from doing either,
but only where the sandbox is enabled. If you set `FIRECREST_TOKEN_PATH`, use that path instead. This makes it harder for the agent to widen its access, not impossible.
