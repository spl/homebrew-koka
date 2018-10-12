require "language/haskell"

class KokaAT071 < Formula
  include Language::Haskell::Cabal

  desc "Function-oriented language seperating pure values from side-effects"
  homepage "https://github.com/koka-lang/koka"
  url "https://github.com/koka-lang/koka/archive/v0.7.1.tar.gz"
  sha256 "86ec61d7293e4d417d518b7181e97fc6d798c66bc025277ca9a92354f80dd02f"
  head "https://github.com/koka-lang/koka.git"

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

  # Fix include path (-i)
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/koka-0.7.1-include-path.patch"
    sha256 "ce36d8c00f979ce841097bfa94516da7132e4959c154edd8d9a271cd00db5589"
  end

  def install
    ENV["VERSION"] = "#{version}"
    ENV["VARIANT"] = "release"

    install_cabal_package :using => "alex"
    (bin/"koka").rename (bin/"koka-bin-#{version}")
    (lib/"koka-#{version}").install Dir["lib/*"]
    (bin/"koka-#{version}").write <<~SH
      #!/bin/bash
      koka-bin-#{version} -i/usr/local/lib/koka-#{version} "$@"
    SH
  end

end
