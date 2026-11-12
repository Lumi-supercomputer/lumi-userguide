# Knowledge MCP Server

[fastmcp cli]: https://gofastmcp.com/cli/overview
[lumi ai guide]: https://github.com/Lumi-supercomputer/LUMI-AI-Guide
[lumi service status]: https://status.lumi.csc.fi/
[mcp]: https://modelcontextprotocol.io/docs/getting-started/intro
[mcp claude]: https://claude.com/docs/connectors/custom/remote-mcp
[mcp opencode]: https://opencode.ai/docs/mcp-servers
[mcp vscode]: https://code.visualstudio.com/docs/copilot/customization/mcp-servers

The LUMI AI Factory provides a public [Model Context Protocol (MCP)][mcp] server, which can be
found at <https://lumi-aif-agents.2.rahtiapp.fi/mcp>. The server offers the following tools:

- `retrieve_docs` allows agents to search an up-to-date knowledge base of LUMI documentation. The
  search functionality is implemented using an embedding model that runs locally on the MCP server
  host. Access to this tool allows AI agents to, e.g., answer questions about LUMI with more
  accuracy and write code that takes into account LUMI's particular system architecture and
  software environment. The knowledge base is comprised of LUMI Documentation (this site) and the
  [LUMI AI Guide][lumi ai guide].
- `get_service_status` uses the [LUMI Service Status][lumi service status] server to
  provide status information on LUMI and related services. This includes node availability,
  response time, and any outages due to maintenance or incidents.

## Test the server

To understand how the server works, it is possible to test it manually using, e.g.,
the [FastMCP CLI][fastmcp cli].

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

## Connect a client

MCP servers can be used with a variety of platforms, such as IDEs (e.g., VS Code), CLI coding
assistants (e.g., OpenCode) and web-based chat interfaces (e.g., Claude Web).

* [Add and manage MCP servers in VS Code][mcp vscode]
* [MCP Servers | OpenCode][mcp opencode]
* [Third party connectors with remote MCP - Claude.ai Documentation][mcp claude]

An example `opencode.json` config file is provided for using the LUMI AIF Knowledge MCP Server in
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
