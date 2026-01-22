{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts"
, packageManager ? "npm", srcDir ? false, eslint ? false, app ? false
, tailwind ? false, firebaseTool ? false, ... }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun ]
    ++ (if firebaseTool then [ pkgs.nodePackages.firebase-tools ] else [ ]);

  bootstrap = ''
    set -e
    mainPageFile=""
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

    if [ "${builtins.toString firebaseTool}" = "true" ]; then
      ${let
        installCmd = if packageManager == "npm" then "install" else "add";
        importAliasRoot = builtins.replaceStrings ["/*"] [""] importAlias;
      in
        ''
          (cd "$out" && ${packageManager} ${installCmd} firebase)

          baseDir="$out"
          if [ "${builtins.toString srcDir}" = "true" ]; then
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

          import { useState, useEffect } from 'react';
          import { GoogleAuthProvider, signInWithPopup, onAuthStateChanged, User } from 'firebase/auth';
          import { auth } from '${importAliasRoot}/lib/firebase';
          import Image from 'next/image';

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

          importPath="${importAliasRoot}/components/login"
          if [ "${builtins.toString app}" = "true" ]; then
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
            if [ "${builtins.toString app}" = "true" ]; then
              cat <<EOF > "$mainPageFile"
'use client';

import Image from "next/image";
import Login from "${importAliasRoot}/components/login";

export default function Home() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        <Login />
        <Image
          className="dark:invert"
          src="/next.svg"
          alt="Next.js logo"
          width={100}
          height={20}
          priority
        />
        <div className="flex flex-col items-center gap-6 text-center sm:items-start sm:text-left">
          <h1 className="max-w-xs text-3xl font-semibold leading-10 tracking-tight text-black dark:text-zinc-50">
            To get started, edit the page.tsx file.
          </h1>
          <p className="max-w-md text-lg leading-8 text-zinc-600 dark:text-zinc-400">
            Looking for a starting point or more instructions? Head over to{" "}
            <a
              href="https://vercel.com/templates?framework=next.js&utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
              className="font-medium text-zinc-950 dark:text-zinc-50"
            >
              Templates
            </a>{" "}
            or the{" "}
            <a
              href="https://nextjs.org/learn?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
              className="font-medium text-zinc-950 dark:text-zinc-50"
            >
              Learning
            </a>{" "}
            center.
          </p>
        </div>
        <div className="flex flex-col gap-4 text-base font-medium sm:flex-row">
          <a
            className="flex h-12 w-full items-center justify-center gap-2 rounded-full bg-foreground px-5 text-background transition-colors hover:bg-[#383838] dark:hover:bg-[#ccc] md:w-[158px]"
            href="https://vercel.com/new?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              className="dark:invert"
              src="/vercel.svg"
              alt="Vercel logomark"
              width={16}
              height={16}
            />
            Deploy Now
          </a>
          <a
            className="flex h-12 w-full items-center justify-center rounded-full border border-solid border-black/[.08] px-5 transition-colors hover:border-transparent hover:bg-black/[.04] dark:border-white/[.145] dark:hover:bg-[#1a1a1a] md:w-[158px]"
            href="https://nextjs.org/docs?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            Documentation
          </a>
        </div>
      </main>
    </div>
  );
}
EOF
            else
              cat <<EOF > "$mainPageFile"
import Image from "next/image";
import Login from "${importAliasRoot}/components/login";

export default function Home() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        <Login />
        <Image
          className="dark:invert"
          src="/next.svg"
          alt="Next.js logo"
          width={100}
          height={20}
          priority
        />
        <div className="flex flex-col items-center gap-6 text-center sm:items-start sm:text-left">
          <h1 className="max-w-xs text-3xl font-semibold leading-10 tracking-tight text-black dark:text-zinc-50">
            To get started, edit the page.tsx file.
          </h1>
          <p className="max-w-md text-lg leading-8 text-zinc-600 dark:text-zinc-400">
            Looking for a starting point or more instructions? Head over to{" "}
            <a
              href="https://vercel.com/templates?framework=next.js&utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
              className="font-medium text-zinc-950 dark:text-zinc-50"
            >
              Templates
            </a>{" "}
            or the{" "}
            <a
              href="https://nextjs.org/learn?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
              className="font-medium text-zinc-950 dark:text-zinc-50"
            >
              Learning
            </a>{" "}
            center.
          </p>
        </div>
        <div className="flex flex-col gap-4 text-base font-medium sm:flex-row">
          <a
            className="flex h-12 w-full items-center justify-center gap-2 rounded-full bg-foreground px-5 text-background transition-colors hover:bg-[#383838] dark:hover:bg-[#ccc] md:w-[158px]"
            href="https://vercel.com/new?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              className="dark:invert"
              src="/vercel.svg"
              alt="Vercel logomark"
              width={16}
              height={16}
            />
            Deploy Now
          </a>
          <a
            className="flex h-12 w-full items-center justify-center rounded-full border border-solid border-black/[.08] px-5 transition-colors hover:border-transparent hover:bg-black/[.04] dark:border-white/[.145] dark:hover:bg-[#1a1a1a] md:w-[158px]"
            href="https://nextjs.org/docs?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            Documentation
          </a>
        </div>
      </main>
    </div>
  );
}
EOF
            fi
          fi
        ''}
    fi

    if [ "${packageManager}" = "npm" ]; then
      ( cd $out && npm i --package-lock-only --ignore-scripts )
    fi
  '';
}
