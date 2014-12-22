cask :v1 => 'mega-sync' do
  version :latest
  sha256 :no_check

  url 'https://mega.co.nz/MEGAsyncSetup.dmg'
  homepage 'https://mega.co.nz/#sync'

  app 'MEGAsync.app', :target => '/Applications/MEGAsync.app'

  caveats 'For security reasons, MEGAsync must be installed to /Applications and therefor is installed there.'
end
