# Infrastructure for AI agents

[AGENTS.md]: https://github.com/lumi-ai-factory/laifs-agent-env/blob/main/config/AGENTS.md
[github repository]: https://github.com/lumi-ai-factory/laifs-agent-env
[LUMI AI agent guide]: ./../../development/ai-tools/ai-agent-guide.md
[opencode blogpost]: https://lumi-supercomputer.eu/connecting-opencode-to-lumi/
[opencode documentation config]: https://opencode.ai/docs/config/ 
[opencode json]: https://github.com/lumi-ai-factory/laifs-agent-env/blob/main/config/opencode/opencode.json
[opencode website]: https://opencode.ai
[singularity]: ./../../software/containers/singularity.md
[terms of use]: https://lumi-supercomputer.eu/termsandpolicies/

The LUMI AI Factory develops software infrastructure that supports the use of AI agents for
LUMI-related tasks. The current offering comprises a containerized [agent environment](#agent-environment)
for using the OpenCode coding agent on LUMI
and an [MCP server](#mcp-server) that provides agents access to relevant user documentation.

## Agent environment

The LUMI AI Factory agent environment is a [containerized environment][singularity] for running AI
coding agents on LUMI in a more secure manner. Currently, we provide a container for using the
open-source, terminal-based [OpenCode][opencode website] AI coding agent. For more information on
OpenCode, see the LUMI AI Factory blog post on
[connecting OpenCode to a vLLM instance running on LUMI][opencode blogpost]. The source code of the
agent environment is available in a public [GitHub repository][github repository].

!!! Warning "Responsibility for running AI agents"
    The user is always responsible for the actions of their AI agents. Understand that any command
    run by your agent is executed under your personal user account. As a LUMI user, you must always
    follow the [LUMI Terms of Use][terms of use].

    Read also the [LUMI AI agent guide][LUMI AI agent guide] and the below
    [must read section](#must-read).

### Must read

Please ensure you understand the following points before using the agent environment:

- **Data privacy:** OpenCode uses the third-party
  [OpenCode Zen](https://opencode.ai/docs/zen/) model endpoint by default, which is hosted by
  [Anomaly Innovations Inc.](https://anoma.ly/), the company that maintains OpenCode. If you use
  models from this endpoint, be aware that any data that you enter or is read from your working
  directory will be sent to the company hosting the endpoint. Consider configuring OpenCode to use
  a different endpoint, for example a [custom endpoint](#using-a-custom-endpoint).
- **Data security:** Your current working directory (`$PWD`) and any subdirectories are accessible
  inside the environment. Your
  [home directory is not accessible](https://docs.sylabs.io/guides/latest/user-guide/bind_paths_and_mounts.html#contain-containall),
  with the exception of
  [certain directories](https://github.com/lumi-ai-factory/laifs-agent-env/blob/main/modulefiles/lumi-aif-agents/1.0.lua),
  where OpenCode looks for configuration files and stores data.
- **Tool use**: The [default configuration file][opencode json] included in the environment
  enforces prompting the user for [permission to use any tools](https://opencode.ai/docs/tools/),
  including reading and writing, except for the [LUMI AIF MCP server](#mcp-server).
- **Experimental status:** The agent environment is experimental and may evolve rapidly. It is
  recommended to check the GitHub repository for any changes to agent capabilities and permissions
  before use.

### How to use

The default OpenCode Zen model endpoint does not require the user to authenticate, but free usage
is limited. It is recommended to use OpenCode with a [custom endpoint](#using-a-custom-endpoint).

```shell
# Load relevant modules
module load Local-LAIF lumi-aif-agents

# Start opencode
#
# NB! This gives OpenCode access to your current
# working directory, as well as any subdirectories.
#
opencode
```

Your home directory, as well as any project directories under, e.g., `/scratch`,
are not mounted in the container environment by default. If you wish OpenCode to have access to
directories that are not under your current working directory, you can bind mount them by appending
them to the `SINGULARITY_BIND` environment variable.

```shell
# Bind mount additional directories (optional)
export SINGULARITY_BIND=$SINGULARITY_BIND,/path/to/dir1,/path/to/dir2

opencode /path/to/dir1
```

To find out more about accessing directories inside containers, see the SingularityCE documentation on
[bind paths and mounts](https://docs.sylabs.io/guides/latest/user-guide/bind_paths_and_mounts.html).

### Capabilities and limitations

OpenCode has the following capabilities and limitations inside the agent environment:

* Mounted directories can be read and written to, but the default configuration file
  shipped with the container enforces prompting for permission before executing any commands.
* OpenCode has access to the [LUMI AI Factory MCP Server](#mcp-server) for retrieving context
  information that helps it write code that takes into account LUMI's computing environment.
* The [AGENTS.md][AGENTS.md] file that ships with the container provides basic runtime context,
  such as the limitations of login nodes and the Lustre file system.
* Slurm commands are not available inside the container. We are working on implementing this
  feature in a secure manner.

### Using a custom endpoint

You can configure a custom model endpoint by creating an `opencode.json` configuration file, e.g.,
in your current working directory. See OpenCode's
[config precedence order](https://opencode.ai/docs/config/#locations) for more information.

The agent environment container ships with [a default configuration][opencode json].
You can find documentation on how to write your own `opencode.json` in the
[OpenCode documentation][opencode documentation config].

!!! Info "Store your `opencode.json` in a mounted directory"
    The `opencode.json` file needs to be in a directory accessible inside the environment. It is
    recommended to store the file either in the current directory (project-specific) or under
    `~/.config/opencode/` (global), both of which are mounted in the environment and searched by
    OpenCode by default.

## MCP server

The LUMI AI Factory provides a public
[Model Context Protocol (MCP)](https://modelcontextprotocol.io/docs/getting-started/intro) server,
which can be found at <https://lumi-aif-agents.2.rahtiapp.fi/mcp>. The server offers the
following tools:

- `retrieve_docs` allows agents to search an up-to-date knowledge base of LUMI documentation. The
  search functionality is implemented using an embedding model that runs locally on the MCP server
  host. Access to this tool allows AI agents to, e.g., answer questions about LUMI with more
  accuracy and write code that takes into account LUMI's particular system architecture and
  software environment. The knowledge base is comprised of LUMI Documentation (this site) and the
  [LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide).
- `get_service_status` uses the [LUMI Service Status](https://status.lumi.csc.fi/) server to
  provide status information on LUMI and related services. This includes node availability,
  response time, and any outages due to maintenance or incidents.

### Test the server

To understand how the server works, it is possible to test it manually using, e.g.,
the [FastMCP CLI](https://gofastmcp.com/cli/overview).

```bash
# Install FastMCP Python package
pip install fastmcp

# List available tools
fastmcp list https://lumi-aif-agents.2.rahtiapp.fi/mcp

# Call the retrieve_docs tool with query string
# "how to use pytorch on lumi" and return top 2 matches
fastmcp call https://lumi-aif-agents.2.rahtiapp.fi/mcp \
    retrieve_docs 'query=how to use pytorch on lumi' 'k=2'
```

### Connect a client

MCP servers can be used with a variety of platforms, such as IDEs (e.g., VS Code), CLI coding
assistants (e.g., OpenCode) and web-based chat interfaces (e.g., Claude Web).

* [Add and manage MCP servers in VS Code](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)
* [MCP Servers | OpenCode](https://opencode.ai/docs/mcp-servers)
* [Third party connectors with remote MCP - Claude.ai Documentation](https://claude.com/docs/connectors/custom/remote-mcp)

An example `opencode.json` config file is provided for using the LUMI AIF MCP server in
OpenCode.

```json
{
    "$schema": "https://opencode.ai/config.json",
    "mcp": {
        "lumi-aif-server": {
            "type": "remote",
            "url": "https://lumi-aif-agents.2.rahtiapp.fi/mcp"
        }
    }
}
```

