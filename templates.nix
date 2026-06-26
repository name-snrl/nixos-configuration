# deadnix: skip
{ __findFile, ... }:
{
  flake.templates.default = {
    path = <templates/shell>;
    description = "A minimal flake with a devShell.";
  };
}
