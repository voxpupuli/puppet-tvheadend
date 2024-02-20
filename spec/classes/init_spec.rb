# frozen_string_literal: true

require 'spec_helper'

describe 'tvheadend' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('tvheadend') }
      it { is_expected.to contain_class('tvheadend::install') }
      it { is_expected.to contain_class('tvheadend::config') }
      it { is_expected.to contain_class('tvheadend::service') }
      it { is_expected.to contain_apt__source('tvheadend') }
      it { is_expected.to contain_package('tvheadend') }
      it { is_expected.to contain_debconf('tvheadend/webinterface') }
      it { is_expected.to contain_debconf('tvheadend/admin_username').with_value('hts') }
      it { is_expected.not_to contain_debconf('tvheadend/admin_password') }
      it { is_expected.to contain_service('tvheadend').with_ensure('true') }
      it { is_expected.to contain_service('tvheadend').with_start('true') }
      it { is_expected.to contain_user('hts').with_home('/var/lib/hts') }
      it { is_expected.to contain_group('hts').with_system(true) }
      it { is_expected.to contain_shellvar('TVH_USER').with_value('hts') }
      it { is_expected.to contain_shellvar('TVH_USER').with_target('/etc/default/tvheadend') }
      it { is_expected.to contain_shellvar('TVH_GROUP').with_value('hts') }
      it { is_expected.to contain_shellvar('TVH_GROUP').with_target('/etc/default/tvheadend') }

      context 'with all parameters set' do
        let(:params) do
          {
            release: 'stable',
            distribution: 'mine',
            user: 'steve',
            group: 'tray',
            home: '/tmp/h',
            secondary: %w[one two],
            admin_username: 'foo',
            admin_password: 'bar'
          }
        end

        it { is_expected.to contain_apt__source('tvheadend').with_release('mine') }
        it { is_expected.to contain_apt__source('tvheadend').with_repos('main') }
        it { is_expected.to contain_user('steve').with_gid('tray') }
        it { is_expected.to contain_user('steve').with_groups(%w[one two]) }
        it { is_expected.to contain_group('tray') }
        it { is_expected.to contain_shellvar('TVH_USER').with_value('steve') }
        it { is_expected.to contain_shellvar('TVH_GROUP').with_value('tray') }
        it { is_expected.to contain_debconf('tvheadend/admin_username').with_value('foo') }
        it { is_expected.to contain_debconf('tvheadend/admin_password').with_value('bar') }
      end
    end
  end
end
