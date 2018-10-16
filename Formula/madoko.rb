require "language/node"

class Madoko < Formula
  desc "..."
  homepage "..."
  url "https://github.com/koka-lang/madoko.git",
    :revision => "5cee03a0e38177792635153dccc7616e34ed475b"
  version "1.1.6"

  depends_on "node"
  depends_on "spl/koka/koka@0.6.0-dev" => :build

  def install
    # Build Madoko with Koka and put files into lib/
    system "koka-0.6.0-dev", "-isrc", "-c", "-olib", "--outname=madoko", "main"

    # Move other files into lib/
    mv Dir["src/cli.js", "contrib/*/*.js"], "lib"

    # Install with npm
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

end
