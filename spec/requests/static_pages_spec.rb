# frozen_string_literal: true

require 'rails_helper'

describe StaticPagesController, type: :request do
  describe 'GET #accessibility_statement' do
    subject { get accessibility_statement_path }

    it_behaves_like 'a static page'
  end

  describe 'GET #cookies' do
    subject { get cookies_path }

    it_behaves_like 'a static page'
  end

  describe 'GET #privacy_notice' do
    subject { get privacy_notice_path }

    it_behaves_like 'a static page'
  end
end
