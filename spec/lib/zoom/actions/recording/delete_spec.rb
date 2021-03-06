# frozen_string_literal: true

require 'spec_helper'

describe Zoom::Actions::Recording do
  let(:zc) { zoom_client }
  let(:args) { { recording_id: 'kEFomHcIRgqxZT8D086O6A', meeting_id: 933560800 } }

  describe '#recording_delete action' do
    before :each do
      stub_request(
        :delete,
        zoom_url("/meetings/#{args[:meeting_id]}/recordings/#{args[:recording_id]}")
      ).to_return(
        status: 204,
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it "requires a 'meeting_id' and 'recording_id' argument" do
      expect {
        zc.recording_delete(filter_key(args, :meeting_id))
      }.to raise_error(Zoom::ParameterMissing)
      expect {
        zc.recording_delete(filter_key(args, :recording_id))
      }.to raise_error(Zoom::ParameterMissing)
    end

    it 'returns a status code' do
      expect(zc.recording_delete(args)).to eq 204
    end
  end

  describe '#recording_delete! action' do
    it 'raises NoMethodError exception' do
      expect {
        zc.recording_delete!(args)
      }.to raise_error(NoMethodError)
    end
  end
end
