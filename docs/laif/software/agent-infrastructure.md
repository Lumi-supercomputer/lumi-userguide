# Infrastructure for AI agents

[Agents.md]: https://github.com/lumi-ai-factory/laifs-agent-env/blob/main/opencode/AGENTS.md
[github repository]: https://github.com/lumi-ai-factory/laifs-agent-env
[LUMI AI agent guide]: ./../../development/ai-tools/ai-agent-guide.md
[opencode blogpost]: https://lumi-supercomputer.eu/connecting-opencode-to-lumi/
[opencode documentation config]: https://opencode.ai/docs/config/ 
[opencode json]: https://github.com/lumi-ai-factory/laifs-agent-env/blob/main/opencode/opencode.json
[opencode website]: https://opencode.ai
[singularity]: ./../../software/containers/singularity.md
[terms of use]: https://lumi-supercomputer.eu/termsandpolicies/

The LUMI AI Factory develops software infrastructure that supports the use of AI agents for
LUMI-related tasks. The current offering comprises a containerized [agent environment](#agent-environment)
for using the OpenCode coding agent on LUMI
and an [MCP server](#mcp-server) that provides agents access to relevant user documentation.

## Agent environment

The LUMI AI Factory agent environment offers [Singularity containers][singularity] for using agents directly on LUMI to assist with using the system.
Currently, we provide a container to use the open-source, terminal-based [OpenCode][opencode website] AI coding agent on LUMI. For more information on OpenCode, see the LUMI AI Factory blog post on [connecting OpenCode to a vLLM instance running on LUMI][opencode blogpost].
The source code of the agent environment is made available in [the LUMI AI Factory agent environment GitHub repository][github repository].

!!! Warning "Responsibility for running AI agents"
    The user is always responsible for the actions of their AI agents. Understand that any command run by your agent is executed under your personal user account. As a LUMI user, you must always follow the [LUMI Terms of Use][terms of use].

    Read also the [LUMI AI agent guide][LUMI AI agent guide] and the below [must read section](#must-read).


### Must read
Please understand the following points before using the agent environment:

- **Open endpoint:** The agent environment uses an open endpoint running outside of LUMI by default so it possibly shares your data openly with that external, but you can configure it to use [your own model](#use-with-your-own-model).
- **Access to your files:** The current working directory `$pwd` and all subdirectories are accessible to the agent environment by default, but you need to grant permission to write to the directory.
- **Experimental:** The agent environment is experimental and it might change rapidly. Do not rely on its outputs.

### How to use

We recommend using opencode with [your own model](#use-with-your-own-model), but you can try it out with the open endpoint.

```shell
# Load relevant modules
ml load Local-LAIF opencode

# Start opencode. ATTENTION! This gives opencode access to your 
# current working directory $pwd and its subdirectories.
opencode /path/to/project/dir
```

You can provide opencode access to more directories. In the following example we give it access to `/path/to/project/dir`.

```shell
# Bind more directories than $pwd (optional)
export SINGULARITY_BIND=$SINGULARITY_BIND,/path/to/project/dir

opencode /path/to/project/dir
```

### Use with your own model
In order to use the model you need to create a `opencode.json` configuration file. You can find the default configuration [`opencode.json` in the agent environment repository][opencode json]. You can find documentation on how to write your own `configuration.json` in the [OpenCode documentation][opencode documentation config].

!!! Info "Place your `configuration.json` in a mounted folder"
    The `configuration.json` needs to be in a folder accessible by OpenCode. You could either explictly mount the folder that contains it (remember that this gives OpenCode also access to other files in that folder) or place the file in your current working directory `$pwd`.

### Capabilities
The opencode application has the following capabilities by default:

- It can read and write to the mounted directories (`$pwd`) and subdirectories by default but it will ask for permission to execute any commands.
- It has access to the [LUMI AI Factory MCP Server](#mcp-server) to answer questions about LUMI with more accuracy.
- It can use the following Slurm commands: `sacct`, `sbatch`, `scancel`, `sinfo`, `squeue`, and `srun`. 
- It uses the following [`Agents.md`][Agents.md] file to provide additional context about the LUMI to the model to improve the performance.


## MCP server

The LUMI AI Factory provides a public
[Model Context Protocol (MCP)](https://modelcontextprotocol.io/docs/getting-started/intro) server,
which can be found at <https://lumi-aif-agents.2.rahtiapp.fi/mcp>. The server features a tool
called `retrieve_docs`, which allows agents to search a regularly-updated knowledge base of LUMI
documentation. The search functionality is implemented using an embedding model that is run locally
on the MCP server host.

Access to this tool allows AI agents to, e.g., answer questions about LUMI with more accuracy and
write code that takes into account LUMI's particular system architecture and software environment.

The knowledge base is comprised of the following sources:

* LUMI Docs (this site)
* [LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide)

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

