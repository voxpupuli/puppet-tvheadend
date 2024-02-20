# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'tvheadend class' do
  context 'admin username and password set' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'tvheadend':
        admin_username => 'foo',
        admin_password => 'bar',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('tvheadend') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
