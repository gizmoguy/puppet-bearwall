require 'spec_helper'

describe 'bearwall' do

  context 'on unsupported distributions' do
    let(:facts) {{ :osfamily => 'Unsupported' }}

    it 'it fails' do
      expect { subject.call }.to raise_error(/not supported on an Unsupported/)
    end
  end

  context 'on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistid => 'Debian',
      :lsbdistcodename => 'wheezy'
    }}

    it 'includes bearwall::repo::apt' do
      should contain_class('bearwall::repo::apt')
    end

    it { should contain_apt__source('bearwall-repo').with(
      'location'    => 'http://packages.bearwall.org/',
      'release'     => 'wheezy',
      'repos'       => 'main',
      'include_src' => false,
      'key'         => 'A2D0D6AE'
    )}
  end

  ['Debian'].each do |distro|
    context "on #{distro}" do
      let(:facts) {{
        :osfamily => distro,
        :lsbdistid => distro,
        :lsbdistcodename => 'squeeze',
      }}

      it { should contain_class('bearwall::install') }
      it { should contain_class('bearwall::config') }

      describe 'package installation' do
        it { should contain_package('bearwall').with(
          'ensure' => 'installed',
          'name'   => 'bearwall'
        )}
      end

      describe 'configure firewall rules' do
        let(:params) {{
          :interfaces => {
            'eth0' => {
              'policies' => [
                'policy in ACCEPT --protocol tcp --destination-port ssh',
                'policy out ACCEPT'
              ],
              'if_features' => [
                'disable_ipv6 0',
                'forwarding 1',
              ]
            },
            'lo' => {
              'policies' => [
                'policy in ACCEPT',
                'policy out ACCEPT',
              ],
              'if_features' => [
                'forwarding 0',
                'accept_ra 0',
              ]
            },
          }
        }}

        it 'should configure eth0.if' do
          should contain_file('eth0.if') \
          .with_path('/etc/bearwall/interfaces.d/eth0.if') \
          .with_ensure('file') \
          .with_content(/on_startup/) \
          .with_content(/policy in ACCEPT.*ssh/) \
          .with_content(/policy out ACCEPT/) \
          .with_content(/if_feature disable_ipv6 0/) \
          .with_content(/if_feature forwarding 1/)
        end

        it 'should configure lo.if' do
          should contain_file('lo.if') \
          .with_path('/etc/bearwall/interfaces.d/lo.if') \
          .with_ensure('file') \
          .with_content(/on_startup/) \
          .with_content(/policy in ACCEPT/) \
          .with_content(/policy out ACCEPT/) \
          .with_content(/if_feature forwarding 0/) \
          .with_content(/if_feature accept_ra 0/)
        end
      end
    end
  end

end
