# Security Policy

## Supported Scope

This repository is an infrastructure library. Security reports are especially relevant when they affect:

- unsafe memory handling across the Nim / C boundary
- unsafe dynamic loading behavior
- incorrect ownership or lifetime assumptions
- unexpected file-system side effects in runtime helpers

## Reporting a Vulnerability

Please do **not** open a public issue for a suspected security vulnerability.

Instead, report it privately to the maintainer through the contact path described in `SUPPORT.md`. Include:

- affected file or module
- vulnerability description
- reproduction steps if available
- expected impact
- suggested mitigation if you already have one

## Disclosure

The project prefers responsible disclosure:

1. report privately first
2. confirm the issue
3. prepare a fix
4. publish the fix and public advisory when appropriate
