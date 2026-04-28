# AI agent guide

AI agents like [Claude Code](https://code.claude.com/docs/en/overview) and [OpenAI Codex](https://openai.com/codex/) have become popular tools for coding, including on LUMI. Users are running agents on the system for tasks like coding assistance or monitoring and managing Slurm jobs. AI agents should be used carefully, as they can introduce security risks or disruptions for LUMI users, including yourself.

!!! Warning "Responsibility for running AI agents"
    The user is always responsible for the actions of their AI agents. Understand that any command run by your agent is executed under your personal user account. As a LUMI user, you must always follow the [LUMI Terms of Use](https://lumi-supercomputer.eu/termsandpolicies/).

## I am running an AI agent — what should I take into account?

1. Be aware of what could go wrong (summarised in the [table below](#common-problems-with-coding-agents-and-how-to-avoid-them)).
2. Save your work frequently. LUMI admins may have to kill your processes if they degrade system stability.
3. Run your agent in a [container](../../../software/containers/singularity) to control its access to files.
4. Do not give your AI agent access to personal data of other users.
5. You are always responsible for your agent. The agent itself cannot be held accountable.

## Common problems with AI agents and how to avoid them

| Category | What could go wrong? | What should I do? |
|----------|----------------------|-------------------|
| **LUMI supercomputer stability** | Agents may submit jobs, spawn runaway loops, or aggressively query Slurm, impacting shared infrastructure. | Monitor agents actively and avoid running more than one. Always verify job parameters against LUMI documentation. Disruptive processes may be terminated. |
| **Login node availability** | If a login node becomes unstable, active agent processes may be terminated without notice. | Save work frequently. Do not rely on long-running unsupervised sessions. |
| **Autonomous file actions** | Agents can modify, overwrite, or delete files without confirmation. | Run the agent in an container to limit the files it can access. Use version control or backups (LUMI supercomputer filesystems are not backed up). Instead of delegating Git commands, ask the agent which commands to run and execute them yourself. Avoid giving agents Git credentials. |
| **Code & data confidentiality** | Code, file contents, error messages, or secrets may be sent to external LLM providers or exposed to other users on shared nodes. | Never process sensitive or confidential data using AI agents. Use synthetic data. Keep secrets out of accessible paths. Containers can limit blast radius. CLI agents may expose inline commands (e.g. `python -c ...`) to other users. |
| **Software & supply chain** | Agents may automatically install packages from public registries (PyPI, npm, CRAN, Conda‑Forge, etc.). Some may be malicious, compromised, or part of [typosquatting](https://en.wikipedia.org/wiki/Typosquatting) or dependency-confusion attacks. | Review what gets installed during and after sessions, or install dependencies *before* running the agent. Never run agents with elevated privileges. Avoid bleeding-edge package versions. Read more at the [OWASP website](https://owasp.org/www-community/Component_Analysis). |
| **Prompt injection** | Agents may read documentation, repositories, or web pages that contain hidden instructions hijacking behavior (prompt injection). | Be cautious about the URLs and repositories agents can browse. Review actions taken after reading external content and installed "skills." Prefer agents that request confirmation. See [Maloyan & Namiot (2026)](https://arxiv.org/html/2601.17548v1) for an extensive review of prompt injection attacks. |
| **LLM provider data retention** | Providers may retain queries according to their privacy policies. | Read and understand provider privacy policies before your first session. |
| **Third-party terms of service** | Each tool has its own terms of service. LUMI User Support does not provide support for third-party services. | Read and comply with each tool's terms of service. Contact the tool maintainer for tool-specific support. |

## Further resources
- The [CodeRefinery project](https://coderefinery.org/) provides a session on [responsible use of generative AI in assisted coding](https://coderefinery.github.io/coding-with-ai/).

## Credits
This content is adapted from [AI Agents on HPC – Aalto Scientific Computing (ASC)](https://scicomp.aalto.fi/triton/usage/ai-agents/) (CC BY) with substantial modifications and additions by the maintainers of the LUMI user guide.

