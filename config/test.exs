use Mix.Config

# IO.ANSI checks for shell compatability before enabling
# ANSI escape codes & this is a problem for our CI running
# on Github Actions as it doesn't support ANSI yet. Therefore
# we configure it to force it being enabled (as we don't care
# about seeing the output, just that the tests check it works).
config :elixir, ansi_enabled: true
