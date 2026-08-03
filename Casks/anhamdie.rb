cask "anhamdie" do
  version "1.2.0"
  sha256 "d18595fe7eca241fc07d34fd6a5c8bd014211b80ab67672dc2f029e3b681212c"

  url "https://github.com/splguyjr/anham-die/archive/refs/tags/v#{version}.tar.gz"
  name "AnhamDie"
  desc "Menu bar to-do app for macOS - floating overlay, daily briefing, Jira-style rollover"
  homepage "https://github.com/splguyjr/anham-die"

  depends_on macos: ">= :sequoia"

  # 소스 빌드 cask: 서명·공증 없이 배포하기 위해 사용자 Mac에서 로컬 빌드한다
  # (로컬 빌드 산출물은 Gatekeeper 격리가 없다). cask는 샌드박스 없이 실행되므로
  # SPM 의존성 다운로드·자체 샌드박스 모두 정상 동작한다. 빌드 후 app 스탠자가
  # /Applications 설치·업그레이드·제거를 관리한다.
  preflight do
    system_command "/bin/bash",
                   args: ["-c", "cd '#{staged_path}/anham-die-#{version}' && bash Scripts/build-app.sh"],
                   print_stdout: true
  end

  app "anham-die-#{version}/dist/AnhamDie.app"

  zap trash: [
    "~/Library/Application Support/AnhamDie",
    "~/Library/Preferences/com.splguyjr.anhamdie.plist",
  ]

  caveats <<~EOS
    /Applications/AnhamDie.app 으로 설치되었습니다. 실행:
      open /Applications/AnhamDie.app

    메뉴바 상주 앱입니다 (Dock 아이콘·로그인 자동 실행은 앱 설정에서).
    전역 단축키: ⌥⌘T 브리핑 · ⌥⌘O 오버레이 · ⌥⌘N 빠른 추가 · ⌥⌘M 메인 창
    macOS 15(Sequoia) 이상 필요. 소스 빌드라 설치에 1~2분 걸립니다.
    제거: brew uninstall anhamdie (데이터까지 지우려면 brew uninstall --zap anhamdie)
  EOS
end
