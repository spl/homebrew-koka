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

    # koka with version appended
    koka_ver = "koka-#{version}"

    # Install the contrib and lib directories.
    (lib/koka_ver).install Dir["contrib", "lib"]

    # Move the executable for the wrapper script below.
    (bin/"koka").rename (lib/koka_ver/"koka")

    # Absolute Koka library directory path
    absdir = "#{HOMEBREW_PREFIX}/lib/#{koka_ver}"

    # Koka expects include paths to be relative. We convert the absolute library
    # path to a relative path using Python: https://stackoverflow.com/a/7305217
    (bin/koka_ver).write <<~EOS
      #!/bin/bash
      RELDIR=$(python -c "import os.path,sys; assert sys.version_info>=(2,6); print os.path.relpath('#{absdir}/lib','.')")
      #{absdir}/koka -i$RELDIR "$@"
    EOS
  end

  def caveats
    <<~EOS
      Include paths (via -i or --include) must be relative to the current path.
      In particular, you should prepend the appropriate number of ../ to paths
      such as /usr/local/lib to make an absolute path relative.

      See the formula for an alternative method using Python.
    EOS
  end

end
