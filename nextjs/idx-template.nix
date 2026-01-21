{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts"
, packageManager ? "npm", srcDir ? false, eslint ? false, app ? false
, tailwind ? false, firebase-tool ? false, firebase-project-id ? null, firebase-auth-id ? null
, ... }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun ]
    ++ (if firebase-tool then [ pkgs.firebase-tools ] else []);

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

		(
			cd "$out"
			${if firebase-tool then ''
				if [ "${packageManager}" = "npm" ]; then
					npm install firebase-tools
				elif [ "${packageManager}" = "yarn" ]; then
					yarn add firebase-tools
				elif [ "${packageManager}" = "pnpm" ]; then
					pnpm add firebase-tools
				fi
			'' else ""}

			${if firebase-tool || firebase-project-id != null || firebase-auth-id != null then ''
				if [ "${packageManager}" = "npm" ]; then
					npm install firebase
				elif [ "${packageManager}" = "yarn" ]; then
					yarn add firebase
				elif [ "${packageManager}" = "pnpm" ]; then
					pnpm add firebase
				fi
				
				APP_DIR=${if srcDir then "'src'" else "'.'" }
				mkdir -p "$APP_DIR/lib"

				FILE_EXT=${if language == "ts" then "'ts'" else "'js'"}
				CONFIG_FILE="$APP_DIR/lib/firebase.$FILE_EXT"

				cat <<EOF > "$CONFIG_FILE"
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
const firebaseConfig = {
  apiKey: "${if firebase-auth-id != null then firebase-auth-id else "YOUR_API_KEY"}",
  authDomain: "${if firebase-project-id != null then ''"${firebase-project-id}.firebaseapp.com"'' else "YOUR_PROJECT_ID.firebaseapp.com"}",
  projectId: "${if firebase-project-id != null then firebase-project-id else "YOUR_PROJECT_ID"}",
  storageBucket: "${if firebase-project-id != null then ''"${firebase-project-id}.appspot.com"'' else "YOUR_PROJECT_ID.appspot.com"}",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
EOF
			'' else ""}
		)

		mkdir -p "$out"/.idx
		chmod -R u+w "$out"
		cp ${./dev.nix} "$out"/.idx/dev.nix
		cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
		cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
		chmod -R +w "$out"

		${
         if packageManager == "npm" then
           "( cd $out && npm i --package-lock-only --ignore-scripts )"
         else
           ""
        }
  '';
}
