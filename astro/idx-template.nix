{pkgs, template ? "basics", version ? "latest", packageManager ? "npm", typescript ? "strict", git ? true, tailwind ? false, ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.nodePackages.pnpm
    pkgs.bun
    pkgs.j2cli
    pkgs.nixfmt
  ];

  bootstrap = ''
    mkdir "$out"
    ${
      if packageManager == "npm" then "npm create astro@${version} \"$out\" -- --template ${template} --typescript ${typescript} ${if git then "--git" else "--no-git" } --no-install"
      else if packageManager == "yarn" then "yarn create astro \"$out\" --template ${template} --typescript ${typescript} ${if git then "--git" else "--no-git" } --no-install" 
      else if packageManager == "pnpm" then "pnpm create astro \"$out\" --template ${template} --typescript ${typescript} ${if git then "--git" else "--no-git" } --no-install"
      else if packageManager == "bun" then "bun create astro \"$out\" --template ${template} --typescript ${typescript} ${if git then "--git" else "--no-git" } --no-install"
      else "npm create astro@${version} \"$out\" -- --template ${template} --typescript ${typescript} ${if git then "--git" else "--no-git" } --no-install"
    }

    mkdir -p "$out"/.idx
    packageManager=${packageManager} tailwind=${if tailwind then "true" else "false"} j2 ${./devNix.j2} -o "$out"/.idx/dev.nix
    nixfmt "$out"/.idx/dev.nix

    mkdir -p "$out/.idx"
    chmod -R u+w "$out"
    cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
    cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
    chmod -R u+w "$out"
    
    ${if packageManager == "npm" then "( cd \$out && npm i --package-lock-only --ignore-scripts )" else ""}
  '';
}


