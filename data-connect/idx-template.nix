
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

  import Image from "next/image";
  import { useState } from 'react';
  import { auth } from '../firebase';
  import { signInWithPopup, GoogleAuthProvider } from "firebase/auth";
  import type { User } from "firebase/auth";

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
        <main className="relative flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
          {/* Login/Logout Section */}
          <div className="absolute top-4 right-4">
            {user ? (
              <div className="flex items-center gap-4">
                <p className="text-zinc-600 dark:text-zinc-400">Welcome, {user.displayName}</p>
                <button 
                  onClick={handleLogout}
                  className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
                >
                  Logout
                </button>
              </div>
            ) : (
              <button 
                onClick={handleLogin}
                className="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
              >
                Login with Google
              </button>
            )}
          </div>

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
            </p>
          </div>
        </main>
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
      if sample == "nextjs-movie-app" then "
        mv \"$out\"/app/src/lib/firebase.idx.tsx \"$out\"/app/src/lib/firebase.tsx  
        mv \"$out\"/app/vite.config.idx.ts \"$out\"/app/vite.config.ts 
        rm \"$out\"/app/index.html
      " else ""
    }
    cp ${./.firebaserc} "$out"/.firebaserc
    cp ${./.graphqlrc.yaml} "$out"/.graphqlrc.yaml
    mkdir "$out"/.vscode
    cp ${./.vscode/settings.json} "$out"/.vscode/settings.json
    chmod -R u+w "$out"
  '';
}
