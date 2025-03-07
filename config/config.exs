import Config

config :advent_of_code, AdventOfCode.Input,
  allow_network?: true,
  year: 2018,
  session_cookie: System.get_env("ADVENT_OF_CODE_SESSION_COOKIE")

# If you don't like environment variables, put your cookie in
# a `config/secrets.exs` file like this:
#
# import Config
# config :advent_of_code, AdventOfCode.Input,
#   session_cookie: "..."

try do
  import_config "secrets.exs"
rescue
  _ -> :ok
end
