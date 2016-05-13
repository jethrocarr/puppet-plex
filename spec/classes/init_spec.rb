require 'spec_helper'
describe 'plex' do

  context 'with defaults for all parameters' do
    it { should contain_class('plex') }
  end
end
