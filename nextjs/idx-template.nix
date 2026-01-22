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

            cat <<EOF > "$baseDir/app/page.tsx"
'use client';
import Login from '../../components/login';
import Image from 'next/image';

export default function Home() {
  return (
    <>
      <div className="absolute top-4 left-4"><Login /></div>
      <main className="flex min-h-screen flex-col items-center justify-between p-24">
        <div className="z-10 w-full max-w-5xl items-center justify-between font-mono text-sm lg:flex">
          <p className="fixed left-0 top-0 flex w-full justify-center border-b border-gray-300 bg-gradient-to-b from-zinc-200 pb-6 pt-8 backdrop-blur-2xl dark:border-neutral-800 dark:bg-zinc-800/30 dark:from-inherit lg:static lg:w-auto  lg:rounded-xl lg:border lg:bg-gray-200 lg:p-4 lg:dark:bg-zinc-800/30">
            Get started by editing&nbsp;
            <code className="font-mono font-bold">src/app/page.tsx</code>
          </p>
          <div className="fixed bottom-0 left-0 flex h-48 w-full items-end justify-center bg-gradient-to-t from-white via-white dark:from-black dark:via-black lg:static lg:size-auto lg:bg-none">
            <a
              className="pointer-events-none flex place-items-center gap-2 p-8 lg:pointer-events-auto lg:p-0"
              href="https://vercel.com?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app"
              target="_blank"
              rel="noopener noreferrer"
            >
              By{' '}
              <Image
                src="/vercel.svg"
                alt="Vercel Logo"
                className="dark:invert"
                width={100}
                height={24}
                priority
              />
            </a>
          </div>
        </div>

        <div className="relative z-[-1] flex place-items-center before:absolute before:h-[300px] before:w-full before:-translate-x-1/2 before:rounded-full before:bg-gradient-radial before:from-white before:to-transparent before:blur-2xl before:content-[''] after:absolute after:-z-20 after:h-[180px] after:w-full after:translate-x-1/3 after:bg-gradient-conic after:from-sky-200 after:via-blue-200 after:blur-2xl after:content-[''] before:dark:bg-gradient-to-br before:dark:from-transparent before:dark:to-blue-700 before:dark:opacity-10 after:dark:from-sky-900 after:dark:via-[#0141ff] after:dark:opacity-40 sm:before:w-[480px] sm:after:w-[240px] before:lg:h-[360px]">
          <Image
            className="relative dark:drop-shadow-[0_0_0.3rem_#ffffff70] dark:invert"
            src="/next.svg"
            alt="Next.js Logo"
            width={180}
            height={37}
            priority
          />
        </div>

        <div className="mb-32 grid text-center lg:mb-0 lg:w-full lg:max-w-5xl lg:grid-cols-4 lg:text-left">
          <a
            href="https://nextjs.org/docs?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app"
            className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30"
            target="_blank"
            rel="noopener noreferrer"
          >
            <h2 className="mb-3 text-2xl font-semibold">
              Docs{' '}
              <span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
                -&gt;
              </span>
            </h2>
            <p className="m-0 max-w-[30ch] text-sm opacity-50">
              Find in-depth information about Next.js features and API.
            </p>
          </a>

          <a
            href="https://nextjs.org/learn?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app"
            className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30"
            target="_blank"
            rel="noopener noreferrer"
          >
            <h2 className="mb-3 text-2xl font-semibold">
              Learn{' '}
              <span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
                -&gt;
              </span>
            </h2>
            <p className="m-0 max-w-[30ch] text-sm opacity-50">
              Learn about Next.js in an interactive course with&nbsp;quizzes!
            </p>
          </a>

          <a
            href="https://vercel.com/templates?framework=next.js&utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app"
            className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30"
            target="_blank"
            rel="noopener noreferrer"
          >
            <h2 className="mb-3 text-2xl font-semibold">
              Templates{' '}
              <span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
                -&gt;
              </span>
            </h2>
            <p className="m-0 max-w-[30ch] text-sm opacity-50">
              Explore starter templates for Next.js.
            </p>
          </a>

          <a
            href="https://vercel.com/new?utm_source=create-next-app&utm_medium=appdir-template&utm_campaign=create-next-app"
            className="group rounded-lg border border-transparent px-5 py-4 transition-colors hover:border-gray-300 hover:bg-gray-100 hover:dark:border-neutral-700 hover:dark:bg-neutral-800/30"
            target="_blank"
            rel="noopener noreferrer"
          >
            <h2 className="mb-3 text-2xl font-semibold">
              Deploy{' '}
              <span className="inline-block transition-transform group-hover:translate-x-1 motion-reduce:transform-none">
                -&gt;
              </span>
            </h2>
            <p className="m-0 max-w-[30ch] text-balance text-sm opacity-50">
              Instantly deploy your Next.js site to a shareable URL with Vercel.
            </p>
          </a>
        </div>
      </main>
    </>
  );
}
EOF
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
