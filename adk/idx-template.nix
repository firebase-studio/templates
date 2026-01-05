{ pkgs, ... }: {
  packages = [
    pkgs.python3
  ];
  bootstrap = ''
    mkdir "$out"
    mkdir "$out"/.idx
    mkdir "$out"/.gemini
    mkdir "$out"/multi_tool_agent
    cp -r ${./.idx}/. "$out/.idx/"
    cp -r ${./.gemini}/. "$out/.gemini"
    cp -r ${./multi_tool_agent}/. "$out/multi_tool_agent"
    cp -f ${./multi_tool_agent}/.env.local "$out/multi_tool_agent/.env.local"
    cp -f ${./.gitignore} "$out/.gitignore"
    cp -f ${./requirements.txt} "$out/requirements.txt"
    cp -f ${./devserver.sh} "$out/devserver.sh"
    cp -f ${./llms-full.txt} "$out/llms-full.txt"
    cp -f ${./README_TEMPLATE.md} "$out"/README.md
    cp -f ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -f ${./.idx/airules.md} "$out/GEMINI.md"
    cp -f ${./AGENTS.md} "$out/AGENTS.md"
    chmod -R u+w "$out"
    chmod -R u+x "$out/devserver.sh"
  '';
}
