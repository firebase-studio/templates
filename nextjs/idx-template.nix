{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts"
, packageManager ? "npm", srcDir ? false, eslint ? false, app ? false
, tailwind ? false, firebase-tool ? false, ... }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun ];

  bootstrap = ''
		mkdir "$out"
		npx create-next-app@${version} "$out" \
			--yes \
			--skip-install \
			--import-alias=${importAlias} \
			--${language} \
			--use-${packageManager} \
			${if eslint then "--eslint" else "--no-eslint"} \
			${if srcDir then "--src-dir" else "--no-src-dir"} \
			${if app then "--app" else "--no-app"} \
			${if tailwind then "--tailwind" else "--no-tailwind"}

		mkdir -p "$out"/.idx
		chmod -R u+w "$out"
		cp ${./dev.nix} "$out"/.idx/dev.nix
		cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
		cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
		chmod -R +w "$out"

		${
			if firebase-tool then
				let
					installCmd = if packageManager == "npm" then "install" else "add";
				in
					"(cd $out && ${packageManager} ${installCmd} firebase firebase-tools firebase-admin)"
			else
				""
		}

		${
      if packageManager == "npm" then
        "( cd $out && npm i --package-lock-only --ignore-scripts )"
      else
        ""
     }
  '';
}
