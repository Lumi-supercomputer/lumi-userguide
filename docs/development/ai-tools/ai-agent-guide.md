# AI Agent Guide

AI agents like [Claude Code](https://code.claude.com/docs/en/overview) or [OpenAI Codex](https://openai.com/codex/) (via Command Line Interface or code editor plugins) are getting popular, and some of our LUMI users have started using them for coding assistance or Slurm monitoring and job management. AI agents are powerful and can introduce security risks or disruptions for you and for other users of the supercomputer.

!!! Warning "Responsibility for running AI agents"
    The resposibility for running AI Agents always lies with the user running the AI agent. Remember to follow the [terms of use](https://lumi-supercomputer.eu/termsandpolicies/).

## I am running a AI agent — what should I do?
If you are running a coding agent, we ask for your cooperation:

1. Be aware of what could go wrong (summarised in the [table below](#common-problems-with-coding-agents-and-how-to-avoid-them)).
2. Save your work frequently. LUMI admins may have to kill processes if they affect
   system stability.
3. Run your AI agent in a [container](https://docs.lumi-supercomputer.eu/software/containers/singularity/) to explicitly decide which folders it can access.
4. Do not give access the AI agent access to personal data of other users.
5. Responsibility always lies with the person operating the AI agent; the AI itself cannot be
   held accountable.

## Common problems with AI agents and how to avoid them

| Category | What could go wrong? | What should I do? |
|--------|----------------------|------------------|
| **LUMI supercomputer stability** | Agents may submit jobs, spawn runaway loops, or aggressively query Slurm, impacting shared infrastructure. | Monitor agents actively and avoid running more than one. Always verify job parameters against LUMI documentation. Disruptive behavior may be moderated. |
| **Login node availability** | If a login node becomes unstable, active agent processes may be terminated without notice. | Save work frequently. Do not rely on long-running unsupervised sessions. |
| **Autonomous file actions** | Agents can modify, overwrite, or delete files without confirmation. | Run the agent in an container to restrict what folders it can modify. Use version control or backups (LUMI supercomputer filesystems are not backed up). Do not delegate git commands; instead ask which commands to run and execute them yourself. Avoid giving agents git credentials.  |
| **Code & data confidentiality** | Code, file contents, error messages, or secrets may be sent to external LLM providers or exposed to other users on shared nodes. | Never process sensitive or confidential data using AI agents. Use synthetic data. Keep secrets out of accessible paths. Containers can limit blast radius. CLI agents may expose inline commands (e.g. `python -c ...`) to other users. |
| **Software & supply chain** | Agents may automatically install packages from public registries (PyPI, npm, CRAN, Conda‑Forge, etc.). Some may be malicious, compromised, or part of [Typosquatting](https://en.wikipedia.org/wiki/Typosquatting) or dependency-confusion attacks. | Review what gets installed during and after sessions, or install dependencies *before* running the agent. Never run agents with elevated privileges. Avoid bleeding-edge package versions. Read more at the [OWASP website](https://owasp.org/www-community/Component_Analysis). |
| **Prompt injection** | Agents may read documentation, repositories, or web pages that contain hidden instructions hijacking behavior (prompt injection). | Be cautious about what URLs or repositories agents can browse. Review actions taken after reading external content and installed “skills.” Prefer agents that request confirmation. See also this [an extensive review article on prompt injection atacks](https://arxiv.org/html/2601.17548v1). |
| **LLM provider data retention** | Providers may retain queries according to their privacy policies. | Read and understand provider privacy policies before your first session. |
| **Third-party terms of service** | Each tool has its own terms; LUMI User Support does not provide support. | Read and comply with the terms of each tool. Contact the provider for tool-specific support. |



## Further Resources
- The [CodeRefinery project](https://coderefinery.org/) provides a session on [responsible use of generative AI in assisted coding](https://coderefinery.github.io/coding-with-ai/).


## Credits
This content is adapted from [Aalto Scientific Computing (ASC), AI Agents on HPC](https://scicomp.aalto.fi/triton/usage/ai-agents/) (CC BY). Substantial modifications and additions by the mainainters of the LUMI userguide.