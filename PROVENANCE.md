# Provenance

Where Lyra came from, what each version contained, and what is and is not established. Every date comes from the linked source. Where something could not be verified, this file says so rather than guessing.

## Timeline

| Date | Event | Source |
|---|---|---|
| Late June 2025 | A Reddit post shares the original Lyra prompt: a "master-level AI prompt optimization specialist" using a four-step method (Deconstruct, Diagnose, Develop, Deliver), BASIC and DETAIL modes, fixed response formats, a mandatory welcome message and a memory note. Articles credit a user known as "Min" and retell the post's story of 147 failed attempts at a sales email. The thread is not linked here because it could not be retrieved for verification. | [yurikoval.com](https://yurikoval.com/blog/lyra-prompt.html), [TeraBox article](https://insights.terabox.com/hub/how-to-use-the-viral-lyra-4d-chatgpt-prompt-to-stop-getting-robotic-results) |
| 2 July 2025 | Min Choi posts the prompt text on X. Whether this account and the Reddit poster are the same person is not established. | [x.com/minchoi/status/1940251597050646766](https://x.com/minchoi/status/1940251597050646766) |
| 3 July 2025 | A public gist, `lyra.txt`, holds the same text, 395 words. Its later revisions are single-line edits. | [gist](https://gist.github.com/xthezealot/c873effd9e74225ef3fcfbb9c3a341da) |
| 18 July 2025 | This repository's first commit adds the file `lyra`, 743 words: the Reddit text word for word, plus the additions labelled "v2.0" listed below. | [commit 6c4a6ca](https://github.com/creativeheadz/Lyra/commit/6c4a6ca) |
| 19 July 2025 | Payton Bilodeau publishes a YouTube video with a different "Lyra V2", produced by asking Lyra to improve itself. Its wording does not match this repository's additions. | [video](https://www.youtube.com/watch?v=1r5Wa5hYBEw) |
| 22 July 2025 | Copies of the original text keep appearing in unrelated repositories, for example as a docs file in an MCP server project. | [example](https://github.com/Estaed/Lol_Data_MCP_Server/blob/main/docs/lyra.txt) |
| 13 October 2026 | Restructure. The two copies in this repository are replaced by one rewritten file, `lyra.md`. | [commit 8a8e977](https://github.com/creativeheadz/Lyra/commit/8a8e977) |
| 13 October 2026 | This file and the test harness are added. After testing against a small local model, the prompt's guard is extended to messages that tell it to ignore its instructions or take another role, the no-prompt greeting is stated to be the whole reply, and "target" is defined as the model the prompt is for. | the commit that introduced this file |

## What each version contained

**The Reddit original, June 2025, about 395 words.** The four-step method; a short list of techniques with one-line platform notes; the two modes; two response formats; a required welcome message; a processing flow; a note not to save sessions to memory.

**The "v2.0" file in this repository, July 2025, about 350 added words.** Everything above, unchanged, plus: three "core constraints"; a clarity audit and specificity check under Diagnose, including the test "can a 5th grader understand the request"; a 0 to 10 scoring rubric; fill-in templates per platform; a list of common pitfalls, among them a 500-word limit; edge-case handling; a three-question post-delivery protocol; "success indicators" claiming 80 percent fewer clarifications and 90 percent more relevance; a quick optimization checklist.

**The restructure, October 2026.** Keeps the four step names and the two mode names. Everything else is rewritten. The reasons, each verified by running the prompt:

- The prompt did not say that the user's message is always material to optimize. Given a realistic technical request it answered the request instead. A guard line now covers this.
- Clarifying questions blocked delivery. Missing information is now a bracketed placeholder, so the result is usable immediately, and DETAIL mode asks at most three questions that would change the rewrite.
- The rubric had no anchors and scored only the rewrite, so it returned flattering numbers. It now has 0, 1 and 2 anchors, scores the original against the rewrite, and applies only in DETAIL mode.
- The 5th-grader test contradicted the rule to preserve domain terminology. The test is now whether a competent practitioner would know exactly what to produce.
- The 500-word limit penalised prompts that carry source material. Length now follows the task, and the rule is against padding.
- The mandatory welcome message and the post-delivery questionnaire are gone. A message with no prompt in it gets a short plain greeting.
- The platform notes named GPT-4 and treated chain-of-thought scripting as a technique. They now cover durable differences only, and tell the model not to script reasoning for reasoning models.
- The success-indicator percentages had no basis and gave the model nothing to act on. They are removed, here and from the README.
- A worked example was added. The old prompt recommended few-shot examples and contained none.

## What is established and what is not

- Established: the base text predates this repository. It appears in dated copies from 2 and 3 July 2025, fifteen days before the first commit here, and articles place it on Reddit in late June 2025.
- Not established: who wrote the "v2.0" additions. As of 13 October 2026 they were not found in any other public copy: not the gist, the X post, the YouTube "Lyra V2", other repositories via GitHub code search, or web search. They may have been written in this repository, or copied from a source that is no longer findable.
- Not established: the Reddit author's exact username and the thread URL. Reddit could not be retrieved with the tools used for this check.

## Licensing

The current files, `lyra.md`, `README.md`, `PROVENANCE.md` and `tests/`, are written for this repository and are under the MIT licence in `LICENSE`. The method and mode names come from the Reddit prompt. The Reddit text itself is not reproduced in the current files; it exists only in this repository's history, in commits before 8a8e977, and its author stated no licence for it.
