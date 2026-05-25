# Infrastructure for AI agents

The LUMI AI Factory develops software infrastructure that supports the use of AI agents for
LUMI-related tasks.

## Agent environment




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

