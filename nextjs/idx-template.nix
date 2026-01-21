{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts"
, packageManager ? "npm", srcDir ? false, eslint ? false, app ? false
, tailwind ? false, firebase-tool ? false, firebase-project-id ? null, firebase-auth-id ? null
, ... }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun pkgs.gnused ]
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
				mkdir -p "$APP_DIR/components"

				FILE_EXT=${if language == "ts" then "'ts'" else "'js'"}
				CONFIG_FILE="$APP_DIR/lib/firebase.$FILE_EXT"
				LOGIN_COMPONENT_FILE="$APP_DIR/components/Login.${if language == "ts" then "tsx" else "jsx"}"

				cat <<EOF > "$CONFIG_FILE"
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
const firebaseConfig = {
  apiKey: "${if firebase-auth-id != null then firebase-auth-id else "YOUR_API_KEY"}",
  authDomain: "${if firebase-project-id != null then ''\'\'"${firebase-project-id}.firebaseapp.com"\'\'\' else "YOUR_PROJECT_ID.firebaseapp.com"}",
  projectId: "${if firebase-project-id != null then firebase-project-id else "YOUR_PROJECT_ID"}",
  storageBucket: "${if firebase-project-id != null then ''\'\'"${firebase-project-id}.appspot.com"\'\'\' else "YOUR_PROJECT_ID.appspot.com"}",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
EOF

				cat <<'EOF' > "$LOGIN_COMPONENT_FILE"
'use client';

import { useState, useEffect } from 'react';
import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  onAuthStateChanged,
  signOut,
  User,
} from 'firebase/auth';
import { auth } from 'FIREBASE_IMPORT_PLACEHOLDER';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
    });
    return () => unsubscribe();
  }, []);

  const handleSignUp = async () => {
    try {
      await createUserWithEmailAndPassword(auth, email, password);
    } catch (error) {
      console.error('Error signing up:', error);
    }
  };

  const handleLogin = async () => {
    try {
      await signInWithEmailAndPassword(auth, email, password);
    } catch (error) {
      console.error('Error logging in:', error);
    }
  };

  const handleLogout = async () => {
    try {
      await signOut(auth);
    } catch (error) {
      console.error('Error logging out:', error);
    }
  };

  return (
    <div>
      {user ? (
        <div>
          <p>Welcome, {user.email}</p>
          <button onClick={handleLogout}>Logout</button>
        </div>
      ) : (
        <div>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Email"
          />
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Password"
          />
          <button onClick={handleSignUp}>Sign Up</button>
          <button onClick={handleLogin}>Login</button>
        </div>
      )}
    </div>
  );
}
EOF
				FIREBASE_IMPORT_PATH=$(echo "${importAlias}" | sed 's,\*.*,lib/firebase,')
				sed -i "s,FIREBASE_IMPORT_PLACEHOLDER,${FIREBASE_IMPORT_PATH}," "$LOGIN_COMPONENT_FILE"

				LOGIN_IMPORT_PATH=$(echo "${importAlias}" | sed 's,\*.*,components/Login,')
				if [ ${app} = "true" ]; then
				  MAIN_PAGE_FILE="$APP_DIR/app/page.${if language == "ts" then "tsx" else "jsx"}"
					cat <<EOF > "$MAIN_PAGE_FILE"
import Login from '${LOGIN_IMPORT_PATH}';

export default function Home() {
  return (
    <main>
      <h1>Next.js + Firebase</h1>
      <Login />
    </main>
  );
}
EOF
				else
				  MAIN_PAGE_FILE="$APP_DIR/pages/index.${if language == "ts" then "tsx" else "jsx"}"
					cat <<EOF > "$MAIN_PAGE_FILE"
import Login from '${LOGIN_IMPORT_PATH}';

export default function Home() {
  return (
    <div>
      <h1>Next.js + Firebase</h1>
      <Login />
    </div>
  );
}
EOF
				fi
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
