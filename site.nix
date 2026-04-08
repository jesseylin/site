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
    # The congo theme is tracked as a git submodule under
    # personal-site/themes/congo AND also pinned via fetchFromGitHub above.
    # This means `self` and the fetched source both lay claim to the same
    # destination path, and the state of that path in `self` can vary
    # between build environments. `cp -rT` forces "treat dest as the
    # target, not as a parent" regardless of whether it already exists,
    # which is the only form of the copy that's unambiguous across the
    # two inputs.
    cp -rT congo source/personal-site/themes/congo

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
    cp -r ${progress-bar}/. $out/var/www/${name}/progress-bar
  '';
}
