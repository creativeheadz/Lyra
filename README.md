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

## Origin

Lyra began as the "Lyra v2.0" prompt-optimizer prompt that spread on Reddit in mid-2025. This repository restructures it:

- adds the guard that stops Lyra answering the prompt instead of optimizing it
- replaces the mandatory welcome message and post-delivery questionnaire with placeholders and a single closing line
- anchors the scoring rubric and scores the original against the rewrite
- replaces the 500-word limit and the "5th grader" clarity test with rules that respect source material and domain terminology
- updates the platform notes for reasoning models
- adds a worked example

## License and contributing

MIT, see [LICENSE](LICENSE). Issues and pull requests are welcome.
