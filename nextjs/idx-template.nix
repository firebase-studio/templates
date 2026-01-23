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
          importAliasRoot = builtins.replaceStrings ["/*"] [""] importAlias;
        in
          ''
            (cd "$out" && ${packageManager} ${installCmd} firebase)

            baseDir="$out"
            if ${builtins.toString srcDir}; then
              baseDir="$out/src"
            fi
            
            mkdir -p "$baseDir/lib"
            mkdir -p "$baseDir/components"

            cat <<EOF > "$baseDir/lib/firebase.ts"
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

            cat <<EOF > "$baseDir/components/login.tsx"
            'use client';

            import { useState } from 'react';
            import { signInWithPopup, GoogleAuthProvider, User } from 'firebase/auth';
            import { auth } from '../lib/firebase';
            import Image from 'next/image';

            export default function Login() {
              const [user, setUser] = useState<User | null>(null);

              const handleLogin = async () => {
                const provider = new GoogleAuthProvider();
                try {
                  const result = await signInWithPopup(auth, provider);
                  setUser(result.user);
                } catch (error) {
                  console.error('Error during sign-in:', error);
                }
              };

              const handleLogout = async () => {
                try {
                  await auth.signOut();
                  setUser(null);
                } catch (error) {
                  console.error('Error during sign-out:', error);
                }
              };

              return (
                <div>
                  {user ? (
                    <div className="flex items-center gap-4">
                      <p>Welcome, {user.displayName}</p>
                      <button
                        onClick={handleLogout}
                        className="flex h-12 items-center justify-center rounded-full border border-solid border-black/[.08] px-5 transition-colors hover:border-transparent hover:bg-black/[.04] dark:border-white/[.145] dark:hover:bg-[#1a1a1a]"
                      >
                        Logout
                      </button>
                    </div>
                  ) : (
                    <button
                      onClick={handleLogin}
                      className="flex h-12 items-center justify-center gap-2 rounded-full bg-foreground px-5 text-background transition-colors hover:bg-[#383838] dark:hover:bg-[#ccc]"
                    >
                      <Image
                        className="dark:invert"
                        src="/globe.svg"
                        alt="Google logomark"
                        width={16}
                        height={16}
                      />
                      Login with Google
                    </button>
                  )}
                </div>
              );
            }

            EOF

            mainPageFile=""
            importPath="${importAliasRoot}/components/login"
            if ${builtins.toString app}; then
              mainPageFile="$baseDir/app/page.${language}x"
              if [ ! -f "$mainPageFile" ]; then
                mainPageFile="$baseDir/app/page.${language}"
              fi
            else
              mainPageFile="$baseDir/pages/index.${language}x"
              if [ ! -f "$mainPageFile" ]; then
                 mainPageFile="$baseDir/pages/index.${language}"
              fi
            fi

            if [ -f "$mainPageFile" ]; then
              if ${builtins.toString app}; then
                # Prepend 'use client'; if it's not there.
                grep -qxF "'use client';" "$mainPageFile" || sed -i "1i 'use client';" "$mainPageFile"
              fi
              # Add the import statement. The sed script is in double quotes.
              sed -i "0,/import/s|import|import Login from ''$importPath''\\nimport|" "$mainPageFile"
              # Add the Login component. The sed script is in single quotes to handle the double quotes in the className.
              sed -i '0,/<main/s|<main|<div className="absolute top-4 left-4"><Login /></div>\\n<main|' "$mainPageFile"
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
