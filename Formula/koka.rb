require "language/haskell"

class Koka < Formula
  include Language::Haskell::Cabal

  desc "Function-oriented language seperating pure values from side-effects"
  homepage "https://github.com/koka-lang/koka"
  url "https://github.com/koka-lang/koka.git",
    :revision => "1bf86946cdf02d1f4eae7950782495220a741e1d"
  version "0.9.0-dev-2018-09-01"
  head "https://github.com/koka-lang/koka.git"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    # Build and install the package.
    install_cabal_package :using => "alex"

    # koka with version appended
    koka_ver = "koka-#{version}"

    # Install the contrib and lib directories.
    (lib/koka_ver).install Dir["contrib", "lib"]

    # Move the executable for the wrapper script below.
    (bin/"koka").rename (lib/koka_ver/"koka")

    dir = "#{HOMEBREW_PREFIX}/lib/#{koka_ver}"

    # This wrapper script includes the standard library.
    (bin/koka_ver).write <<~EOS
      #!/bin/bash
      #{dir}/koka -i#{dir}/lib "$@"
    EOS

    # Install a version-less command.
    bin.install_symlink bin/koka_ver => "koka"
  end

end
