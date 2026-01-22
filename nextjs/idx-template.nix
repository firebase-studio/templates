{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts"
, packageManager ? "npm", srcDir ? false, eslint ? false, app ? false
, tailwind ? false, firebaseTool ? false, ... }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun ]
    ++ (if firebaseTool then [ pkgs.nodePackages.firebase-tools ] else [ ]);

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
			if firebaseTool then
				let
					installCmd = if packageManager == "npm" then "install" else "add";
				in
					''
            (cd "$out" && ${packageManager} ${installCmd} firebase)

            baseDir="$out"
            if ${srcDir}; then
              baseDir="$out/src"
            fi

            cat <<EOF > "$baseDir/firebase.ts"
            import { initializeApp, getApps } from "firebase/app";
            import { getAuth } from "firebase/auth";

            const firebaseConfig = {
              apiKey: "YOUR_API_KEY",
              authDomain: "YOUR_AUTH_DOMAIN",
              projectId: "YOUR_PROJECT_ID",
              storageBucket: "YOUR_STORAGE_BUCKET",
              messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
              appId: "YOUR_APP_ID",
            };

            // Initialize Firebase
            let app;
            if (!getApps().length) {
              app = initializeApp(firebaseConfig);
            }

            const auth = getAuth(app);

            export { auth };
            EOF

            cat <<EOF > "$baseDir/login.tsx"
            "use client";

            import { useState, useEffect } from "react";
            import { GoogleAuthProvider, signInWithPopup, onAuthStateChanged, User } from "firebase/auth";
            import { auth } from "./firebase";

            export default function Login() {
              const [user, setUser] = useState<User | null>(null);

              useEffect(() => {
                const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
                  setUser(currentUser);
                });
                return () => unsubscribe();
              }, []);

              const handleLogin = async () => {
                const provider = new GoogleAuthProvider();
                try {
                  await signInWithPopup(auth, provider);
                } catch (error) {
                  console.error(error);
                }
              };

              const handleLogout = async () => {
                try {
                  await auth.signOut();
                } catch (error) {
                  console.error(error);
                }
              };

              return (
                <div>
                  {user ? (
                    <div className=\'flex justify-center items-center gap-4\'>
                      <p>{user.displayName}</p>
                      <button onClick={handleLogout} className="py-2 px-4 bg-red-500 text-white rounded-lg">
                        Sign Out
                      </button>
                    </div>
                  ) : (
                    <button onClick={handleLogin} className="py-2 px-4 bg-blue-500 text-white rounded-lg">
                      Login
                    </button>
                  )}
                </div>
              );
            }
            EOF

            mainPageFile=""
            importPath=""
            if ${app}; then
              mainPageFile="$baseDir/app/page.${language}x"
              importPath="../login"
              if [ ! -f "$mainPageFile" ]; then
                mainPageFile="$baseDir/app/page.${language}"
              fi
            else
              mainPageFile="$baseDir/pages/index.${language}x"
              importPath="./login"
              if [ ! -f "$mainPageFile" ]; then
                 mainPageFile="$baseDir/pages/index.${language}"
              fi
            fi

            if [ -f "$mainPageFile" ]; then
              if ${app}; then
                # Prepend 'use client'; if it's not there.
                grep -qxF "'use client';" "$mainPageFile" || sed -i "1i 'use client';" "$mainPageFile"
              fi
              # Add the import statement. The sed script is in double quotes.
              sed -i "0,/import/s|import|import Login from ''${importPath}''\nimport|" "$mainPageFile"
              # Add the Login component. The sed script is in single quotes to handle the double quotes in the className.
              sed -i '0,/<main/s|<main|<div className="absolute top-4 left-4"><Login /></div>\n<main|' "$mainPageFile"
            fi
          ''
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
