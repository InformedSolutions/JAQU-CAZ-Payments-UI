# frozen_string_literal: true

require 'rails_helper'

describe Security::HostHeaderValidator do
  subject { described_class.call(request: request, allowed_hosts: allowed_hosts) }

  let(:request) do
    instance_double(ActionDispatch::Request, x_forwarded_host: x_forwarded_host,
                                             get_header: any_host)
  end
  let(:allowed_host) { 'example.com' }
  let(:x_forwarded_host) { nil }
  let(:any_host) { nil }

  describe 'when single host defined in configuration' do
    let(:allowed_hosts) { 'example.com' }

    context 'when allowed_hosts is defined and host matched it' do
      let(:allowed_hosts) { '.example.com' }
      let(:x_forwarded_host) { 'example.com' }

      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when x_forwarded_host does not match the allowed host' do
      let(:x_forwarded_host) { 'hacked.com' }

      it 'raises `InvalidHostException` exception' do
        expect { subject }.to raise_exception(InvalidHostException)
      end
    end

    context 'when x_forwarded_host match the allowed host' do
      let(:x_forwarded_host) { 'example.com' }

      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when host header does not match the allowed host' do
      let(:any_host) { 'hacked.com' }

      it 'raises `InvalidHostException` exception' do
        expect { subject }.to raise_exception(InvalidHostException)
      end
    end

    context 'when host header match the allowed host' do
      let(:any_host) { 'example.com' }

      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when hosts were not changed or not provided' do
      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe 'when multiple hosts defined in configuration' do
    let(:allowed_hosts) { 'test.com,example.com' }

    context 'when allowed_hosts is defined and host matched it' do
      let(:allowed_hosts) { 'test.com,.example.com' }
      let(:x_forwarded_host) { 'example.com' }

      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when x_forwarded_host does not match any of the allowed hosts' do
      let(:x_forwarded_host) { 'hacked.com' }

      it 'raises `InvalidHostException` exception' do
        expect { subject }.to raise_exception(InvalidHostException)
      end
    end

    context 'when x_forwarded_host match any of the allowed hosts' do
      let(:x_forwarded_host) { 'example.com' }

      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when host header does not match any of the allowed hosts' do
      let(:any_host) { 'hacked.com' }

      it 'raises `InvalidHostException` exception' do
        expect { subject }.to raise_exception(InvalidHostException)
      end
    end

    context 'when host header match any of the allowed hosts' do
      let(:any_host) { 'example.com' }

      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when hosts were not changed or not provided' do
      it 'does not raise exception InvalidHostException' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
