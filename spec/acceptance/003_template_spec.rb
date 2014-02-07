require 'spec_helper_acceptance'

require_relative './json_docs.rb'


describe "elasticsearch template define:" do

  shell("mkdir -p #{default['distmoduledir']}/another/files")
  shell("echo #{good_json} >> #{default['distmoduledir']}/another/files/good.json")
  shell("echo #{bad_json} >> #{default['distmoduledir']}/another/files/bad.json")

  describe "Insert a template with valid json content" do

    it 'should run successfully' do
      pp = "elasticsearch::template { 'foo': ensure => 'present', file => 'puppet:///modules/another/good.json' }"

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

  end

  describe "Insert a template with bad json content" do

    it 'run should fail' do
      pp = "elasticsearch::template { 'foo': ensure => 'present', file => 'puppet:///modules/another/bad.json' }"

      # Run it twice and test for idempotency
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to match(error)
    end

  end


end

