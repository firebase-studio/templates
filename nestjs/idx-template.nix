{ pkgs, version ? "latest", packageManager ? "npm", ... }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun ];

  bootstrap = ''
		mkdir "$out"
		cd "$out"
		
		npx @nestjs/cli@${version} new . \
        	--skip-install \
        	--package-manager ${packageManager} \
     		--language TypeScript
    		
		mkdir -p "$out"/.idx
		
		chmod -R u+w "$out"
		cp ${./.idx/dev.nix} "$out"/.idx/dev.nix
		cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
		cp -rf ${./.idx/mcp.json} "$out/.idx/mcp.json"
		cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
		chmod -R +w "$out"

	${
      	if packageManager == "npm" then
        "npm install --package-lock-only --ignore-scripts"
      	else if packageManager == "pnpm" then
        "pnpm install --lockfile-only --ignore-scripts"
      	else if packageManager == "yarn" then
        "yarn install --mode update-lockfile --ignore-scripts"
      	else if packageManager == "bun" then
        "bun install --no-save"
      	else
        ""
    	}
    	
    	cat <<EOF > src/main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(process.env.PORT ?? 9002, '0.0.0.0');
  
}
bootstrap();
EOF

  '';
}

