# Lyra

Lyra is a system prompt that turns a rough request into a well-specified prompt for ChatGPT, Claude, Gemini or any other model. You send it the prompt you were about to use. It returns a version with the goal, inputs, constraints and output format made explicit, and bracketed placeholders for anything you still have to supply.

The whole project is one file: [lyra.md](lyra.md).

## How it works

Lyra treats every message as a prompt to improve, never as a task to perform. For each one it:

1. Deconstructs the request: goal, audience, inputs, expected output, what is given and what is missing.
2. Diagnoses it against a checklist: goal, inputs, audience, constraints, output format, success criteria, failure handling, examples.
3. Develops the rewrite, keeping your intent, your terminology and any wording that was already precise.
4. Delivers the prompt in a code block with a short list of what changed and what to fill in.

There are two modes. BASIC, the default, rewrites immediately. DETAIL adds a diagnosis of the original, a before-and-after score on an anchored rubric, and up to three questions where an answer would change the prompt. Prefix a message to override the defaults, for example `DETAIL for Claude: <prompt>`.

## Setup

Paste the contents of `lyra.md` where your platform keeps persistent instructions:

- ChatGPT: the Instructions field of a Custom GPT, or the first message of a new chat
- Claude: Project instructions, or the system prompt when using the API
- Gemini: the Instructions field of a Gem
- Any other model: the system prompt field, or the first message

Then send the prompt you want improved.

## Example

Input:

    write me a cover letter for a marketing job

Lyra returns a prompt with placeholders for the role, the posting and your background, a 300-word limit, an instruction to open with your most relevant achievement, and a rule that anything the model had to guess is marked `[CHECK]`. The full exchange is in the Example section of [lyra.md](lyra.md).

## Testing

`tests/run.sh` sends each case in `tests/cases/` to a model with `lyra.md` as the system prompt and checks that the reply has the shape the prompt specifies: a mode line, an "Optimized prompt" section in a fenced block, no ratings request, and the one-line close. The case named canary is the realistic technical request that the original prompt answered instead of optimizing.

```
tests/run.sh                                   # claude CLI, Sonnet
tests/run.sh --runner ollama --model qwen3:8b  # a local model through Ollama
```

Replies are written to `tests/out/` for reading. Re-run after any edit to `lyra.md` and whenever a model generation changes. The platform notes are the part most likely to go stale.

Last verified: 13 October 2026. Claude Sonnet 5.5 through the claude CLI passes all five cases. qwen3:8b through Ollama passes the three optimization cases and fails the greeting, where it appends the closing line, and the injection case, where it answers the question. Small local models follow the format but not the guard.

## Origin

Lyra began as a prompt shared on Reddit in late June 2025. This repository first held that text plus a set of additions labelled "v2.0", and in October 2026 it was restructured into the current `lyra.md`. The dated timeline, what each version contained, why each change was made, and what remains unverified are in [PROVENANCE.md](PROVENANCE.md).

## License and contributing

MIT, see [LICENSE](LICENSE). Issues and pull requests are welcome.
