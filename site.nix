{
  self,
  stdenv,
  hugo,
  fetchFromGitHub,
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
      rev = "v2.11.0";
      sha256 = "sha256-30eyLI/U4pVMLBGCI4Rjt/GuwiHv3IuffosZB8dt6GA=";
    })
  ];

  sourceRoot = "source";

  unpackPhase = ''
    runHook preUnpack

    for _src in $srcs; do
       cp -r "$_src" $(stripHash "$_src")
    done

    chmod --recursive 777 source
    cp -r congo source/personal-site/themes

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
