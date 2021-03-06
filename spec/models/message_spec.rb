# -*- coding: utf-8 -*-
require 'spec_helper'

describe Message do
  it { should belong_to :snippet }
  it { should have_many :stars }
  it { should validate_presence_of :raw_content }

  subject { described_class.new }

  shared_examples '#parse_content' do
    it do
      subject.raw_content = regular_message
      expect(subject.parse_content).to be_true
    end

    it do
      subject.raw_content = regular_message
      subject.parse_content
      expect(subject.time).to eq('16:31')
      expect(subject.nick).to eq('lighty_z')
      expect(subject.content).to eq('rspecに詳しい方すいません')
    end
  end

  context 'Mac LimeChat log' do
    let(:regular_message) { '16:31 lighty_z: rspecに詳しい方すいません' }

    it_behaves_like '#parse_content'
  end

  context 'Windows LimeChat log' do
    let(:regular_message) { '16:31 (lighty_z) rspecに詳しい方すいません' }

    it_behaves_like '#parse_content'
  end

  context 'WeeChat log format1' do
    let(:regular_message) { "2013-03-04 03:51:33\ttikeda\tこれ取り込みたいんですけど" }

    it {
      subject.raw_content = regular_message
      subject.parse_content
      expect(subject.time).to eq('2013-03-04 03:51:33')
    }
  end

  context 'WeeChat log format2' do
    let(:regular_message) { "11:58:48  antipop_ | git commit -m '...'が紹介されていますが" }

    it {
      subject.raw_content = regular_message
      subject.parse_content
      expect(subject.time).to eq('11:58:48')
      expect(subject.nick).to eq('antipop_')
      expect(subject.content).to eq("git commit -m '...'が紹介されていますが")
    }
  end

  context 'Textual log1' do
    let(:regular_message) { '[16:31:00] lighty_z: rspecに詳しい方すいません' }

    it {
      subject.raw_content = regular_message
      subject.parse_content
      expect(subject.time).to eq('16:31:00')
      expect(subject.nick).to eq('lighty_z')
      expect(subject.content).to eq('rspecに詳しい方すいません')
    }
  end

  context 'Textual log2' do
    let(:regular_message) { "16:31:00 lighty_z:\t rspecに詳しい方すいません" }

    it {
      subject.raw_content = regular_message
      subject.parse_content
      expect(subject.time).to eq('16:31:00')
      expect(subject.nick).to eq('lighty_z')
      expect(subject.content).to eq('rspecに詳しい方すいません')
    }
  end

  context 'Unknown client 54' do # http://iiirc.org/snippets/54
    let(:regular_message) { '16:31 lighty_z rspecに詳しい方すいません' }

    it_behaves_like '#parse_content'
  end
end
