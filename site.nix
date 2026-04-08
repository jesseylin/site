{
  self,
  stdenv,
  hugo,
  fetchFromGitHub,
  progress-bar,
}:
stdenv.mkDerivation rec {
  name = "jesseylin.com";
  version = "1.0";

  srcs = [
    self
    (fetchFromGitHub {
      name = "congo";
      owner = "jpanther";
      repo = "congo";
      rev = "b4b6bf644b87326b5dfa2239c2751436890e06ea";
      sha256 = "sha256-u3/tffYScdPsv54RDdhu/aVKqSqXqFrcH7MxtjGZIsE=";
    })
  ];

  sourceRoot = "source";

  unpackPhase = ''
    runHook preUnpack

    for _src in $srcs; do
       cp -r "$_src" $(stripHash "$_src")
    done

    chmod --recursive 777 source
    mkdir -p source/personal-site/themes
    cp -r congo source/personal-site/themes/congo

    runHook postUnpack
  '';

  nativeBuildInputs = [hugo];

  buildPhase = ''
    ${hugo}/bin/hugo --gc --minify --source personal-site
  '';

  installPhase = ''
    mkdir -p $out/var/www/${name}
    cp -r personal-site/public/. $out/var/www/${name}
  '';
}
