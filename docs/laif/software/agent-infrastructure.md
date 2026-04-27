# Agent infrastructure

The LUMI AI Factory agent infrastructure offers tools that support the use of AI agents for tasks
involving LUMI.

## MCP server

The LUMI AI Factory provides a
[Model Context Protocol (MCP)](https://modelcontextprotocol.io/docs/getting-started/intro) server,
which can be found at <https://lumi-aif-agents.2.rahtiapp.fi/mcp>. The server allows agents to
query a knowledge base comprised of the following sources:

* LUMI Docs
* [LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide)

### Standalone usage

You can test the server manually using the [FastMCP CLI](https://gofastmcp.com/cli/overview).

```bash
# Install FastMCP Python package
pip install fastmcp

# List available tools
fastmcp list https://lumi-aif-agents.2.rahtiapp.fi/mcp

# Call the retrieve_docs tool with query string "pytorch" and return top 2 matches
fastmcp call https://lumi-aif-agents.2.rahtiapp.fi/mcp retrieve_docs query=pytorch k=2
```

### Client integration

MCP servers can be integrated with a variety of platforms. This section provides some examples.
After completing the integration steps for your platform of choice, you can test the server by
asking the agent a question about LUMI, such as "how many GPUs are there on LUMI?". The agent
should find and use the appropriate tool without explicit user instruction.

#### CLI coding assistant (OpenCode)

MCP servers are frequently used for providing additional tools to CLI coding assistants like
[OpenCode](https://opencode.ai/). Below is an example `opencode.json` config file for
[adding the server to OpenCode](https://opencode.ai/docs/mcp-servers).

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

#### Web chatbot (Claude)

The server can also be used with web-based chatbots like [Claude](https://claude.ai), whose free
plan allows connecting one custom MCP server at a time. To add the MCP server to Claude, go to the
[Connectors submenu](https://claude.ai/settings/connectors) and click the *Add custom connector*
button. Give the connector a name (such as "LUMI AIF Server") and enter the server's URL in the
*Remote MCP server URL* field.

