
/*

rm -rf ./test && \
idx-template \
  /home/user/community-templates/dataconnect \
  --output-dir /home/user/community-templates/template-test -a '{}'

*/
{pkgs, platform ? "web", appType ? "blank", ... }: {
  packages = [
    pkgs.nodejs_20
  ];

  bootstrap = let 
    platformPrefix = if platform == "web" then "nextjs" else "flutter";
    suffix = if platform == "web" && appType == "quickstart" then "movie-app" else if platform == "flutter" && appType == "quickstart" then "movie" else appType;
    sample = "${platformPrefix}-${suffix}";
    in ''
    mkdir "$out"
    chmod -R u+w "$out"
    mkdir "$out"/.idx
    
    ${
    if sample == "flutter-blank" || sample == "flutter-movie" then "cp -r ${./flutter}/dev.nix \"$out\"/.idx/dev.nix"
      else "cp ${./.}/${sample}/dev.nix \"$out\"/.idx/dev.nix"
    }
    
    ${
      if sample == "nextjs-movie-app" then "cp -r ${./nextjs-movie-app}/* \"$out\""
      else if sample == "nextjs-blank" then ''
        cp -r ${./nextjs-blank}/* "$out"
  cat <<EOF > "$out/webapp/src/app/page.tsx"
  'use client';

  import { useState } from 'react';
  import { auth } from '../firebase';
  import { signInWithPopup, GoogleAuthProvider } from "firebase/auth";
  import type { User } from "firebase/auth";
  import Image from "next/image";
  import Login from './Login';

  export default function Home() {
    const [user, setUser] = useState<User | null>(null);

    const handleLogin = async () => {
      const provider = new GoogleAuthProvider();
      try {
        const result = await signInWithPopup(auth, provider);
        setUser(result.user);
      } catch (error) {
        console.error(error);
      }
    };

    const handleLogout = async () => {
      try {
        await auth.signOut();
        setUser(null);
      } catch (error) {
        console.error(error);
      }
    };

    return (
      <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
        <div className="absolute top-4 left-4">
          <Login />
        </div>
        <main className="flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
          <div className="flex w-full justify-between items-center">
            <Image
              className="dark:invert"
              src="/next.svg"
              alt="Next.js logo"
              width={100}
              height={20}
              priority
            />
            <div>
              {user ? (
                <div className="flex items-center gap-4">
                  <p>Welcome, {user.displayName}</p>
                  <button onClick={handleLogout} className="px-4 py-2 bg-blue-500 text-white rounded-md">Logout</button>
                </div>
              ) : (
                <button onClick={handleLogin} className="px-4 py-2 bg-blue-500 text-white rounded-md">Login with Google</button>
              )}
            </div>
          </div>
          <div className="flex flex-col items-center gap-6 text-center sm:items-start">
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
                className="dark:invert h-auto"
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
  cat <<EOF > "$out/webapp/src/app/firebase.ts"
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
  cat <<EOF > "$out/webapp/src/app/login.tsx"
  "use client";

  import { useState, useEffect } from 'react';
  import { GoogleAuthProvider, signInWithPopup, onAuthStateChanged, User } from 'firebase/auth';
  import { auth } from '../firebase';

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
          <div className='flex justify-center items-center gap-4'>
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
      ''
      else if sample == "flutter-blank" then "cp -r ${./flutter-blank}/* \"$out\""
      else "cp -r ${./flutter-movie}/* \"$out\""
    }
    chmod -R u+w "$out"
    ${
      if sample == "flutter-blank" || sample == "flutter-movie" then "cp ${./flutter}/Caddyfile \"$out\"/" else ""
    }
    ${
      if sample == "flutter-blank" || sample == "flutter-movie" then "cp ${./flutter}/error_handler.dart \"$out\"/lib/" else ""
    }
    ${
      if sample == "nextjs-movie-app" then "\n        mv \"$out\"/app/src/lib/firebase.idx.tsx \"$out\"/app/src/lib/firebase.tsx  \n        mv \"$out\"/app/vite.config.idx.ts \"$out\"/app/vite.config.ts \n        rm \"$out\"/app/index.html\n      " else ""
    }
    cp ${./.firebaserc} "$out"/.firebaserc
    cp ${./.graphqlrc.yaml} "$out"/.graphqlrc.yaml
    mkdir "$out"/.vscode
    cp ${./.vscode/settings.json} "$out"/.vscode/settings.json
    chmod -R u+w "$out"
  '';
}
