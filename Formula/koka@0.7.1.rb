require "language/haskell"

class Koka < Formula
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
    sha256 "dc7fe0b9a3b0a342e454da1e898f8a3524c1b5edaaf7a60d451d29a73c1e6034"
  end

  # Hide the (<>) Prelude import to work with newer GHC versions.
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/koka-0.7.1-imports.patch"
    sha256 "2b02ba397c0478bf9244903c2dd524396ada9ea8db7fc091fe58597e2bccfc62"
  end

  def wrapper_script
    <<~EOS
      #!/bin/bash
      #{prefix}/_bin/koka -i#{lib} "$@"
    EOS
  end

  def install
    ENV["VERSION"] = "#{version}"
    ENV["VARIANT"] = "release"

    install_cabal_package "--bindir=#{prefix}/_bin", :using => "alex"
    (bin/"koka").write wrapper_script
    (lib/"koka").install Dir["lib/*"]
  end

end
