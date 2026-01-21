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

				# If firebase-auth-id is provided, scaffold a simple Firebase email/password login feature using Next.js routing
				${if firebase-auth-id != null then ''
					# Choose React file extension for pages/app router
					REACT_EXT=${if language == "ts" then "'tsx'" else "'js'"}

					# Create a small stylesheet used by the auth pages
					mkdir -p "$APP_DIR/styles"
					cat <<'CSS_EOF' > "$APP_DIR/styles/auth.css"
html, body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial;
}
.auth-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}
.auth-card {
  width: 100%;
  max-width: 420px;
  border: 1px solid #e6e6e6;
  border-radius: 8px;
  padding: 1.25rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}
.auth-card h3 { margin: 0 0 1rem 0; }
.auth-field { margin-bottom: 0.75rem; }
.auth-error { color: #b00020; margin-bottom: 0.5rem; }
.auth-btn { width: 100%; padding: 0.5rem 0; border: none; background: #0366d6; color: white; border-radius: 6px; cursor: pointer; }
CSS_EOF

					# Create pages-router or app-router files depending on `app` flag
					${if app then ''
						# app router: create app/layout and app/login/page using next/navigation
						mkdir -p "$APP_DIR/app/login" "$APP_DIR/lib"
						cat <<EOF > "$APP_DIR/app/layout.$REACT_EXT"
import '../styles/auth.css';
export const metadata = { title: 'App' };
export default function RootLayout({ children }) {
  return <html lang="en"><body>{children}</body></html>;
}
EOF

						cat <<EOF > "$APP_DIR/app/login/page.$REACT_EXT"
"use client";
import React, { useState } from "react";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../../lib/firebase";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      await signInWithEmailAndPassword(auth, email, password);
      // use Next.js app router navigation
      router.push("/");
    } catch (err) {
      setError(err.message || "Failed to sign in");
      setLoading(false);
    }
  };

  return (
    <div className="auth-container">
      <div className="auth-card">
        <h3>Sign in</h3>
        {error && <div className="auth-error">{error}</div>}
        <form onSubmit={handleSubmit}>
          <div className="auth-field">
            <label>Email</label>
            <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" style={{width:"100%", padding:"8px", boxSizing:"border-box"}} required/>
          </div>
          <div className="auth-field">
            <label>Password</label>
            <input value={password} onChange={(e) => setPassword(e.target.value)} type="password" style={{width:"100%", padding:"8px", boxSizing:"border-box"}} required/>
          </div>
          <button className="auth-btn" type="submit" disabled={loading}>{loading ? "Signing in..." : "Sign in"}</button>
        </form>
      </div>
    </div>
  );
}
EOF
					'' else ''
						# pages router: create pages/_app and pages/login using next/router
						mkdir -p "$APP_DIR/pages" "$APP_DIR/lib"
						cat <<EOF > "$APP_DIR/pages/_app.$REACT_EXT"
import '../styles/auth.css';
${if language == "ts" then "import type { AppProps } from 'next/app';\n\nexport default function MyApp({ Component, pageProps }: AppProps) {\n  return <Component {...pageProps} />;\n}\n" else "export default function MyApp({ Component, pageProps }) {\n  return <Component {...pageProps} />;\n}\n"}
EOF

						cat <<EOF > "$APP_DIR/pages/login.$REACT_EXT"
import React, { useState } from "react";
import { useRouter } from "next/router";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../lib/firebase";

export default function Login() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    try {
      await signInWithEmailAndPassword(auth, email, password);
      // use Next.js pages router navigation
      router.push("/");
    } catch (err) {
      setError(err.message || "Failed to sign in");
      setLoading(false);
    }
  };

  return (
    <div className="auth-container">
      <div className="auth-card">
        <h3>Sign in</h3>
        {error && <div className="auth-error">{error}</div>}
        <form onSubmit={handleSubmit}>
          <div className="auth-field">
            <label>Email</label>
            <input value={email} onChange={(e) => setEmail(e.target.value)} type="email" style={{width:"100%", padding:"8px", boxSizing:"border-box"}} required/>
          </div>
          <div className="auth-field">
            <label>Password</label>
            <input value={password} onChange={(e) => setPassword(e.target.value)} type="password" style={{width:"100%", padding:"8px", boxSizing:"border-box"}} required/>
          </div>
          <button className="auth-btn" type="submit" disabled={loading}>{loading ? "Signing in..." : "Sign in"}</button>
        </form>
      </div>
    </div>
  );
}
EOF
					''}

				'' else ""}

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