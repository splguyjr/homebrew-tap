class Anhamdie < Formula
  desc "Menu bar to-do app for macOS - floating overlay, daily briefing, Jira-style rollover"
  homepage "https://github.com/splguyjr/anham-die"
  url "https://github.com/splguyjr/anham-die/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f339634369d0ceb104eabee994a33d73ee396d3786c56ae224e9a6b0236a8c10"
  license "MIT"
  head "https://github.com/splguyjr/anham-die.git", branch: "main"

  depends_on macos: :sequoia

  def install
    # SPM이 KeyboardShortcuts 의존성을 받아 릴리즈 빌드 후 dist/AnhamDie.app을 조립한다.
    # brew 샌드박스 안에서는 SPM 자체 샌드박스가 중첩 금지로 실패하므로 해제 플래그 사용.
    ENV["ANHAM_DISABLE_SPM_SANDBOX"] = "1"
    system "bash", "Scripts/build-app.sh"
    prefix.install "dist/AnhamDie.app"
  end

  def caveats
    <<~EOS
      앱을 Applications에 연결하고 실행하세요:
        ln -sfn "#{opt_prefix}/AnhamDie.app" ~/Applications/AnhamDie.app
        open ~/Applications/AnhamDie.app

      메뉴바 상주 앱입니다 (Dock 아이콘·로그인 자동 실행은 앱 설정에서).
      전역 단축키: ⌥⌘T 브리핑 · ⌥⌘O 오버레이 · ⌥⌘N 빠른 추가 · ⌥⌘M 메인 창
      macOS 15(Sequoia) 이상 필요.
    EOS
  end

  test do
    assert_path_exists prefix/"AnhamDie.app/Contents/MacOS/AnhamDie"
  end
end
