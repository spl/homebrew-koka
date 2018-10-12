require "language/haskell"

class KokaAT060Dev < Formula
  include Language::Haskell::Cabal

  desc "Function-oriented language seperating pure values from side-effects"
  homepage "https://github.com/koka-lang/koka"
  url "https://github.com/koka-lang/koka/archive/v0.6.0-dev.tar.gz"
  version "0.6.0-dev"
  sha256 "a83445caafbf82bacf43defd367320c7848c2cdac4b2cf27ddaf57262a19a911"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Add a koka.cabal file for building with cabal-install.
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/koka-0.6.0-dev-cabal.patch"
    sha256 "26c88ad8c6f8de7717c64970a55de5d37d9ca65968cc93fd7d2856a6b8d826d8"
  end

  # Hide the (<>) Prelude import to work with newer GHC versions.
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/koka-0.6.0-dev-imports.patch"
    sha256 "4ad34a372834df7972f5cedefe063ec783d400f7ff45c0c0b946ea025dad02ad"
  end

  def install
    ENV["VERSION"] = "#{version}"
    ENV["VARIANT"] = "release"

    # Build and install the package.
    install_cabal_package :using => "alex"

    # Install the contrib and lib directories.
    (lib/"koka-#{version}").install Dir["contrib", "lib"]

    # Move the executable for the wrapper script below.
    (bin/"koka").rename (lib/"koka-#{version}"/"koka")

    # Koka has hardcoded dependencies on being at the same level as the library.
    # We would prefer using just -i<lib-dir>, but that doesn't fix the problem.
    # Consequently, we run Koka directly in the library directory.
    (bin/"koka-#{version}").write <<~SH
      #!/bin/bash
      cd /usr/local/lib/koka-#{version}
      echo "Running in '$PWD' ..."
      ./koka -ilib "$@"
    SH
  end

end
