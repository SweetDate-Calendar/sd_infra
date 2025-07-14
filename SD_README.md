Chronopipe CLI Tool Specification

Tool Name

sweetdate

Primary Use Case

Manage local Chronopipe development and testing environment via CLI.

Available Commands

Command	Description
sweetdate help	Show list of commands and usage info
sweetdate dev up	Run Ansible to start all services (local_dev.yml)
sweetdate dev up --except a,b	Run Ansible to start all except selected services
sweetdate dev down	Run Ansible to stop all services (dev_down.yml)
sweetdate db create	Create all databases for all services
sweetdate db migrate	Run all migrations in all projects
sweetdate db seed	Run seeds in all projects
sweetdate install	Clone all needed GitHub repo
sweetdate test end2end	Run full end-to-end test suite
sweetdate protocol extract ruby	Generate Ruby protocol client definition
sweetdate protocol extract elixir	Generate Elixir protocol client definition
sweetdate protocol extract php	Generate PHP protocol client definition

Notes
	•	All commands should have helpful logs and output
	•	Should fail gracefully with actionable error messages
	•	Must load and respect the .envrc environment variables

Suggested Scaffold Command

To create the CLI tool using Elixir:

mix new sweetdate_cli --app sweetdate --module Chronopipe.CLI

Use escript for a compiled executable:

# mix.exs
escript: [main_module: Chronopipe.CLI]

Implementation Example: sweetdate dev up

This command will run the Ansible playbook to start the development environment:


  def main(_) do
    IO.puts("""
    Chronopipe CLI

    Available commands:
      ./sweetdate dev up                   # Start local development environment
      sweetdate dev up --except a,b      # Start dev env skipping specific apps
    """)
  end
end

## Compile with:
mix escript.build

./sweetdate dev up --except "cp_backend"