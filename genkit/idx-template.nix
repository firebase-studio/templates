/*
rm -rf ./test && \
idx-template \
  /home/user/templates \
  --output-dir /home/user/g/test -a '{ "language": "js" }'
*/
{pkgs, language ? "js", ... }: {  
  packages = [
    pkgs.nodejs
    pkgs.go
  ];
  bootstrap = ''
    mkdir "$out"
    mkdir "$out"/.idx
    cp -r ${./.idx}/. "$out/.idx/"
    cp -f ${./package.json} "$out/package.json"
    cp -f ${./package-lock.json} "$out/package-lock.json"
    cp -f ${./index.ts} "$out/index.ts"
    cp -f ${./schema.ts} "$out/schema.ts"
    cp -f ${./tools.ts} "$out/tools.ts"
    cp -f ${./.gitignore} "$out/.gitignore"
    cp ${./README.md} "$out"/README.md
    ${if language == "go" then "env -C \"$out\" go mod init genkit" else "" }
   
    chmod -R u+w "$out"
    cp ${./.idx/airules.md} "$out/.idx/airules.md"
    cp ${./.idx/airules.md} "$out/GEMINI.md"
    chmod -R u+w "$out"
   
  '';
}