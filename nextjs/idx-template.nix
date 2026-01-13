{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts"
, packageManager ? "npm", srcDir ? false, eslint ? false, app ? false
, tailwind ? false, firebase-tool ? false, firebase-project-id ? "" }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun ];

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
      if packageManager == "npm" then
        "( cd $out && npm i --package-lock-only --ignore-scripts )"
      else
        ""
    }

    ${
      if firebase-tool && firebase-project-id != "" then ''
        (
          cd "$out"
          npm install firebase
        )

        echo '{
          "hosting": {
            "source": ".",
            "ignore": [
              "firebase.json",
              "**/.*",
              "**/node_modules/**"
            ],
            "frameworksBackend": {
              "region": "us-central1"
            }
          }
        }' > "$out/firebase.json"

        echo '{
          "projects": {
            "default": "${firebase-project-id}"
          }
        }' > "$out/.firebaserc"

        libDir="$out/${if srcDir then "src/" else ""}lib"
        mkdir -p "$libDir"

        # The user has to replace these with their actual firebase config values
        echo "
        // Import the functions you need from the SDKs you need
        import { initializeApp } from ''firebase/app'';
        // TODO: Add SDKs for Firebase products that you want to use
        // https://firebase.google.com/docs/web/setup#available-libraries

        // Your web app''s Firebase configuration
        const firebaseConfig = {
          apiKey: ''YOUR_API_KEY'',
          authDomain: ''YOUR_AUTH_DOMAIN'',
          projectId: ''${firebase-project-id}'',
          storageBucket: ''YOUR_STORAGE_BUCKET'',
          messagingSenderId: ''YOUR_MESSAGING_SENDER_ID'',
          appId: ''YOUR_APP_ID''
        };

        // Initialize Firebase
        export const app = initializeApp(firebaseConfig);
        " > "$libDir/firebase.${if language == "ts" then "ts" else "js"}"
      '' else ''
        # Not using firebase or no project id provided
      ''
    }
  '';
}