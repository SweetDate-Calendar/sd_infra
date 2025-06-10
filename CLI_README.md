Chronopipe CLI Tool Specification

Tool Name

chronopipe

Primary Use Case

Manage local Chronopipe development and testing environment via CLI.

Available Commands

Command	Description
chronopipe help	Show list of commands and usage info
chronopipe dev up	Run Ansible to start all services (local_dev.yml)
chronopipe dev up --except a,b	Run Ansible to start all except selected services
chronopipe dev down	Run Ansible to stop all services (dev_down.yml)
chronopipe db create	Create all databases for all services
chronopipe db migrate	Run all migrations in all projects
chronopipe db seed	Run seeds in all projects
chronopipe install	Clone all needed GitHub repos
chronopipe test end2end	Run full end-to-end test suite
chronopipe protocol extract ruby	Generate Ruby protocol client definition
chronopipe protocol extract elixir	Generate Elixir protocol client definition
chronopipe protocol extract php	Generate PHP protocol client definition

Notes
	•	All commands should have helpful logs and output
	•	Should fail gracefully with actionable error messages
	•	Must load and respect the .envrc environment variables

Suggested Scaffold Command

To create the CLI tool using Elixir:

mix new chronopipe_cli --app chronopipe --module Chronopipe.CLI

Use escript for a compiled executable:

# mix.exs
escript: [main_module: Chronopipe.CLI]

Implementation Example: chronopipe dev up

This command will run the Ansible playbook to start the development environment:


  def main(_) do
    IO.puts("""
    Chronopipe CLI

    Available commands:
      ./chronopipe dev up                   # Start local development environment
      chronopipe dev up --except a,b      # Start dev env skipping specific apps
    """)
  end
end

## Compile with:
mix escript.build

./chronopipe dev up --except "cp_backend"