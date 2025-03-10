class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://apps.kde.org/kcachegrind/"
  url "https://download.kde.org/stable/release-service/24.12.2/src/kcachegrind-24.12.2.tar.xz"
  sha256 "3dc95c6ddcb7c59bfa8963c0f839ea343bce74b9209cb379273eda85cdbd8548"
  license "GPL-2.0-or-later"
  head "https://invent.kde.org/sdk/kcachegrind.git", branch: "master"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "4b26d1dde594b9bcd43e32ac0a0e0921d9118f05dde013eb584362139e2424f9"
    sha256 cellar: :any,                 arm64_ventura: "fc4dcc3c47e4c5c81853d32bb1a62cb4641d9f4b9bd6fe7396b03b59291af61e"
    sha256 cellar: :any,                 sonoma:        "3a4ddcae97cf544effabea2822924b8745fca5a7923e2361a049603ecdb1bc69"
    sha256 cellar: :any,                 ventura:       "3c6f54772ec4fcf2a4ceafe3278f628f7629f1cddb24bc796e790284402be506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4dac3b169e6351f10cc638746a9f3cb78743bede543a8ba20bdd699a3e1d9e"
  end

  depends_on "graphviz"
  depends_on "qt"

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    qt = Formula["qt"]
    system qt.opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
