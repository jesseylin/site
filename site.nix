{
  self,
  stdenv,
  hugo,
  congo,
  progress-bar-site,
}:
stdenv.mkDerivation rec {
  name = "jesseylin.com";
  version = "1.0";

  src = self;

  sourceRoot = "source";

  unpackPhase = ''
    runHook preUnpack

    cp -r "$src" source
    chmod --recursive 777 source

    # The congo theme is tracked as a git submodule under
    # personal-site/themes/congo AND also pinned as an input. cp -rT forces
    # "treat dest as the target, not as a parent" regardless of whether it
    # already exists, so there is no problem regardless of the local state of
    # the `self` flake as a repo.

    mkdir -p source/personal-site/themes
    cp -rT ${congo} source/personal-site/themes/congo

    runHook postUnpack
  '';

  nativeBuildInputs = [hugo];

  buildPhase = ''
    ${hugo}/bin/hugo --gc --minify --source personal-site
  '';

  installPhase = ''
    mkdir -p $out/var/www/${name}
    cp -r personal-site/public/. $out/var/www/${name}
    mkdir -p $out/var/www/${name}/progress-bar
    cp -r ${progress-bar-site}/. $out/var/www/${name}/progress-bar
  '';
}
