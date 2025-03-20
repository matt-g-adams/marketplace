# frozen_string_literal: true

require 'rate_limiter'

RSpec.describe RateLimiter do
  describe '#initialize' do
    it 'creates a rate_limiter' do
      expect(RateLimiter.new).to be_instance_of(RateLimiter)
    end
  end

  describe '#allow_request?' do
    before do
      @rate_limiter = RateLimiter.new
    end

    context 'with no requests' do
      it 'allows a request' do
        expect(@rate_limiter.allow_request?(1, 1)).to be_truthy
      end
    end

    context 'with 2 requests by a user' do
      before do
        @rate_limiter.allow_request?(1, 1)
        @rate_limiter.allow_request?(2, 1)
      end

      it 'allows an immediate request by the same user' do
        expect(@rate_limiter.allow_request?(3, 1)).to be_truthy
      end
    end

    context 'with 3 requests by a user' do
      before do
        @rate_limiter.allow_request?(1, 1)
        @rate_limiter.allow_request?(2, 1)
        @rate_limiter.allow_request?(3, 1)
      end

      it 'disallows an immediate request by the same user' do
        expect(@rate_limiter.allow_request?(4, 1)).to be_falsey
      end

      it 'allows an immediate request by another user' do
        expect(@rate_limiter.allow_request?(4, 2)).to be_truthy
      end

      it 'disallows a request by the same user exactly 30 seconds after the 1st request' do
        expect(@rate_limiter.allow_request?(31, 1)).to be_falsey
      end

      it 'allows a request by the same user more than 30 seconds after the 1st request' do
        expect(@rate_limiter.allow_request?(32, 1)).to be_truthy
      end

      context 'with a 4th request by the user that is disallowed' do
        before do
          @rate_limiter.allow_request?(4, 1)
        end

        it 'does not count the disallowed request against the rate limit' do
          expect(@rate_limiter.allow_request?(32, 1)).to be_truthy
        end
      end
    end
  end
end
