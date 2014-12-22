cask :v1 => 'popcorn-time' do
  version :latest
  sha256 :no_check

  url 'http://popcorn-time.se/PopcornTime-latest.dmg'
  homepage 'http://popcorn-time.se'
  license :oss

  app 'PopcornTime.app'
end
