# AI agent guide

AI agents like [Claude Code](https://code.claude.com/docs/en/overview) and [OpenAI Codex](https://openai.com/codex/) have become popular tools for coding, including on LUMI. Users are running agents on the system for tasks like coding assistance or monitoring and managing Slurm jobs. AI agents should be used carefully, as they can introduce security risks or disruptions for LUMI users, including yourself.

!!! Warning "Responsibility for running AI agents"
    The user is always responsible for the actions of their AI agents. Understand that any command run by your agent is executed under your personal user account. As a LUMI user, you must always follow the [LUMI Terms of Use](https://lumi-supercomputer.eu/termsandpolicies/).

## I am running an AI agent — what should I take into account?

1. Be aware of what could go wrong (summarised in the [table below](#common-problems-with-coding-agents-and-how-to-avoid-them),
   with some elements explained in more detail underneath the table).
2. Save your work frequently. LUMI admins may have to kill your processes if they degrade system stability.
3. Run your agent in a [container](../../../software/containers/singularity) to control its access to files.
4. Do not give your AI agent access to personal data of other users.
5. You are always responsible for your agent. The agent itself cannot be held accountable.

## Common problems with AI agents and how to avoid them

| Category | What could go wrong? | What should I do? |
|----------|----------------------|-------------------|
| **LUMI supercomputer stability** <sup><a href="#remark_1">(1)</a></sup> | Agents may submit jobs, spawn runaway loops, or aggressively query Slurm, impacting shared infrastructure. | Monitor agents actively and avoid running more than one. Always verify job parameters against LUMI documentation. Disruptive processes may be terminated. |
| **Login node availability** <sup><a href="#remark_2">(2)</a></sup> | If a login node becomes unstable, active agent processes may be terminated without notice. | Save work frequently. Do not rely on long-running unsupervised sessions. |
| **Autonomous file actions** | Agents can modify, overwrite, or delete files without confirmation. | Run the agent in an container to limit the files it can access. Use version control or backups (LUMI supercomputer filesystems are not backed up). Instead of delegating Git commands, ask the agent which commands to run and execute them yourself. Avoid giving agents Git credentials. |
| **Code & data confidentiality** | Code, file contents, error messages, or secrets may be sent to external LLM providers or exposed to other users on shared nodes. | Never process sensitive or confidential data using AI agents. Use synthetic data. Keep secrets out of accessible paths. Containers can limit blast radius. CLI agents may expose inline commands (e.g. `python -c ...`) to other users. |
| **Software & supply chain** | Agents may automatically install packages from public registries (PyPI, npm, CRAN, Conda‑Forge, etc.). Some may be malicious, compromised, or part of [typosquatting](https://en.wikipedia.org/wiki/Typosquatting) or dependency-confusion attacks. | Review what gets installed during and after sessions, or install dependencies *before* running the agent. Never run agents with elevated privileges. Avoid bleeding-edge package versions. Read more at the [OWASP website](https://owasp.org/www-community/Component_Analysis). |
| **Prompt injection** | Agents may read documentation, repositories, or web pages that contain hidden instructions hijacking behavior (prompt injection). | Be cautious about the URLs and repositories agents can browse. Review actions taken after reading external content and installed "skills." Prefer agents that request confirmation. See [Maloyan & Namiot (2026)](https://arxiv.org/html/2601.17548v1) for an extensive review of prompt injection attacks. |
| **LLM provider data retention** | Providers may retain queries according to their privacy policies. | Read and understand provider privacy policies before your first session. |
| **LUMI Terms of Use** <sup><a href="#remark_3">(3)</a></sup> | Some tools, in particular some tools that use third party services, violate the [LUMI Terms of Use](https://lumi-supercomputer.eu/termsandpolicies/). | Carefully select what tools you use. Not all tools can be used on LUMI and we cannot provide an exhaustive list. Understand how your tools work, and when in doubt, don't use the tool on LUMI. |
| **Third-party terms of service** | Each tool has its own terms of service. LUMI User Support does not provide support for third-party services. | Read and comply with each tool's terms of service. Contact the tool maintainer for tool-specific support. |

### Further remarks on items in the table

#### <a name="remark_1"></a>(1) LUMI supercomputer stability

Tools polling Slurm (through `squeue`, `sacct`, ... or API calls with similar functionality) at an interval measured
in seconds or less rather than minutes, are not allowed on LUMI. They can slow down the scheduler for all users, and even make Slurm 
totally unresponsive. Accidents like this have happened in the past.

Users have been blocked temporarily from LUMI access after overloading Slurm or other system services
until they could prove their tools have been corrected, so be responsible and be careful.

#### <a name="remark_2"></a>(2) Login node availability

A login node is shared with tens, or on very busy moments, over 100 users. They are not a replacement for a personal workstation
and the resources they can offer per user are limited
(at 100 active users you have the equivalent of permanent use of roughly 1 core and 10GB of memory per user, much less than what 
a recent laptop can offer). 
Currently, limits on concurrent CPU capacity, memory capacity, and walltime and CPU time
for processes, are already in place. If the current limits are not enough to guarantee responsive login nodes for everybody, they will
be made more strict, and if every user would try to work against that limit, they will have to be made much more strict.

If the tools that you use consume too much resources, they have to be run in the context of a billed job
on compute nodes.

Tools like VScode remote have the bad habit to start processes, losing connection and not cleaning up those processes. Slowness on
the login nodes is often caused by lots of hanging processes. So if you use such tools, regularly check the processes you have running on the login nodes. You can do so with `ps -u $USER` or with the `htop` command which is now part of the system image on the login nodes. In `htop`,
you can press `u` and then select your userID to see all your processes. You can change the sort column to something 
more useful (e.g., time) by using 
the combination of the SHIFT key and `<` or `>` keys. With `k` you can kill a process that you select (you will usually have to use the
`SIGKILL` signal). And with `S` you can enter a setup screen where you can customise your settings and, e.g., also select
the start time as one of the columns to show.

#### <a name="remark_3"></a>(3) LUMI Terms of Use

The list here is not exhaustive.

However, one rule that several tools break, is the rule that you should never share your credentials 
or for that matter, access to LUMI, as that requires a credential linked to your LUMI credentials, in any way. 
Having a third party starting work on LUMI under your account is also considered a case of credential sharing.

So if a tool runs on your personal laptop or other personal device under your userid or a userid that only you
have access to, and if you are the user of that tool,
and you use the tool to push data to LUMI or to start commands remotely on LUMI (remotely from 
the point of view of your personal device), that is OK.

Running a process on LUMI under your account that fetches data from outside LUMI and processes it, also does
not break the credentials sharing rule, also
if the data comes from a source that you do not fully control. Be careful though if, e.g., that data is program code,
as it can bring malicious code into your account (or even start it) and you are responsible for that.
And you are actually doing this more often than you think when you install software on the system.

However, having an external tool/server that is not running on a machine that you control and is not running under your 
userid on that machine,
that pushes data to LUMI or starts commands on LUMI, is not OK. It is also not OK if that tool connects to a server
you run on LUMI and can start work, since it is still a third party tool that starts work under your account without
you controlling that process completely, and in fact, you would first have to let that tool connect through a tunnel
which is open to other parties than you which is already a form of account sharing.

One example that is not an AI agent are the various ways of using Visual Studio remotely. The older plugins that work
over ssh and sftp directly from your laptop are OK (as long as you are the user of those tools of course), but the newer
Visual Studio Code "Remote - Tunnels" extension (also called "VScode dev tunnels") 
should not be used on LUMI as you have to create a tunnel that gives
a Microsoft service access to your account on LUMI. 
See also the [CSC documentation page on developing scripts remotely](https://docs.csc.fi/support/tutorials/remote-dev/).
But there are several tools in the development and AI world that also work that way.
As new tools appear all the time, it is impossible to keep track ourselves or to produce an exhaustive list.
Some examples include [Cloudflare](https://www.cloudflare.com/), [Ngrok](https://ngrok.com/) 
and [Gradio](https://www.gradio.app/).

#### A general remark on development tools

The login nodes of a supercomputer are not a replacement for a workstation. Many development tools are
developed in the first place for use on personal workstations or on a cloud infrastructure. Cloud infrastructures
have a totally different security model than share-everything HPC systems. Obviously the developers of the more popular big development
environments and AI agents are not stupid and they do care about security, but these tools are simply designed for a 
different work environment and a different security model, for a type of systems with a much larger market than 
supercomputing (and with users who are more willing to pay for the development and use of proper tools than the average HPC user).

Often the better way to do development, is to do the editing and use the coding assistants on a personal computer, 
pushing the code to whatever system you want to run on when you're ready to compile and test. In that way, you also
always have the code close to you and can switch easily to another supercomputer when one is down for maintenance.

## Further resources
- The [CodeRefinery project](https://coderefinery.org/) provides a session on [responsible use of generative AI in assisted coding](https://coderefinery.github.io/coding-with-ai/).

## Credits
This content is adapted from [AI Agents on HPC – Aalto Scientific Computing (ASC)](https://scicomp.aalto.fi/triton/usage/ai-agents/) (CC BY) with substantial modifications and additions by the maintainers of the LUMI user guide.

