require "language/node"

class Madoko < Formula
  desc "..."
  homepage "..."
  url "https://github.com/koka-lang/madoko.git",
    :revision => "5cee03a0e38177792635153dccc7616e34ed475b"
  sha256 "..."

  depends_on "node"
  depends_on "spl/koka/koka@0.6.0-dev" => :build

  # Fix build to use brew-installed koka-0.6.0-dev.
  patch do
    url "https://raw.githubusercontent.com/spl/homebrew-koka/master/patch/madoko-1.1.6-jakefile.patch"
    sha256 "a8b1816c9daabc45457c6dcf25e0f8301e9aa9e4968d0b5c9268980712c8463d"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

end
