# FirecREST MCP Server

[firecrest]: ./../../../development/api/firecrest.md
[firecrest token]: ./../../../development/api/firecrest.md#how-to-get-access-to-the-api
[firecrest revoke]: ./../../../development/api/firecrest.md#revoking-access-tokens
[knowledge mcp]: ./knowledge-mcp.md
[LUMI AI agent guide]: ./../../../development/ai-tools/ai-agent-guide.md
[mcp]: https://modelcontextprotocol.io/docs/getting-started/intro
[terms of use]: https://lumi-supercomputer.eu/termsandpolicies/
[uv]: https://docs.astral.sh/uv/
[uv install]: https://docs.astral.sh/uv/getting-started/installation/

The FirecREST MCP Server is a [Model Context Protocol (MCP)][mcp] server that lets an AI agent on
your workstation transfer files to and from LUMI, manage files there, and submit and monitor
Slurm jobs. It uses the [FirecREST HPC API][firecrest] and your personal FirecREST access token.
The server is an alpha version, so [update it regularly](#installing).

The agent does not get SSH access to LUMI. It can only use the tools that the server offers. A
config file in your local project, `.firecrest-mcp.toml`, sets which paths, project accounts and
partitions these tools accept. On this page, "the config" means this file. See
[What the server protects against](#what-the-server-protects-against) and
[what it does not protect against](#what-the-server-does-not-protect-against).

!!! Warning "Jobs are not limited by the config"
    The config only limits the arguments of the server's tools. It does not limit what a job does
    once it runs. A job script submitted by the agent can read, change or delete any file that you
    can access on LUMI, also outside the paths in the config. Always check the job script and its
    environment variables before the agent submits a job.

Use the server together with the [Knowledge MCP Server][knowledge mcp], which lets the agent
search the LUMI documentation. Without it, an agent may, for example, write CUDA code for LUMI's
AMD GPUs. Add both servers to the agent's configuration, as shown in
[Connecting the agent](#connecting-the-agent).

!!! Warning "Responsibility for running AI agents"
    You are always responsible for the actions of your AI agents. Everything done through the
    FirecREST MCP Server runs under your personal user account. As a LUMI user, you must always
    follow the [LUMI Terms of Use][terms of use].

    Your FirecREST access token gives the same access as your SSH login. Only connect the server
    to an agent running on a system you control, such as your own workstation, and never to an
    agent running on a third-party system. See also the [LUMI AI agent guide][LUMI AI agent guide].

## Use cases

The server is intended for developing code locally and running it on LUMI. For example, you can
ask the agent to:

- upload a directory to LUMI, submit a job script and report when the job starts
- read the output file of a failed job and find the cause of the error
- download result files from LUMI and plot them locally

The server offers the following tools:

| Group | Tools |
|---|---|
| Status | `systems`, `partitions`, `reservations`, `userinfo` |
| Files | `list_files`, `read_file`, `checksum`, `stat`, `chmod`, `chgrp`, `symlink`, `mkdir`, `mv`, `cp`, `rm`, `compress`, `extract` |
| Transfer | `upload`, `download` |
| Jobs | `submit`, `job_info`, `job_metadata`, `cancel_job`, `attach_to_job` |
| Config | `config` |

The `config` tool shows the agent what the [project config](#project-config) allows, so that the
agent does not try paths, accounts or partitions that the tools would refuse.

## Setting up the server

The following steps set up the server for a local project in `/Users/<username>/example-project`.
On LUMI, the project uses the directory `/scratch/project_xxxxxxxxx/<username>/example-project`.
The examples are for Claude Code. Other agents use similar settings.

### Installing

You need [uv][uv] on your workstation. If you do not have it yet, follow the
[uv installation instructions][uv install]. Then install the server as a uv tool:

```bash
git clone <repo-url>    # TODO: repository URL
cd firecrest-mcp
uv tool install .
```

!!! Warning "Alpha version"
    The server is an alpha version. Use it with care. Bug fixes can be released at any time, so
    update your installation regularly:

    ```bash
    cd firecrest-mcp
    git pull
    uv tool install --reinstall .
    ```

### Saving the access token

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

### Creating the project config

Copy the example config into the project directory:

```bash
cd /Users/<username>/example-project
cp path/to/firecrest-mcp/examples/firecrest-mcp.toml .firecrest-mcp.toml
```

Then edit it. A config for testing GPU code could look like this:

```toml
local_paths = ["/Users/<username>/example-project"]

[lumi]
remote_paths = ["/scratch/project_xxxxxxxxx/<username>/example-project"]
accounts = ["project_xxxxxxxxx"]
default_account = "project_xxxxxxxxx"
partitions = ["dev-g", "small-g"]
default_partition = "dev-g"
```

The keys are explained in [Project config](#project-config).

If the project is a Git repository, add `.firecrest-mcp.toml` to `.gitignore`. The config contains
your own paths. If it is in the repository, a commit by someone else could also change what your
agent is allowed to do.

### Connecting the agent

We recommend running the agent in a container and the server outside it. The agent can then only
access the files you mount into the container, and not your token or other credentials.

=== "Agent in a container (recommended)"

    Start the server in the project directory, outside the container:

    ```bash
    cd /Users/<username>/example-project
    FIRECREST_URL=https://api.lumi.csc.fi/v1 firecrest-mcp --transport http
    ```

    The server listens on `127.0.0.1:8000` until you stop it with Ctrl+C.

    !!! Warning "Do not expose the server"
        The server does not ask for a password. Any process on your workstation can connect to the
        server's port and use the tools with your token, within the limits of the config.

        By default, the server only accepts connections from your own workstation. Never start it
        with `--host 0.0.0.0`. The server then accepts connections from other machines too, and
        anyone on the same network, for example the same Wi-Fi, could use the tools with your
        token.

    Mount the project into the container at the same path as on your workstation. The agent and
    the server then use the same paths for local files. The server only listens on the
    workstation's `127.0.0.1`, and you need to forward its port into the container. For example,
    with Podman:

    ```bash
    podman run --network pasta:-T,8000 <other options> <image> <agent command>
    ```

    On macOS, you do not need to forward the port with Podman.

    Inside the container, add the FirecREST MCP Server and the Knowledge MCP Server to the agent's
    MCP configuration. For Claude Code, see also `examples/claude-code/mcp-http.json` in the
    repository:

    ```json
    {
        "mcpServers": {
            "firecrest-lumi": {
                "type": "http",
                "url": "http://127.0.0.1:8000/mcp"
            },
            "lumi-knowledge": {
                "type": "http",
                "url": "https://lumi-aif-agents.2.rahtiapp.fi/mcp"
            }
        }
    }
    ```

    Write `127.0.0.1` and not `localhost`. The server only listens on IPv4, and the agent may try
    the IPv6 address first.

=== "Agent on the workstation"

    !!! Note
        If the agent runs directly on your workstation, it can access your FirecREST token and
        other credentials. We strongly recommend running the agent in a container instead.

    Add the FirecREST MCP Server and the Knowledge MCP Server to the agent's global MCP
    configuration. They are then available wherever you start the agent, and the agent starts the
    FirecREST MCP Server itself. For Claude Code, see also
    `examples/claude-code/mcp-stdio.json` in the repository:

    ```json
    {
        "mcpServers": {
            "firecrest-lumi": {
                "type": "stdio",
                "command": "firecrest-mcp",
                "env": {
                    "FIRECREST_URL": "https://api.lumi.csc.fi/v1"
                }
            },
            "lumi-knowledge": {
                "type": "http",
                "url": "https://lumi-aif-agents.2.rahtiapp.fi/mcp"
            }
        }
    }
    ```

    If your token is not in `~/.firecrest-token`, add for example
    `"FIRECREST_TOKEN_PATH": "~/secrets/firecrest-token"` to `env`.

    Always start the agent from the project directory, so that the server finds the project's
    config.

### Restricting the agent

An agent could use its other tools to edit `.firecrest-mcp.toml` and give itself more access, or
to read your token. The server tells the agent not to do this, but an agent may ignore that, for
example after a prompt injection. If your agent has permission settings, use them to block writes
to the config and reads of the token file.

For Claude Code, add the following to `~/.claude/settings.json`, merged with your existing
settings, and start a new session:

```json
{
    "permissions": {
        "deny": ["Edit(.firecrest-mcp.toml)", "Read(~/.firecrest-token)"],
        "ask": ["mcp__firecrest-lumi__submit", "mcp__firecrest-lumi__attach_to_job"]
    },
    "sandbox": {
        "filesystem": {
            "denyWrite": ["//**/.firecrest-mcp.toml"],
            "denyRead": ["~/.firecrest-token"]
        }
    }
}
```

The `deny` rules stop the Edit and Write tools from changing the config in any project, and the
Read tool from reading the token. The `sandbox` entries do the same for Bash commands, but only
when the sandbox is enabled. If you use `FIRECREST_TOKEN_PATH`, put that path here instead. An
agent may still find other ways around these settings.

The `ask` rules make Claude Code ask for your approval before the agent submits a job or runs a
command in a running job. Before you approve a job, check the script and the `env_vars`. If the
agent passes the job script as a file path, the approval prompt only shows the path, so open the
file. The rules use the server name `firecrest-lumi` from the MCP configuration. If you named the
server differently, change the rules too.

### Testing the setup

Start the agent in the project directory and ask it, for example, what it is allowed to do on
LUMI. The agent should call the `config` tool and list the paths, accounts and partitions from
your config. Then ask it to list the files in the project's directory on LUMI. If the agent
reports that the token is missing or has expired, save a new token as described in
[Saving the access token](#saving-the-access-token).

## Project config

Every local project needs its own `.firecrest-mcp.toml`. The server reads it from the directory it
was started in, on every call, so changes apply without restarting the agent. The tools refuse
anything that the config does not allow. `local_paths` is a top-level key, and all other keys go
in the `[lumi]` table. A path is allowed if it is listed or lies below a listed path.
`examples/firecrest-mcp.toml` in the repository lists all keys.

| Key | What it limits | Advice |
|---|---|---|
| <code style="white-space: nowrap">remote_paths</code> | Paths on LUMI that the file, transfer and job tools accept | Use a subdirectory of your own, not the whole project directory, which also contains the data of other project members. |
| <code style="white-space: nowrap">local_paths</code> | Paths on your workstation that `upload` sends from, `download` writes to and `submit` reads job scripts from | Use absolute paths. Do not add your home directory, `~/.ssh` or other places with credentials. |
| <code style="white-space: nowrap">accounts</code><br><code style="white-space: nowrap">default_account</code> | Projects that `submit` and the tools that may start a transfer job bill | If you are a member of several projects, list only the project that the local project belongs to. |
| <code style="white-space: nowrap">partitions</code><br><code style="white-space: nowrap">default_partition</code> | Partitions that `submit` uses | Start with small partitions such as `dev-g`, and add larger ones once the code works. |
| <code style="white-space: nowrap">reservations</code> | Reservations that `submit` accepts | Add a reservation only while you need it, for example during a course. |
| <code style="white-space: nowrap">groups</code> | Groups that `chgrp` can set | Without the key, the agent cannot change the group of any file. |

The server never sends the token file, the config file, `.mcp.json`, `.claude/` or `.git/`, but the
agent can send any other file in `local_paths` to LUMI.

`submit` always passes the account and the partition to Slurm, and they override the `#SBATCH`
lines in the job script. If the agent does not give an account or a partition, the default is used.
If there is no default either, the tool fails. The tools that may start a transfer job are `mv`,
`cp`, `rm`, `compress`, `extract`, `upload` and `download`.

The config is invalid if it contains an unknown key, for example a misspelled one, if
`default_account` is not in `accounts`, or if `default_partition` is not in `partitions`. Every
tool that reads an invalid config fails until you fix it. The status tools, and the job tools
other than `submit`, also work without a config.

## What the server protects against

The checks in the server and the config prevent, for example, the following:

| Problem | Protection |
|---|---|
| The agent deletes files outside your project directory on LUMI with the file tools | File tools only accept paths in `remote_paths` |
| The agent uploads private files, such as SSH keys | `upload` only accepts paths in `local_paths`, and never sends the token, the config, `.mcp.json`, `.claude/` or `.git/` |
| A job is billed to the wrong project | `submit` always passes an account from `accounts` |
| The agent submits a large job before the code is tested | `submit` only uses partitions from `partitions` |
| The agent cancels another user's jobs | Job tools only work on your own jobs |
| The agent shares files with the wrong group | `chgrp` only sets groups from `groups` |

## What the server does not protect against

The config does not limit what a job does once it runs. Job scripts submitted with `submit`, and
commands run with `attach_to_job`, have all of your permissions. A job script can, for example:

- delete files anywhere in `/scratch/project_xxxxxxxxx`, not only in `remote_paths`
- copy files from your home directory into `remote_paths`, from where the agent can download them
- submit further jobs with `sbatch`, to any partition and billed to any of your projects
- set a reservation that is not in `reservations`, if the agent does not pass one

The agent can also set environment variables for the job with the `env_vars` argument of `submit`.
For example, `PATH`, `PYTHONPATH` or `BASH_ENV` can make the job run other code than the script
shows. Check the job script and its environment variables before you approve a job. See
[Restricting the agent](#restricting-the-agent).

In addition, the server does not check where symlinks on LUMI lead, and the file and transfer tools
can start transfer jobs in the `interactive` partition, even if it is not in `partitions`.
