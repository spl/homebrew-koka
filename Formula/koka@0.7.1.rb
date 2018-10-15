require "language/haskell"

class KokaAT071 < Formula
  include Language::Haskell::Cabal

  desc "Function-oriented language seperating pure values from side-effects"
  homepage "https://github.com/koka-lang/koka"
  url "https://github.com/koka-lang/koka/archive/v0.7.1.tar.gz"
  sha256 "86ec61d7293e4d417d518b7181e97fc6d798c66bc025277ca9a92354f80dd02f"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  # Add a koka.cabal file for building with cabal-install.
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/koka-0.7.1-cabal.patch"
    sha256 "f853bde17a83ce18a601c2fc5ce85dab1debcb5d4190b4dc058798cd123c0aca"
  end

  # Hide the (<>) Prelude import to work with newer GHC versions.
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/koka-0.7.1-imports.patch"
    sha256 "2b02ba397c0478bf9244903c2dd524396ada9ea8db7fc091fe58597e2bccfc62"
  end

  # Make the contrib/biginteger.js path absolute.
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/koka-0.7.1-std-core.patch"
    sha256 "2d0ccc442a46e13c10ef7aa0a2a13c1e2252d1c52434373bf4cfff6ccb4d2260"
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
      such as /usr/local/lib/koka-#{version} to make an absolute path relative.

      See the formula for an alternative method using Python.
    EOS
  end

end
